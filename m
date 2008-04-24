Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbYDXOxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbYDXOxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYDXOxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:53:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33134 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752385AbYDXOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:53:44 -0400
Date: Thu, 24 Apr 2008 15:24:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424152436.6cf53c1b@the-village.bc.nu>
In-Reply-To: <481096C3.2020206@redhat.com>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	<20080424112514.055d8071@the-village.bc.nu>
	<481096C3.2020206@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think this is a viable approach because it is not about the
> range.  People can and do select arbitrary values for those types.
> Until a value is officially recognized and registered it is in fact best
> to choose a (possibly large) random value to not conflict with anything
> else.  Who can guarantee that whatever bit is chosen for SOCK_CLOEXEC
> isn't already used by someone?

There are only a small number of valid socket types recognized by POSIX
plus a few BSD plus a few Linux ones so Linux can happily assign the
upper bits for a different purpose.

> Add to this that it's not a complete solution (no such hack possible for
> accept) and I think using a new interface is cleaner(tm).

Every other property of a socket via accept() is inherited from the
parent. Making one property different would be bizarre and ugly.

Alan
