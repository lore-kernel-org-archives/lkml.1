Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbYEHXhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbYEHXhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYEHXhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:37:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46119 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754192AbYEHXhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:37:01 -0400
Date: Fri, 9 May 2008 00:27:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
Message-ID: <20080509002707.67f79d3b@core>
In-Reply-To: <alpine.LFD.1.10.0805081631440.2940@woody.linux-foundation.org>
References: <1210214696.3453.87.camel@ymzhang>
	<alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org>
	<1210219729.3453.97.camel@ymzhang>
	<alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org>
	<20080508120130.GA2860@elte.hu>
	<20080508122802.GA4880@elte.hu>
	<alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org>
	<20080508201956.GA2547@elte.hu>
	<alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
	<20080508214557.GA13311@elte.hu>
	<alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org>
	<20080509001647.244393bc@core>
	<alpine.LFD.1.10.0805081631440.2940@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     380  down <= lock_kernel <= tty_release <= __fput <
>     422  down <= lock_kernel <= chrdev_open <= __dentry_open <
> 
> rather than the write routines. But it may be that Ingo was just profiling 
> two different sections, and it's really all of them.

tty release is probably a few months away from getting cured  - I'm
afraid it will almost certainly be the very last user of the BKL in tty
to get fixed as it depends on everything else being sanely locked.
