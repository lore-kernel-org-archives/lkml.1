Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYEIIaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYEIIaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 04:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYEIIaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 04:30:17 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:59561 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYEIIaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 04:30:15 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7 40% regression with 2.6.26-rc1)
From: Andi Kleen <andi@firstfloor.org>
References: <1210214696.3453.87.camel@ymzhang>
	<alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org>
	<1210219729.3453.97.camel@ymzhang>
	<alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org>
	<20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu>
	<alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org>
	<20080508201956.GA2547@elte.hu>
	<alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
	<20080508214557.GA13311@elte.hu>
	<alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org>
	<20080509001647.244393bc@core>
	<alpine.LFD.1.10.0805081631440.2940@woody.linux-foundation.org>
Date: Fri, 09 May 2008 10:29:14 +0200
In-Reply-To: <alpine.LFD.1.10.0805081631440.2940@woody.linux-foundation.org> (Linus Torvalds's message of "Thu, 8 May 2008 16:33:40 -0700 (PDT)")
Message-ID: <871w4bnan9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 May 2008 08:22:17.0385 (UTC) FILETIME=[CB088190:01C8B1AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Well, it turns out that Ingo's fixed statistics actually put the real cost 
> in fcntl/ioctl/open/release:
>
>     310  down <= lock_kernel <= sys_fcntl <= system_call_after_swapgs <

That must be ->fasync? If it was file locks the lock_kernel would not
be inlined into sys_fcntl. Or is that an truncated back trace?

-Andi (wondering if he should plug ->fasync_unlocked again ...)
