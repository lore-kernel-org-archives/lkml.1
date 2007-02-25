Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXBYROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXBYROb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964986AbXBYROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:14:31 -0500
Received: from mx27.mail.ru ([194.67.23.64]:5912 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbXBYROa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:14:30 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.19: ACPI reports AC not present after resume from STD
Date: Sun, 25 Feb 2007 20:14:22 +0300
User-Agent: KMail/1.9.6
Cc: "Lebedev, Vladimir P" <vladimir.p.lebedev@intel.com>,
       "Karasyov, Konstantin A" <konstantin.a.karasyov@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@osdl.org>
References: <8E389A5F2FEABA4CB1DEC35A25CB39CE82FE9F@mssmsx411> <200702251337.08914.arvidjaar@mail.ru> <200702251151.12107.rjw@sisk.pl>
In-Reply-To: <200702251151.12107.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1222813.WCPcBIExH4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702252014.26110.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1222813.WCPcBIExH4
Content-Type: multipart/mixed;
  boundary="Boundary-01=_xPc4FyUkCnyB/l+"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_xPc4FyUkCnyB/l+
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On =D0=92=D0=BE=D1=81=D0=BA=D1=80=D0=B5=D1=81=D0=B5=D0=BD=D1=8C=D0=B5 25 =
=D1=84=D0=B5=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2007, Rafael J. Wysocki wrote:
> On Sunday, 25 February 2007 11:37, Andrey Borzenkov wrote:
> > On =D0=92=D0=BE=D1=81=D0=BA=D1=80=D0=B5=D1=81=D0=B5=D0=BD=D1=8C=D0=B5 2=
5 =D1=84=D0=B5=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2007, Rafael J. Wysocki wrote:
> > > On Sunday, 25 February 2007 00:26, Andrey Borzenkov wrote:
> > > > On =D0=A1=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0 24 =D1=84=D0=B5=D0=B2=
=D1=80=D0=B0=D0=BB=D1=8F 2007, Rafael J. Wysocki wrote:
> > > > > Hi,
> > > > >
> > > > > On Saturday, 24 February 2007 10:55, Andrey Borzenkov wrote:
> > > > > > On =D0=92=D1=82=D0=BE=D1=80=D0=BD=D0=B8=D0=BA 13 =D1=84=D0=B5=
=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2007, Andrey Borzenkov wrote:
> > > > > > > On =D0=A7=D0=B5=D1=82=D0=B2=D0=B5=D1=80=D0=B3 07 =D0=B4=D0=B5=
=D0=BA=D0=B0=D0=B1=D1=80=D1=8F 2006, Lebedev, Vladimir P wrote:
> > > > > > > > Please register new bug, attach acpidump and dmesg.
> > > > > > >
> > > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=3D7995
> > > > > > >
> > > > > > > regards
> > > > > >
> > > > > > Well, this starts looking like ACPI is not at fault.
> > > > > >
> > > > > > When reporting AC state ACPI just reads contents of system memo=
ry
> > > > > > (I presume it gets updated by BIOS/ACPI when AC state changes).
> > > > > > It looks like this memory area is restored during resume from
> > > > > > STD. I updated mentioned bug report with more detailed
> > > > > > description. Now if someone could suggest a way to catch if
> > > > > > specific physical address gets saved/restored this would finally
> > > > > > explain it.
> > > > >
> > > > > First, if you want the reserved memory areas to be left alone by
> > > > > swsusp, you need to mark them as 'nosave'.  On x86_64 this is done
> > > > > by the function e820_mark_nosave_range() in
> > > > > arch/x86_64/kernel/e820.c that can be ported to i386 with no
> > > > > problems.  However, we haven't found that very useful, so far,
> > > > > since no one has ever reported any problems with the current
> > > > > approach, which is to save and restore them.
> > > >
> > > > Well, the following proof of concept patch fixes this issue for me.
> > > > Please notice that original version of e820_mark_nosave_range() cou=
ld
> > > > fail to exclude some areas due to alignment issues (exactly what
> > > > happened to me on first try) so it still can explain your problem
> > > > too.
> > >
> > > Great job, thanks for the patch!  It looks good, so I'm going to
> > > forward it for merging.
> >
> > Please no; I'm currently testing slightly more polished version; I will
> > send it later.
>
> OK
>
> > Could anybody explain (or give pointer to) what happens which region th=
at
> > is not page-aligned? In particular, the very first one:
> >
> >  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> >  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> >
> > Will the kernel allocate partial page (how?) or will the kernel ignore
> > last (first) incomplete page? In the former case how those incomplete
> > pages can be detected?
>
> Well, on x86_64, if I understand e820_register_active_regions() correctly,
> the partial pages won't be registered.
>

It appears that for low memory kernel will ignore incomplete pages for sure=
=2E I=20
hope it does the same for high memory - but for now I just throw this in an=
d=20
pray :) This also significantly simplifies patch.

As this touches quite sensitive field, I Cc Andrew - if he considers this=20
appropriate for mm; or would you do it as part of your tree? Also he probab=
ly=20
can easily clarify memory allocation questions :p

regards

=2Dandrey

--Boundary-01=_xPc4FyUkCnyB/l+
Content-Type: text/x-diff;
  charset="utf-8";
  name="nosave_reserved_memory"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="nosave_reserved_memory"

Subject: [PATCH] Mark e820 reserved memory areas as nosave for suspend/resu=
me
=46rom: Andrey Borzenkov <<arvidjaar@mail.ru>>

This fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=3D7995. From
lkml discussion (http://marc.theaimsgroup.com/?t=3D116514878500001&r=3D1&w=
=3D2):

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> When reporting AC state ACPI just reads contents of system memory (I
> presume
> it gets updated by BIOS/ACPI when AC state changes). It looks like this
> memory area is restored during resume from STD. I updated mentioned bug
> report with more detailed description. Now if someone could suggest a way
> to
> catch if specific physical address gets saved/restored this would finally
> explain it.

=46irst, if you want the reserved memory areas to be left alone by swsusp,
you need to mark them as 'nosave'.  On x86_64 this is done by the function
e820_mark_nosave_range() in arch/x86_64/kernel/e820.c that can be ported to
i386 with no problems.  However, we haven't found that very useful, so far,
since no one has ever reported any problems with the current approach,
which is to save and restore them.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The patch adds adapted x84_64 version for i386. It differs from x86_64
in that

=2D it does not touch memory regions not covered by e820 table (I simply
have no idea if this is appropriate to do)

=2D it properly marks also partial pages (like the initial one in second
line below). Apparently kernel won't allocate and use such pages, so there
is nothing to preserve there.

 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)

The region in question starts at ee800. This is likely true for x86_64 as
well.

Signed-off-by: Andrey Borzenkov <<arvidjaar@mail.ru>>

=2D--

 arch/i386/kernel/e820.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 arch/i386/kernel/setup.c |    1 +
 include/asm-i386/e820.h  |    1 +
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/e820.c b/arch/i386/kernel/e820.c
index f391abc..adf0e6f 100644
=2D-- a/arch/i386/kernel/e820.c
+++ b/arch/i386/kernel/e820.c
@@ -311,6 +311,47 @@ static int __init request_standard_resources(void)
=20
 subsys_initcall(request_standard_resources);
=20
+/*
+ * Mark pages corresponding to given pfn range as nosaves
+ *
+ * For low memory kernel definitely won't use partial pages;
+ * I hope the same happens for high memory too. That is why
+ * round in outer direction to be sure to preserve those partial
+ * pages if they contain reserved regions.
+ */
+static void __init
+e820_mark_nosave_range(unsigned long long start, unsigned long long end)
+{
+	unsigned long pfn, max_pfn =3D PFN_UP(end);
+
+	if (start >=3D end)
+		return;
+
+	printk("Nosave address range: %016Lx - %016Lx\n", start, end);
+	for (pfn =3D PFN_DOWN(start); pfn < max_pfn; pfn++)
+		if (pfn_valid(pfn))
+			SetPageNosave(pfn_to_page(pfn));
+}
+
+/*
+ * Find the ranges of physical addresses that do not correspond to
+ * e820 RAM areas and mark the corresponding pages as nosave for software
+ * suspend and suspend to RAM.
+ *
+ * This assumes kernel won't use partial pages.
+ */
+void __init e820_mark_nosave_regions(void)
+{
+	int i;
+
+	for (i =3D 0; i < e820.nr_map; i++) {
+		struct e820entry *ei =3D &e820.map[i];
+
+		if (ei->type !=3D E820_RAM)
+			e820_mark_nosave_range(ei->addr, ei->addr + ei->size);
+	}
+}
+
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type)
 {
diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 4b31ad7..4f43e46 100644
=2D-- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -640,6 +640,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
=20
 	e820_register_memory();
+	e820_mark_nosave_regions();
=20
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
diff --git a/include/asm-i386/e820.h b/include/asm-i386/e820.h
index c5b8fc6..80e49bc 100644
=2D-- a/include/asm-i386/e820.h
+++ b/include/asm-i386/e820.h
@@ -43,6 +43,7 @@ extern void register_bootmem_low_pages(unsigned long max_=
low_pfn);
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
+extern void e820_mark_nosave_regions(void);
=20
 #endif/*!__ASSEMBLY__*/
=20

--Boundary-01=_xPc4FyUkCnyB/l+--

--nextPart1222813.WCPcBIExH4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF4cPyR6LMutpd94wRAouVAJ0f0PqS/Jm7HzkltbFxXC77v6xEoQCfR2bP
okU1Nt+WzUslf3CnHAIQKt0=
=p/e1
-----END PGP SIGNATURE-----

--nextPart1222813.WCPcBIExH4--
