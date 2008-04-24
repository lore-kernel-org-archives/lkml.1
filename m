Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYDXPyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYDXPyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYDXPxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:53:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37872 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753110AbYDXPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:53:47 -0400
Date: Thu, 24 Apr 2008 16:24:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424162444.1c5b9ba2@the-village.bc.nu>
In-Reply-To: <20080424154441.GG2255@devserv.devel.redhat.com>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	<20080424112514.055d8071@the-village.bc.nu>
	<481096C3.2020206@redhat.com>
	<20080424152436.6cf53c1b@the-village.bc.nu>
	<4810A46B.1090809@redhat.com>
	<20080424160352.30f2dd5b@the-village.bc.nu>
	<20080424154441.GG2255@devserv.devel.redhat.com>
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

> Doing:
> 
> int fd = socket (PF_INET, SOCK_STREAM, 0);
> fcntl (fd, F_SETFD, F_CLOEXEC);
> ...
> int fd2 = accept (fd, addr, addrlen);
> 
> certainly doesn't use any of the new interfaces, yet if accept inherits
> the CLOEXEC flag from the socket, would visibly change existing programs.

The example you give doesn't involve the new interfaces so is outside of
the proposed changes but it is true that a different accept behaviour
would be odd here. Also accept() has several really really irritatingly
undefined semantics already that cause BSD v Linux pain and suffering so
maybe accept() is one case that could benefit from a flag passing version
*and* the ability to pass FNDELAY to accept to do non blocking accepts on
an fd without flipping it to/from NDELAY itself.

BTW in 4.4BSD and derivatives if I remember rightly F_CLOEXEC *is*
inherited across accept() so I doubt any user space software will be too
upset by such a shift.

Alan
