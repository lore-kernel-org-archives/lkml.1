Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbZBDNJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbZBDNJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757134AbZBDNEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:04:09 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:37738 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbZBDNEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:04:08 -0500
X-BigFish: VPS-22(zz1432R98dR1805M936fM8b9dnzzzzz32i6bh6di62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KEJLMH-02-QN7-01
Date: Wed, 4 Feb 2009 14:03:53 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <markh@compro.net>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: APIC: enable workaround on AMD Fam10h CPUs
Message-ID: <20090204130353.GA15084@aftab>
References: <20090203172200.GA3955@aftab> <49898CE8.1030605@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <49898CE8.1030605@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 04 Feb 2009 13:03:57.0044 (UTC) FILETIME=[09F61340:01C986C9]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 07:41:12AM -0500, Mark Hounschell wrote:
> Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > Date: Tue, 3 Feb 2009 16:24:22 +0100
> > Subject: [PATCH] APIC: enable workaround on AMD Fam10h CPUs
> > 
> > Impact: fix to enable APIC for AMD Fam10h on chipsets with a missing/b0rked
> > 	ACPI MP table (MADT)
> > 
> > Booting a 32bit kernel on an AMD Fam10h CPU running on chipsets with
> > missing/b0rked MP table leads to a hang pretty early in the boot process
> > due to the APIC not being initialized. Fix that by falling back to the
> > default APIC base address in 32bit code, as it is done in the 64bit
> > codepath.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  arch/x86/kernel/apic.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
> > index 4b6df24..115449f 100644
> > --- a/arch/x86/kernel/apic.c
> > +++ b/arch/x86/kernel/apic.c
> > @@ -1436,7 +1436,7 @@ static int __init detect_init_APIC(void)
> >  	switch (boot_cpu_data.x86_vendor) {
> >  	case X86_VENDOR_AMD:
> >  		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
> > -		    (boot_cpu_data.x86 == 15))
> > +		    (boot_cpu_data.x86 >= 15))
> >  			break;
> >  		goto no_apic;
> >  	case X86_VENDOR_INTEL:
> 
> Hi Borislav,
> 
> Could this have anything to do with my Phenom-II problem that you've been so kind
> to help me with?
> 
> Thanks
> Mark
>

Well, we thought so originally but since a 64bit kernel fails booting
on your machine too, it can't be it because this is a 32bit codepath
issue.

Another question: does your machine boot a tickless kernel (CONFIG_NO_HZ enabled)?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

