Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbXGRIlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbXGRIlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXGRIlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:41:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:57742 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXGRIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=o4FPT7XoYagtGq5ouBpSSigjon5gZs6tIychK+wbB1wDIJZynrE2v1DbZXck7RIgJ9Lk09+P/TZY1/WMQ67cgamw5TdjY1cGMvT0xiQSIUnLXoLeyZGoz8PcAT9swcFMoIM4Lqi9cFEv/3jS6kOuhxAoXF+XShu6qEMlOIWpEbQ=
Message-ID: <469DD216.5040305@gmail.com>
Date: Wed, 18 Jul 2007 17:40:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=FAben_Fonseca?= <krani1@0x82.com>
CC: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata [ata_piix] still no resume from S3 ?
References: <20070712162450.GA7132@0x82.com> <469744DB.5070600@gmail.com> <20070714210117.GA20723@0x82.com>
In-Reply-To: <20070714210117.GA20723@0x82.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux-ide]

Rúben Fonseca wrote:
> On Fri, 13 Jul 2007, Tejun Heo wrote:
> 
>> Rúben Fonseca wrote:
>>> Hi to all!
>>>
>>> I'm on Debian Sid with kernel 2.6.21 and I still can't resume my laptop
>>> (Sony Vaio SZ2) from S3. Searched on the archive and it seems that SATA 
>>> drives are getting problems when used via the "new" libata. When the
>>> laptop tries to resume, it can't access the hard drive anymore (the LED
>>> never blinks), the filesystem is mounted read-only and of course, the
>>> system hangs. I still can see a "Lost interrupt" apearing on my LCD when
>>> it is resuming. Sometimes it is IRQ 22, other times it is IRQ 23.
>>>
>>> Is this still a know problem? Does 2.6.22 solve this already? If you
>>> need more information about my environment, please ask :)
>> Actually, 'lost interrupt' is from the "old" IDE driver.  Care to give a
>> shot at the new one?
> 
> Sorry, it was my mistake. Here's more info about the problem.
> I had to copy "by hand" the trace, so I remove the hexadecimal parts
> (if you need them, please ask i Will try to copy them too). For now
> I just want to know if you can diagnose this problem, or need more info.
> So here's the interesting (I think) part of the log after resume:
> 
> irq 23: nobody cared (try booting with the "irqpool" option)
>  __report_bad_irq
>  note_interrupt
>  handle_IRQ_event
>  handle_fasteoi_irq
>  do_IRQ
>  do_IRQ
>  irq_exit
>  smp_acpi_timer
>  common_interrupt
>  acpi_pm_read
>  getnstimeofday
>  ktime_get_ts
>  ktime_egt
>  tick_nohz_restart_sched_tick
>  cpu_idle
>  start_kernel
>  unkown_bootoption
>  =====
> handlers:
>  (ata_interrupt [libata])
>  (tifm_7xx1_isr [tifm_7xx1])
> Disabling IRQ #23
> (...)
> ATA: abnormal status 0x7F on port 0x000118cf
> 
> And hard drive never cames up.. have to hard reboot the machine..
> Does it help?

Hmmm... That's 'nobody cared' during resume.  Please post the result of
'lspci -nnvvv'.

-- 
tejun
