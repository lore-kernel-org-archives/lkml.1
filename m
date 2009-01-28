Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZA1U7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZA1U7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbZA1Uqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:46:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44368 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760020AbZA1Uqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:46:45 -0500
Date: Wed, 28 Jan 2009 20:47:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: bmckinlay@perle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/80] tty: extract the pty init time special cases
Message-ID: <20090128204705.7140d5fd@lxorguk.ukuu.org.uk>
In-Reply-To: <OF7AEEC39E.E1555596-ON8525754C.006E408A-8525754C.0071A192@perle.com>
References: <20090122124042.7251ff0f@lxorguk.ukuu.org.uk>
	<OF7AEEC39E.E1555596-ON8525754C.006E408A-8525754C.0071A192@perle.com>
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

> So you are saying that if I merge my ptyx module into the kernel tree THEN 
> these
> exports would be added?  They would have to be, since I would still want 

It would then seem reasonable to do so

> my 
> driver to be a module instead of statically linked with the kernel like 
> pty is.

Sure - although it might make more sense to add any neede features to the
generic pty driver - hard to tell when you don't seem interested in
discussing that.

> I think the fact that you had to "ask at the time what other PTY drivers 
> there 
> were" indicates that these symbols should have been simply exported to 
> avoid 
> any problems with out of tree PTY drivers.

The linux kernel doesn't carry extra symbols for out of tree drivers. Why
should it - even keeping an index of them would be hard and it would be
impossible to know which ones are in use. Plus they change regularly -
the tty layer will change further soon for example, it's just having a
settling in period before the next big changes.

> By not exporting these symbols it means that the Linux kernel is now 
> forcing 
> anyone who wants to develop a PTY type TTY driver to be merged into the 
> kernel 
> tree by not exporting these TTY functions. This doesn't seem very "open 
> and 
> flexible".

No you can provide the GPL symbol exports with the same patch as your pty
driver. There are millions of Linux users and each unused EXPORT_SYMBOL
costs memory to all those people - why should they carry that burden ?

Alan
