Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbXGNVHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbXGNVHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 17:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762472AbXGNVHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 17:07:37 -0400
Received: from relay5.ptmail.sapo.pt ([212.55.154.25]:36920 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1761019AbXGNVHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 17:07:36 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2007 17:07:36 EDT
X-AntiVirus: PTMail-AV 0.3-0.90.3
Date: Sat, 14 Jul 2007 22:01:17 +0100
From: =?iso-8859-1?Q?R=FAben?= Fonseca <krani1@0x82.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>
Subject: Re: libata [ata_piix] still no resume from S3 ?
Message-ID: <20070714210117.GA20723@0x82.com>
References: <20070712162450.GA7132@0x82.com> <469744DB.5070600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <469744DB.5070600@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Tejun Heo wrote:

> Rúben Fonseca wrote:
> > Hi to all!
> > 
> > I'm on Debian Sid with kernel 2.6.21 and I still can't resume my laptop
> > (Sony Vaio SZ2) from S3. Searched on the archive and it seems that SATA 
> > drives are getting problems when used via the "new" libata. When the
> > laptop tries to resume, it can't access the hard drive anymore (the LED
> > never blinks), the filesystem is mounted read-only and of course, the
> > system hangs. I still can see a "Lost interrupt" apearing on my LCD when
> > it is resuming. Sometimes it is IRQ 22, other times it is IRQ 23.
> > 
> > Is this still a know problem? Does 2.6.22 solve this already? If you
> > need more information about my environment, please ask :)
> 
> Actually, 'lost interrupt' is from the "old" IDE driver.  Care to give a
> shot at the new one?

Sorry, it was my mistake. Here's more info about the problem.
I had to copy "by hand" the trace, so I remove the hexadecimal parts
(if you need them, please ask i Will try to copy them too). For now
I just want to know if you can diagnose this problem, or need more info.
So here's the interesting (I think) part of the log after resume:

irq 23: nobody cared (try booting with the "irqpool" option)
 __report_bad_irq
 note_interrupt
 handle_IRQ_event
 handle_fasteoi_irq
 do_IRQ
 do_IRQ
 irq_exit
 smp_acpi_timer
 common_interrupt
 acpi_pm_read
 getnstimeofday
 ktime_get_ts
 ktime_egt
 tick_nohz_restart_sched_tick
 cpu_idle
 start_kernel
 unkown_bootoption
 =====
handlers:
 (ata_interrupt [libata])
 (tifm_7xx1_isr [tifm_7xx1])
Disabling IRQ #23
(...)
ATA: abnormal status 0x7F on port 0x000118cf

And hard drive never cames up.. have to hard reboot the machine..
Does it help?

Ruben

-- 
Will work for bandwidth
