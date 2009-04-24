Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZDXKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZDXKBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZDXKBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:01:05 -0400
Received: from mx0.towertech.it ([213.215.222.73]:54727 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751725AbZDXKBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:01:04 -0400
Date: Fri, 24 Apr 2009 12:01:00 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090424120100.76797d20@i1501.lan.towertech.it>
In-Reply-To: <200904240231.12906.david-b@pacbell.net>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<200904231245.33435.david-b@pacbell.net>
	<20090423215538.256fb5ff@i1501.lan.towertech.it>
	<200904240231.12906.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 02:31:12 -0700
David Brownell <david-b@pacbell.net> wrote:

 
> >  and 
> >  acquired with the standard spinlock calls in the irq
> >  handler.
> 
> Which "standard" call?  "spin_lock", "spin_lock_irqsave",
> and "spin_lock_irq" are all standard calls.

 sorry, I mean the no irq version of the call.


> Recall that it's not the IRQ handler that's directly
> grabbing the lock; it's code called by that handler.

 
> >  would it work?
> 
> The patch I saw -- switching rtc_update_irq() to use
> spin_lock_irqsave() -- would work, but it's incomplete.
> It left the doc broken, and didn't clean up the drivers
> which did the real work to obey the current call spec.

 that patch is a no go. period. I'm not talking about it.


> It'd be much nicer if lockdep would just do the right
> thing and report when IRQ handlers do stupid things,
> instead of covering up that class of bugs.  But I'm told
> it will not get fixed; sigh.

 I'm not tying to fix call issues or lockdep politics,
 just to understand if it's possible to avoid disabling the IRQs.

 i.e.,

 use spin_lock() in the IRQ handler and spin_lock_irq/irq_save
 in the setup functions.

 


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

