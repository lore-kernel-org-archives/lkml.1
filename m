Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbYE3Fdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbYE3Fdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYE3Fdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:33:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:57952 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYE3Fdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:33:32 -0400
Subject: Re: [PATCH] x86: Get irq for hpet timer
From: Kevin Hao <kexin.hao@windriver.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
In-Reply-To: <Pine.LNX.4.55.0805291319250.8254@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>
	 <482D49CF.4030902@ladisch.de> <1210929270.11912.3.camel@kevin-desktop>
	 <4831A678.5070208@ladisch.de> <1211274219.8718.7.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
	 <4833DD38.2010702@ladisch.de>
	 <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl>
	 <1211441231.7323.10.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl>
	 <1211971330.6085.33.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805290348350.29522@cliff.in.clinika.pl>
	 <1212057664.8343.29.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805291319250.8254@cliff.in.clinika.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 30 May 2008 13:32:05 +0800
Message-Id: <1212125525.8050.23.camel@kevin-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-OriginalArrivalTime: 30 May 2008 05:31:45.0343 (UTC) FILETIME=[72EF8CF0:01C8C216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 15:32 +0100, Maciej W. Rozycki wrote:

> CONFIG_PCI is optional for the x86 platform.  You could argue this is a
> bug in acpi_register_gsi() and I tend to agree -- I think the existence of
> the ELCR is implied for ACPI-compliant systems, though I am happy to be
> corrected.  The ACPI spec does not mention the register, but quotes:  
> "Existing industry standard register interfaces to: CMOS, PIC, PITs, ..."

Oh, I overlook the existence of CONFIG_PCI.

After look into the code, I think we should add a acpi_pic_set_trigger
to replace eisa_set_level_irq and remove CONFIG_PCI dependency.

> 
>  Anyway, blindly attaching to an IRQ line is not a terribly good idea as
> there may be an edge-triggered line from a device wired there after all. 

Yes, I agree with you. But at present we have not a better way to
resolve this problem. 

Thanks,
Kevin

