Return-Path: <linux-kernel-owner+w=401wt.eu-S1423411AbXD3Pil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423411AbXD3Pil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423410AbXD3Pil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:38:41 -0400
Received: from relay4.usu.ru ([194.226.235.39]:60699 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423414AbXD3Pij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:38:39 -0400
Message-ID: <46360DC0.2010404@ums.usu.ru>
Date: Mon, 30 Apr 2007 21:39:44 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Ross Alexander <ross.alexander@uk.neceur.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: Kernel oops with 2.6.21 while using cdda2wav & cooked_ioctl (x64-64)
 [untainted]
References: <4631AE19.7040705@uk.neceur.com> <4632C388.709@ums.usu.ru> <4635F462.30202@uk.neceur.com>
In-Reply-To: <4635F462.30202@uk.neceur.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Alexander wrote:

[warning: all of the below is just generic bug triage, I have no idea what 
is really wrong]

> Call Trace:
> run_timer_softirq+0x156/0x1ac
> __do_softirq+0x50/0xbb
> call_softirq+0x1c/02x8
> do_softieq+0x2f/x097
> irq_exit+0x3d/0x4f
> smp_apic_timer_interrupt+0x46/0x58
> default_idle+0x0/0x3d
> apic_timer_interrupt+0x66/0x70
> <EOI> default_idle+0x29/0x3d
> cpu_idle+0x8b/0xcc
> start_kernel+0x266/0x26f
> _sinittext+0x175/0x179

Thanks, but this has nothing specific to extracting CD audio, and is 
unrelated to the panic message you originally sent. I.e.: we have two 
reports from you, one tainted about CD grabbing, and one untainted about 
some generic IRQ-related issue. Could you please try producing an untainted 
oops with the word scsi in one of the lines?

Maybe you are just causing the drive to try hard reading data that don't 
exist, and thus deliver the IRQ at unusual time? Is this reproducible on 
non-SMP kernels?

-- 
Alexander E. Patrakov
