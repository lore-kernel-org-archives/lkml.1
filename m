Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYIJArK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYIJArK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYIJAq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:46:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:23004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYIJAq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:46:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,368,1217833200"; 
   d="scan'208";a="614586037"
Subject: Re: OOPS: getting an ACPI interrupt while in an ACPI interrupt
	hangs my box
From: Zhao Yakui <yakui.zhao@intel.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200809091605.07734.hs4233@mail.mn-solutions.de>
References: <200809091605.07734.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:01:30 +0800
Message-Id: <1221008490.3989.102.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 16:05 +0200, Holger Schurig wrote:
> I just got this OOPS:
If the system is booted with the boot option of
"processor.max_cstate=1", does the following warning message still
exist?

Of course you can open a new bug in bugzilla and attach the output of
dmesg, acpidump, lspci -vxxx.

http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

thanks.
> 
> irq 9: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Tainted: P          2.6.26.3 #3
>  [<c012f063>] __report_bad_irq+0x24/0x69
>  [<c012f06a>] __report_bad_irq+0x2b/0x69
>  [<c012f257>] note_interrupt+0x1af/0x1e4
>  [<c01cbc97>] acpi_irq+0xb/0x1c
>  [<c012e983>] handle_IRQ_event+0x1a/0x3f
>  [<c012f917>] handle_level_irq+0x63/0x84
>  [<c01046d0>] do_IRQ+0x4b/0x60
>  [<c010320f>] common_interrupt+0x23/0x28
>  [<c01d007b>] acpi_ds_create_operands+0x1c/0xf9
>  [<c0118f03>] __do_softirq+0x2c/0x75
>  [<c0118f6e>] do_softirq+0x22/0x26
>  [<c01191ea>] irq_exit+0x25/0x53
>  [<c01046d5>] do_IRQ+0x50/0x60
>  [<c010320f>] common_interrupt+0x23/0x28
>  [<c01ef3c0>] acpi_idle_enter_simple+0x16d/0x1d9
>  [<c025bdba>] cpuidle_idle_call+0x49/0x77
>  [<c025bd71>] cpuidle_idle_call+0x0/0x77
>  [<c010176c>] cpu_idle+0x48/0x61
>  =======================
> handlers:
> [<c01cbc8c>] (acpi_irq+0x0/0x1c)
> Disabling IRQ #9
> BUG: soft lockup - CPU#0 stuck for 138s! [syslogd:1952]
> 
> If I read that OOPS right, then I got an interrupt 
> ("common_interrupt"), which made the kernel run the ACPI 
> function "acpi_ds_create_operands" and while this executed, I've 
> got another interupt, which killed my for for 138 seconds ...
> 
> Shouldn't there some sort of protection about this or is the DSDT 
> of my device just bogus?
> 
> 
> 
> 
> Kernel 2.6.26.3
> 
> CPU: "Geode(TM) Integrated Processor by AMD PCS"
> 
> How to reproduce: press ACPI buttons repeatedly
> 
> ACPI related kernel-commandline entries: "pci=noacpi 
> acpi_serialize". The first is vital (no boot without), the 
> second one is an experiment, I got OOPSes without that, too.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

