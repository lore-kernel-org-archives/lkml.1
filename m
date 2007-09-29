Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbXI2Uln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbXI2Uln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXI2Ulg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:41:36 -0400
Received: from mail.tmr.com ([64.65.253.246]:34506 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbXI2Ulg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:41:36 -0400
Message-ID: <46FEB9CA.9090703@tmr.com>
Date: Sat, 29 Sep 2007 16:47:06 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Mark Lord <lkml@rtr.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: regression in 2.6.23-rc8 - power off failed
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com> <20070929093553.GA4451@erig.dyndns.org> <46FE47C7.6070901@rtr.ca> <46FE6E17.6070109@suse.de>
In-Reply-To: <46FE6E17.6070109@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:

> -static void
> -acpi_power_off (void)
> -{
> -       printk("%s called\n",__FUNCTION__);
> -       /* Some SMP machines only can poweroff in boot CPU */
> -       set_cpus_allowed(current, cpumask_of_cpu(0));
> ACPI in kernel 2.6.12 did disable non-boot cpus too in powe_off.
> Later only comment was left for some reason...
> 
Am I midreading that code, or does it really assume that the boot cpu is 
always zero? Or just that zero will be able to do the power off?

In any case I have had an SMP machine which did not have a CPU zero, and 
it was discussed here, I believe. Wonder what happens if you set 
affinity to a CPU you don't have...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
