Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbYEHX10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbYEHX10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYEHX1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:27:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36189 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752199AbYEHX1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:27:16 -0400
Date: Fri, 9 May 2008 00:16:47 +0100
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
Message-ID: <20080509001647.244393bc@core>
In-Reply-To: <alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org>
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

> In fact, I thought we had fixed most of this already, but hey, I was 
> clearly wrong. I assume Alan looks at it occasionally and groans. Alan?

I have pushed it down to n_tty line discipline code but not within that.
It is on the hit list but I'm working on more pressing stuff first (USB
layer, extracting commonality to start to tackle open etc etc)

I don't think fixing n_tty is now a big job if someone wants to take a
swing at it. The driver write/throttle/etc routines below the n_tty ldisc
layer are now BKL clean so it should just be the internal locking of the
buffers, window and the like to tackle.

Feel free to have a go 8)
