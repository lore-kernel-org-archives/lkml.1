Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbXGDLH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbXGDLH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761301AbXGDLHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:07:48 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1152 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761305AbXGDLHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:07:47 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] NTP: remove clock_was_set() call to prevent deadlock
Date: Wed, 4 Jul 2007 13:06:59 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>
References: <1183485920.3291.28.camel@chaos>
In-Reply-To: <1183485920.3291.28.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041307.01116.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 03 July 2007, Thomas Gleixner wrote:

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

That's a bit of an easy solution and doesn't fix the real problem. The 
clock_was_set() calls were correct, what's broken is the locking. Why wasn't 
that fixed instead?
I would at least like to see a comment there, why these calls were removed.

bye, Roman
