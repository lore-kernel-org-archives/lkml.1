Return-Path: <linux-kernel-owner+w=401wt.eu-S1031156AbXECUb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031156AbXECUb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031286AbXECUb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:31:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:62359 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031156AbXECUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sfhq8EegYFggEtHu0l8+25xBD4bAO4l1PMcTy6b0+IQpd7qPT32bUQSrZI4nvNsqazFLILvxpO4k39NPMogDigTcjoXXyY656ixKHCsqUZ6LAIyUOe4nBsERsnDT0122H8bXlnDM3HucXiiKkx7asKyBpgGwwME0srdRS8d+gT0=
Message-ID: <6bffcb0e0705031331y4cbfafebof9522e326a989748@mail.gmail.com>
Date: Thu, 3 May 2007 22:31:23 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: [2.6.20.1] BUG: soft lockup detected on CPU#1!
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070503191120.GW7874@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503191120.GW7874@vanheusden.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> My P4 with HT and 2GB of ram on an IDE disk succeeded in triggering
> another bug:
>
> [273187.872796] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
> [273902.586320] BUG: soft lockup detected on CPU#1!
> [273902.586385]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> [273902.586472]  [<c1004d7b>] show_trace+0x12/0x14
> [273902.586557]  [<c1004e75>] dump_stack+0x16/0x18
> [273902.586636]  [<c104d52b>] softlockup_tick+0xa6/0xc2
> [273902.586724]  [<c10267ae>] run_local_timers+0x12/0x14
> [273902.586810]  [<c10265dc>] update_process_times+0x72/0xa1
> [273902.586893]  [<c1038390>] tick_sched_timer+0x53/0xb6
> [273902.586977]  [<c1033ba8>] hrtimer_interrupt+0x16b/0x1c2
> [273902.587062]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
> [273902.587147]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
> [273902.587230]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
> [273902.587312]  [<c10020f2>] cpu_idle+0x6b/0x85
> [273902.587393]  [<c130b218>] start_secondary+0xe8/0x30a
> [273902.587476]  [<00000000>] 0x0
> [273902.587568]  =======================
> [277740.475464] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
> ...
> [285799.322391] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
> [286630.885843] BUG: soft lockup detected on CPU#1!
> [286630.885901]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> [286630.885988]  [<c1004d7b>] show_trace+0x12/0x14
> [286630.886071]  [<c1004e75>] dump_stack+0x16/0x18
> [286630.886152]  [<c104d52b>] softlockup_tick+0xa6/0xc2
> [286630.886235]  [<c10267ae>] run_local_timers+0x12/0x14
> [286630.886323]  [<c10265dc>] update_process_times+0x72/0xa1
> [286630.886406]  [<c1038390>] tick_sched_timer+0x53/0xb6
> [286630.886488]  [<c1033ba8>] hrtimer_interrupt+0x16b/0x1c2
> [286630.886571]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
> [286630.886657]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
> [286630.886741]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
> [286630.886824]  [<c10020f2>] cpu_idle+0x6b/0x85
> [286630.886907]  [<c130b218>] start_secondary+0xe8/0x30a
> [286630.886991]  [<00000000>] 0x0
> [286630.887088]  =======================
> [290177.972351] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
>
> My .config can be found here: http://keetweej.vanheusden.com/~folkert/config-2.6.21.1
>
>
> Folkert van Heusden
>

Thomas, this looks very similar to
http://lkml.org/lkml/2007/5/2/511

Already on list of known regressions.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
