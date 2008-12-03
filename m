Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYLCAxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYLCAxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYLCAxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:53:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52345 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751193AbYLCAxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:53:37 -0500
Date: Wed, 3 Dec 2008 00:53:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geoffrey McRae <geoff@rabidhost.com>
Cc: linux-kernel@vger.kernel.org, Geoffrey McRae <geoff@rabidhost.com>
Subject: Re: New Security Features, Please Comment
Message-ID: <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
In-Reply-To: <1228260494.24232.21.camel@compy.ivent.com.au>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (such as PHP) as the user that owns the website we are forced to fork a
> new process per request, then call setuid/gid and then launch the script
> language. This ofcource is resource intensive, but at present there is
> no other solution.

It's pretty much the minimal requirement for any kind of security because
you need the separate process/file environment. It's not helped by the
fact some of the scripting languages don't support an internal fork/exec
that preserves bootstrapped interpreter state but that is a different
problem.

> child processes (forked) uid/gid at any time without needing root access
> while being secure so that it can not set its child processes to users
> such as root.

You then need locking to handle all the horrible corner cases such as
changing uid during a file open. You really really want a process to
change its own uid somehow, even if that is done by some method other
than setuid.

Models that have been talked about but not implemented have included
things like passing 'authority' of some kind by file handles, so the
child receives an authority and then uses it.

Alan
