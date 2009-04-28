Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZD1NQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZD1NQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZD1NQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:16:10 -0400
Received: from relay.atmel.no ([80.232.32.139]:62751 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbZD1NQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:16:08 -0400
Date: Tue, 28 Apr 2009 15:13:53 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       david-b@pacbell.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090428151353.0c15c5fc@hcegtvedt.norway.atmel.com>
In-Reply-To: <20090425.020612.92585418.anemo@mba.ocn.ne.jp>
References: <200904240410.52543.david-b@pacbell.net>
	<20090424131334.10959f78@i1501.lan.towertech.it>
	<20090425.014850.93020801.anemo@mba.ocn.ne.jp>
	<20090425.020612.92585418.anemo@mba.ocn.ne.jp>
Organization: Atmel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 02:06:12 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> On Sat, 25 Apr 2009 01:48:50 +0900 (JST), Atsushi Nemoto
> <anemo@mba.ocn.ne.jp> wrote:
> > Here is a possible example:
> > 
> > 1. RTC alarm interrupt handler takes rtc->irq_lock by spin_lock()
> > 2. A timer interrupt handler calls rtc_uie_timer() for UIE emulation
> > 3. rtc_uie_timer() waits on rtc->irq_lock .... deadlock!
> 
> Oops, this is wrong.  This deadlock cannot happen since
> rtc_uie_timer() will be called in bh (softirq) context, not interrupt
> context.
> 
> Anyway, I just posted updated patch.  Please take a look.  Thanks.
> 

AVR32 has interrupts disabled during the interrupt handler, so AFAICT
the rtc-at32ap700x.c should be fine.

-- 
Best regards,
Hans-Christian Egtvedt
