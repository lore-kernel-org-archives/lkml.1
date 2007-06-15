Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXFOPal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXFOPal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXFOPab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:30:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51439 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXFOPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:30:30 -0400
Date: Fri, 15 Jun 2007 20:59:38 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: linux-kernel@vger.kernel.org, rdreier@cisco.com, akpm@linux-foundation.org
Subject: Re: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
Message-ID: <20070615152938.GA9230@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EB9@USRV-EXCH4.na.uis.unisys.com> <32209efe0706131522n42eff7b1hfea6a6252289e280@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32209efe0706131522n42eff7b1hfea6a6252289e280@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 03:22:55PM -0700, Natalie Protasevich wrote:
[..]
> >Seems it would be cleaner to figure out some way to build es7000.c for
> >if CONFIG_X86_ES7000 is set?  Or just move them here all the time?
> >
> > > ---
> >linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_mpparse.h~i386-e
> >s7000-build-breakage-fix        2007-06-13 22:52:14.000000000 +0530
> > > +++
> >linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h
> >2007-06-13 22:52:14.000000000 +0530
> > > @@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
> > >  extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
> > >  extern void setup_unisys(void);
> > >
> > > +#ifndef CONFIG_X86_GENERICARCH
> > > +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
> > > +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
> > > +                            char *productid);
> > > +#endif
> >
> >It seems that this #ifndef is not needed -- even if there is another
> >declaration of these functions that is visible, the signatures should
> >match so it should be OK.
> 
> I just finished my test builds with and without GENERIC, so I can
> suggest just move all functions to arch/i386/mach-es7000/es7000plat.c
> - es7000_sw_apic() ,es7000_enable_apic_mode(),acpi_madt_oem_check(),
> mps_oem_check() and make them non-static - from
> arch/i386/mach-generic/es7000.c

I think this will also break with CONFIG_X86_GENERIC=y. The moment you
make es7000 specific acpi_madt_oem_check() non static, It will conflict
with generic definition present in mach-generic/probe.c. That function is
a generic function designed to probe for underlying subarch.

Thanks
Vivek

