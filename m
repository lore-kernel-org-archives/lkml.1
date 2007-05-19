Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbXESSDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbXESSDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbXESSDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:03:15 -0400
Received: from mx3.mail.ru ([194.67.23.149]:6574 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbXESSDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:03:14 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.19: ACPI reports AC not present after resume from STD
Date: Sat, 19 May 2007 22:03:09 +0400
User-Agent: KMail/1.9.6
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>
References: <8E389A5F2FEABA4CB1DEC35A25CB39CE82FE9F@mssmsx411> <200702252014.26110.arvidjaar@mail.ru> <200703052307.58499.rjw@sisk.pl>
In-Reply-To: <200703052307.58499.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1944328.AU5brYm0Fr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705192203.10206.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1944328.AU5brYm0Fr
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 06 March 2007, Rafael J. Wysocki wrote:
> [changed Cc list]
>
> On Sunday, 25 February 2007 18:14, Andrey Borzenkov wrote:
> > On =D0=92=D0=BE=D1=81=D0=BA=D1=80=D0=B5=D1=81=D0=B5=D0=BD=D1=8C=D0=B5 2=
5 =D1=84=D0=B5=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2007, Rafael J. Wysocki wrote:
> > > On Sunday, 25 February 2007 11:37, Andrey Borzenkov wrote:
> > > > On =D0=92=D0=BE=D1=81=D0=BA=D1=80=D0=B5=D1=81=D0=B5=D0=BD=D1=8C=D0=
=B5 25 =D1=84=D0=B5=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2007, Rafael J. Wysocki w=
rote:
> > > > > On Sunday, 25 February 2007 00:26, Andrey Borzenkov wrote:
> > > > > > On =D0=A1=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0 24 =D1=84=D0=B5=
=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2007, Rafael J. Wysocki wrote:
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Saturday, 24 February 2007 10:55, Andrey Borzenkov wrote:
> > > > > > > > On =D0=92=D1=82=D0=BE=D1=80=D0=BD=D0=B8=D0=BA 13 =D1=84=D0=
=B5=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2007, Andrey Borzenkov wrote:
> > > > > > > > > On =D0=A7=D0=B5=D1=82=D0=B2=D0=B5=D1=80=D0=B3 07 =D0=B4=
=D0=B5=D0=BA=D0=B0=D0=B1=D1=80=D1=8F 2006, Lebedev, Vladimir P wrote:
> > > > > > > > > > Please register new bug, attach acpidump and dmesg.
> > > > > > > > >
> > > > > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=3D7995
> > > > > > > > >
> > > > > > > > > regards
> > > > > > > >
> > > > > > > > Well, this starts looking like ACPI is not at fault.
> > > > > > > >
> > > > > > > > When reporting AC state ACPI just reads contents of system
> > > > > > > > memory (I presume it gets updated by BIOS/ACPI when AC state
> > > > > > > > changes). It looks like this memory area is restored during
> > > > > > > > resume from STD. I updated mentioned bug report with more
> > > > > > > > detailed description. Now if someone could suggest a way to
> > > > > > > > catch if specific physical address gets saved/restored this
> > > > > > > > would finally explain it.
> > > > > > >
> > > > > > > First, if you want the reserved memory areas to be left alone
> > > > > > > by swsusp, you need to mark them as 'nosave'.  On x86_64 this
> > > > > > > is done by the function e820_mark_nosave_range() in
> > > > > > > arch/x86_64/kernel/e820.c that can be ported to i386 with no
> > > > > > > problems.  However, we haven't found that very useful, so far,
> > > > > > > since no one has ever reported any problems with the current
> > > > > > > approach, which is to save and restore them.
> > > > > >
> > > > > > Well, the following proof of concept patch fixes this issue for
> > > > > > me. Please notice that original version of
> > > > > > e820_mark_nosave_range() could fail to exclude some areas due to
> > > > > > alignment issues (exactly what happened to me on first try) so =
it
> > > > > > still can explain your problem too.
> > > > >
> > > > > Great job, thanks for the patch!  It looks good, so I'm going to
> > > > > forward it for merging.
> > > >
> > > > Please no; I'm currently testing slightly more polished version; I
> > > > will send it later.
> > >
> > > OK
> > >
> > > > Could anybody explain (or give pointer to) what happens which region
> > > > that is not page-aligned? In particular, the very first one:
> > > >
> > > >  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> > > >  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> > > >
> > > > Will the kernel allocate partial page (how?) or will the kernel
> > > > ignore last (first) incomplete page? In the former case how those
> > > > incomplete pages can be detected?
> > >
> > > Well, on x86_64, if I understand e820_register_active_regions()
> > > correctly, the partial pages won't be registered.
> >
> > It appears that for low memory kernel will ignore incomplete pages for
> > sure. I hope it does the same for high memory - but for now I just throw
> > this in and pray :) This also significantly simplifies patch.
>
> Well, can you please check if the appended modification of your patch sti=
ll
> works?
>

what is the state of this problem? It is still not fixed in 2.6.22-rc2 and=
=20
this patch no more applies as well (changes are trivial but I cannot test=20
them because USB refuses to suspend on my system in this version :)

In previous versions patch worked just fine.

This is http://bugzilla.kernel.org/show_bug.cgi?id=3D7995 BTW.

> Thanks,
> Rafael
>
>
> ---
>  arch/i386/kernel/e820.c  |   47
> +++++++++++++++++++++++++++++++++++++++++++++++ arch/i386/kernel/setup.c =
|=20
>   1 +
>  include/asm-i386/e820.h  |    1 +
>  3 files changed, 49 insertions(+)
>
> Index: linux-2.6.21-rc2/arch/i386/kernel/e820.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.21-rc2.orig/arch/i386/kernel/e820.c
> +++ linux-2.6.21-rc2/arch/i386/kernel/e820.c
> @@ -313,6 +313,53 @@ static int __init request_standard_resou
>
>  subsys_initcall(request_standard_resources);
>
> +/*
> + * Mark pages corresponding to given pfn range as 'nosave'.
> + */
> +static void __init
> +e820_mark_nosave_range(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	unsigned long pfn;
> +
> +	if (start_pfn >=3D end_pfn)
> +		return;
> +
> +	printk("Nosave address range: %016Lx - %016Lx\n",
> +				PFN_PHYS(start_pfn), PFN_PHYS(end_pfn));
> +	for (pfn =3D start_pfn; pfn < end_pfn; pfn++)
> +		if (pfn_valid(pfn))
> +			SetPageNosave(pfn_to_page(pfn));
> +}
> +
> +/*
> + * Find the ranges of physical addresses that do not correspond to
> + * e820 RAM areas and mark the corresponding pages as nosave for software
> + * suspend and suspend to RAM.
> + *
> + * This function requires the e820 map to be sorted and without any
> + * overlapping entries and assumes the first e820 area to be RAM.
> + */
> +void __init e820_mark_nosave_regions(void)
> +{
> +	int i;
> +	unsigned long pfn;
> +
> +	pfn =3D PFN_DOWN(e820.map[0].addr + e820.map[0].size);
> +	for (i =3D 1; i < e820.nr_map; i++) {
> +		struct e820entry *ei =3D &e820.map[i];
> +
> +		if (pfn < PFN_UP(ei->addr))
> +			e820_mark_nosave_range(pfn, PFN_UP(ei->addr));
> +
> +		pfn =3D PFN_DOWN(ei->addr + ei->size);
> +		if (ei->type !=3D E820_RAM)
> +			e820_mark_nosave_range(PFN_UP(ei->addr), pfn);
> +
> +		if (pfn >=3D max_low_pfn)
> +			break;
> +	}
> +}
> +
>  void __init add_memory_region(unsigned long long start,
>  			      unsigned long long size, int type)
>  {
> Index: linux-2.6.21-rc2/arch/i386/kernel/setup.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.21-rc2.orig/arch/i386/kernel/setup.c
> +++ linux-2.6.21-rc2/arch/i386/kernel/setup.c
> @@ -648,6 +648,7 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>
>  	e820_register_memory();
> +	e820_mark_nosave_regions();
>
>  #ifdef CONFIG_VT
>  #if defined(CONFIG_VGA_CONSOLE)
> Index: linux-2.6.21-rc2/include/asm-i386/e820.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.21-rc2.orig/include/asm-i386/e820.h
> +++ linux-2.6.21-rc2/include/asm-i386/e820.h
> @@ -43,6 +43,7 @@ extern void register_bootmem_low_pages(u
>  extern void e820_register_memory(void);
>  extern void limit_regions(unsigned long long size);
>  extern void print_memory_map(char *who);
> +extern void e820_mark_nosave_regions(void);
>
>  #endif/*!__ASSEMBLY__*/



--nextPart1944328.AU5brYm0Fr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGTzveR6LMutpd94wRAsSWAJ9mIJFOtE8VNG4Yg1cqsR4rM5/5NACfQs1H
eqb/zkVzcfiQucAQu4xO/s4=
=3f70
-----END PGP SIGNATURE-----

--nextPart1944328.AU5brYm0Fr--
