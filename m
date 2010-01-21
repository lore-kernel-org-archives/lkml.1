Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672Ab0AURZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0AURZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129Ab0AURZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:25:56 -0500
Received: from percival.namespace.at ([77.244.242.130]:57138 "EHLO
	percival.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0AURZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:25:55 -0500
Date: Thu, 21 Jan 2010 18:24:45 +0100
From: Christian Hofstaedtler <ch@zeha.at>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-acpi@vger.kernel.org, venkatesh.pallipadi@intel.com,
       arjan@infradead.org, bruce.w.allan@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Default to ACPI reboots on newish X86 hardware
Message-ID: <20100121172445.GA17641@percival.namespace.at>
References: <alpine.LFD.2.00.1001061433260.4086@localhost.localdomain> <1262894593-25563-1-git-send-email-ch@zeha.at> <alpine.LFD.2.00.1001200007560.4265@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001200007560.4265@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

* Len Brown <lenb@kernel.org> [100120 06:21]:
> On Thu, 7 Jan 2010, Christian Hofstaedtler wrote:
> 
> Thanks for writing this patch Christian,
> it is something that has been unsettled for
> a long time and it will be great to close the issue.
> 
> > Newer hardware is assumed to no longer reboot succesfully using the
> > keyboard controller, but needs to use ACPI instead.
> > To not cause problems with older hardware, only hardware with a BIOS
> > date 2006 or newer is considered for this choice. Broken BIOSes
> > reporting a BIOS date of 0 are not specially considered, and therefore
> > get the KBD reboot behaviour.
> > 
> > Also unifiy reboot_type selection code.
> 
> Please split the patch in two patches:
> 
> 1. cleanup w/o policy change
> 2. policy change w/o cleanup
> 
> better if the policy change is #2, so if we need to revert it
> we don't have to revert the cleanup too.

Please find the splitted patch in reply to your mail.
 
> > Signed-off-by: Christian Hofstaedtler <ch@zeha.at>
> > ---
> >  arch/x86/include/asm/emergency-restart.h |    1 +
> >  arch/x86/kernel/reboot.c                 |   65 ++++++++++++++++++++++++------
> >  2 files changed, 53 insertions(+), 13 deletions(-)
> 
> 
> > +/* See if the Hardware is new enough to support ACPI reboots. */
> > +static int __init reboot_acpi_likey_supported(void)
> > +{
> > +        int year;
> > +
> > +	/* Doesn't exist? Likely an old system */
> > +	if (!dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL)) {
> > +		return 0;
> > +	}
> 
> I think it may be better to simply return 1 in this case.
> 
> While we have seen dmi_get_date() fail in practice on "modern" machines,
> if CONFIG_ACPI_BLACKLIST_YEAR is set, we will already punish users by
> disabling ACPI and making them invoke acpi=force.
> 
> So the effect of this check is to disable ACPI-reset
> on systems where the user has likely already invoked acpi=force --
> which seems somewhat counter-intuitive.

Okay; I've also re-added the check for year==0, so these machines
get the same behaviour.

> > +        /* 2006 was decided as the cut-off year. */
> > +	if (year < 2006) {
> > +		return 0;
> > +	}
> 
> I'd rather see 2003.
> If we run into trouble, it is a 1-liner to move it forward.
> But I think we'll probably do fine with anything newer than 2001.

Made this 2003.

> thanks,
> Len Brown, Intel Open Source Technolgy Center


  Christian

-- 
christian hofstaedtler
