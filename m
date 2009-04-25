Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZDYMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZDYMk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZDYMkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 08:40:17 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:64578 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZDYMkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 08:40:15 -0400
Date: Sat, 25 Apr 2009 21:40:15 +0900 (JST)
Message-Id: <20090425.214015.108306850.anemo@mba.ocn.ne.jp>
To: alessandro.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, david-b@pacbell.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090424214117.76bc3dda@i1501.lan.towertech.it>
References: <20090425.014850.93020801.anemo@mba.ocn.ne.jp>
	<20090425.020612.92585418.anemo@mba.ocn.ne.jp>
	<20090424214117.76bc3dda@i1501.lan.towertech.it>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 21:41:17 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> >  RTC alarm interrupt handler takes rtc->irq_lock by spin_lock()
> > > 2. A timer interrupt handler calls rtc_uie_timer() for UIE emulation
> > > 3. rtc_uie_timer() waits on rtc->irq_lock .... deadlock!  
> > 
> > Oops, this is wrong.  This deadlock cannot happen since
> > rtc_uie_timer() will be called in bh (softirq) context, not interrupt
> > context.
> 
>  Correct.
> 
>  And we have only one irq handler per driver. Anything else?

Some drivers (omap, pxa, etc.) have multiple irq handler.  Currently
all such drivers use IRQF_DISABLED so I do not see any real problem
now.

So I think my patch is rather "cleanup and bulletproof" than "bugfix".

---
Atsushi Nemoto
