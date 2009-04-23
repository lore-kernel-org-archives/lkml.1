Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZDWQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZDWQki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZDWQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:40:28 -0400
Received: from mx0.towertech.it ([213.215.222.73]:58196 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751422AbZDWQk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:40:27 -0400
Date: Thu, 23 Apr 2009 18:40:24 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: vapier.adi@gmail.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, david-b@pacbell.net,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
  irqs enabled
Message-ID: <20090423184024.39402a8f@i1501.lan.towertech.it>
In-Reply-To: <8bd0f97a0904230930w7c9ffaa4x5110c59098ff475b@mail.gmail.com>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20090409153921.04b6384c.akpm@linux-foundation.org>
	<20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<20090423.235141.61509229.anemo@mba.ocn.ne.jp>
	<20090423170253.6b6dfd21@i1501.lan.towertech.it>
	<8bd0f97a0904230807q6c40436wa561d7b26db26cef@mail.gmail.com>
	<20090423173728.4fa010fa@i1501.lan.towertech.it>
	<8bd0f97a0904230930w7c9ffaa4x5110c59098ff475b@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 12:30:58 -0400
Mike Frysinger <vapier.adi@gmail.com> wrote:

>   for the blackfin you should just check if
> >  you have locking issues in your irq routine  
> 
> the Blackfin driver calls rtc_update_irq() from its IRQ handler and
> the handler is not registered with IRQF_DISABLED.  it makes more sense
> to me to fix rtc_update_irq() than require all RTC drivers to register
> with IRQF_DISABLED.  especially in my case as the Blackfin driver
> itself doesnt need any locks.

 I agree. rtc_update_irq is not problematic by itself, it just takes
 locks that other parts of the driver should take appropriately.

 For example, if you take irq_lock with irqs enabled you
 will get in trouble. blackfin seems ok, for the other
 drivers we need to verify this.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

