Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYDWPN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYDWPN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYDWPNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:13:16 -0400
Received: from outbound-mail-159.bluehost.com ([67.222.39.39]:53076 "HELO
	outbound-mail-159.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751267AbYDWPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:13:16 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Wed, 23 Apr 2008 08:12:49 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804172140.02311.jdelvare@suse.de> <200804211414.45629.jbarnes@virtuousgeek.org> <200804231638.01479.jdelvare@suse.de>
In-Reply-To: <200804231638.01479.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804230812.49548.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2008 7:38 am Jean Delvare wrote:
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index e6abe8a..7cdf930 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -1138,14 +1138,10 @@ static int __init smp_sanity_check(unsigned
> > max_cpus) "forcing use of dummy APIC emulation.\n");
> >  		smpboot_clear_io_apic();
> >  #ifdef CONFIG_X86_32
> > -		if (nmi_watchdog == NMI_LOCAL_APIC) {
> > -			printk(KERN_INFO "activating minimal APIC for"
> > -					 "NMI watchdog use.\n");
> > -			connect_bsp_APIC();
> > -			setup_local_APIC();
> > -			end_local_APIC_setup();
> > -		}
> > +		connect_bsp_APIC();
> >  #endif
> > +		setup_local_APIC();
> > +		end_local_APIC_setup();
> >  		return -1;
> >  	}
>
> Sorry for the late reply. I tested the patch above on top of 2.6.25-git4
> and yes, it fixes my problem: booting with "nosmp" works now. Thanks!
>
> Is this patch good enough to go upstream, and if so, through whose
> tree? Adding Thomas Gleixner to Cc.

Yeah I think the patch is reasonable, would be good to get feedback from 
Thomas/Andi/Ingo though...

Jesse
