Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXGCT4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXGCT4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbXGCT4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:56:33 -0400
Received: from www.osadl.org ([213.239.205.134]:52505 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757663AbXGCT4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:56:33 -0400
Subject: Re: [PATCH] NTP: remove clock_was_set() call to prevent deadlock
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@osdl.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Stable Team <stable@kernel.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
In-Reply-To: <1183485920.3291.28.camel@chaos>
References: <1183485920.3291.28.camel@chaos>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 21:56:30 +0200
Message-Id: <1183492590.3291.39.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 20:05 +0200, Thomas Gleixner wrote:
> The clock_was_set() call in seconds_overflow() which happens only when
> leap seconds are inserted / deleted is wrong in two aspects:
> 
> 1. it results in a call to on_each_cpu() with interrupts disabled
> 2. it is potential deadlock source vs. call_lock in smp_call_function()
> 
> The only possible side effect of the removal might be, that an absolute
> CLOCK_REALTIME timer fires 1 second too late, in the rare case of leap
> second deletion and an absolute CLOCK_REALTIME timer which expires in
> the affected time frame. It will never fire too early.
> 
> This was probably observed by the reporter of a June 30th -> July 1st
> hang: http://lkml.org/lkml/2007/7/3/

Ooops, missed the full reference:

http://lkml.org/lkml/2007/7/3/103

	tglx


