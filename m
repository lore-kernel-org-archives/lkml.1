Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbYDXKyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbYDXKyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYDXKx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:53:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36431 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581AbYDXKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:53:58 -0400
Date: Thu, 24 Apr 2008 11:25:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424112514.055d8071@the-village.bc.nu>
In-Reply-To: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
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

> - I decided against using the O_* flags here.  Most are not useful and
>   we might need the bits for something else at some time.  Hence the
>   new SOCKFL_* flag.  The intend is to define SOCKFL_CLOEXEC and
>   O_CLOEXEC to the same value.  In this case there is zero overhead.

Given we will never have 2^32 socket types, and in a sense this is part
of the type why not just use

	socket(PF_INET, SOCK_STREAM|SOCK_CLOEXEC, ...)

that would be far far cleaner, no new syscalls on the socket side at all.

Alan
