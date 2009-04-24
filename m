Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZDXPZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZDXPZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZDXPYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:24:54 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34528 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbZDXPYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:24:53 -0400
Subject: Re: [BUG] 2.6.30-rc3: BUG triggered on some hugepage usages
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20090424095116.GB14283@csn.ul.ie>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain>
	 <20090424095116.GB14283@csn.ul.ie>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G5JoyAS1SdsJILBLp7e4"
Date: Sat, 25 Apr 2009 01:24:50 +1000
Message-Id: <1240586690.12551.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G5JoyAS1SdsJILBLp7e4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 10:51 +0100, Mel Gorman wrote:
> On Tue, Apr 21, 2009 at 08:27:57PM -0700, Linus Torvalds wrote:
> > Another week, another -rc.
> >=20
>=20
> I'm seeing some tests with sysbench+postgres+large pages fail on ppc64
> although a very clear pattern is not forming as to what exactly is
> causing it. However, the libhugetlbfs regression tests (make && make
> func) are triggering the following oops when calling mlock() and so are
> likely related.
>=20
> ------------[ cut here ]------------
> kernel BUG at arch/powerpc/mm/pgtable.c:243!
> Oops: Exception in kernel mode, sig: 5 [#1]
> SMP NR_CPUS=3D128 NUMA pSeries
> Modules linked in: dm_snapshot dm_mirror dm_region_hash dm_log qla2xxx
> loop nfnetlink iptable_filter iptable_nat nf_nat ip_tables
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
> xt_tcpudp xt_limit ipt_LOG xt_pkttype x_tables
> NIP: c00000000002becc LR: c00000000002c02c CTR: 0000000000000000
> REGS: c0000000ea92b4c0 TRAP: 0700   Not tainted  (2.6.30-rc3-autokern1)
> MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28000484  XER: 20000020
> TASK =3D c00000000395b660[7611] 'mlock' THREAD: c0000000ea928000 CPU: 3
> GPR00: 0000000000000001 c0000000ea92b740 c0000000008ea170 c0000000ec7d498=
0=20
> GPR04: 000000003f000000 c0000001e2278cf8 0000001900000393 000000000000000=
1=20
> GPR08: f000000002bc0000 0000000000000000 0000000000000113 c0000001e2278c8=
1=20
> GPR12: 0000000044000482 c00000000093b880 0000000028004422 000000000000000=
0=20
> GPR16: c0000000ea92bbf0 c0000000009f06f0 0000001900000113 c0000000ec7d498=
0=20
> GPR20: 0000000000000000 f000000002bc0000 000000003f000000 c0000001e2278cf=
8=20
> GPR24: c0000000eaa90bb0 0000000000000000 c0000000eaa90bb0 c0000000ea92800=
0=20
> GPR28: f000000002bc0000 0000001900000393 0000000000000001 c0000001e2278cf=
8=20
> NIP [c00000000002becc] .assert_pte_locked+0x54/0x8c
> LR [c00000000002c02c] .ptep_set_access_flags+0x50/0x8c
> Call Trace:
> [c0000000ea92b740] [c0000000eaa90bb0] 0xc0000000eaa90bb0 (unreliable)
> [c0000000ea92b7d0] [c0000000000ed1b0] .hugetlb_cow+0xd4/0x654
> [c0000000ea92b900] [c0000000000edbf0] .hugetlb_fault+0x4c0/0x708
> [c0000000ea92b9f0] [c0000000000ee890] .follow_hugetlb_page+0x174/0x364
> [c0000000ea92bae0] [c0000000000d8d30] .__get_user_pages+0x288/0x4c0
> [c0000000ea92bbb0] [c0000000000da10c] .make_pages_present+0xa0/0xe0
> [c0000000ea92bc40] [c0000000000db758] .mlock_fixup+0x90/0x228
> [c0000000ea92bd00] [c0000000000dbb38] .do_mlock+0xc4/0x128
> [c0000000ea92bda0] [c0000000000dbccc] .SyS_mlock+0xb0/0xec
> [c0000000ea92be30] [c00000000000852c] syscall_exit+0x0/0x40
> Instruction dump:
> 0b000000 78892662 79291f24 7d69582a 7d600074 7800d182 0b000000 78895e62=20
> 79291f24 7d29582a 7d200074 7800d182 <0b000000> 3c004000 3960ffff
> 780007c6=20
> ---[ end trace 36a7faa04fa9452b ]---
>=20
> This corresponds to
>=20
> #ifdef CONFIG_DEBUG_VM
> void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
> {
>         pgd_t *pgd;
>         pud_t *pud;
>         pmd_t *pmd;
>=20
>         if (mm =3D=3D &init_mm)
>                 return;
>         pgd =3D mm->pgd + pgd_index(addr);
>         BUG_ON(pgd_none(*pgd));
>         pud =3D pud_offset(pgd, addr);
>         BUG_ON(pud_none(*pud));
>         pmd =3D pmd_offset(pud, addr);
>         BUG_ON(!pmd_present(*pmd));			<----- THIS LINE
>         BUG_ON(!spin_is_locked(pte_lockptr(mm, pmd)));
> }
> #endif /* CONFIG_DEBUG_VM */
>=20
> This area was last changed by commit 8d30c14cab30d405a05f2aaceda1e9ad5780=
0f36
> in the 2.6.30-rc1 timeframe. I think there was another hugepage-related
> problem with this patch but I can't remember what it was.

It broke modules, but I don't remember anything hugepage related.

So the code changed from:

-#define  ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty)=
 \
-({                                                                        =
\
-       int __changed =3D !pte_same(*(__ptep), __entry);                   =
  \
-       if (__changed) {                                                   =
\
-               __ptep_set_access_flags(__ptep, __entry, __dirty);         =
\
-               flush_tlb_page_nohash(__vma, __address);                   =
\
-       }                                                                  =
\
-       __changed;                                                         =
\
-})

to:

+int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long addres=
s,
+                         pte_t *ptep, pte_t entry, int dirty)
+{
+       int changed;
+       if (!dirty && pte_need_exec_flush(entry, 0))
+               entry =3D do_dcache_icache_coherency(entry);
+       changed =3D !pte_same(*(ptep), entry);
+       if (changed) {
+               assert_pte_locked(vma->vm_mm, address);
+               __ptep_set_access_flags(ptep, entry);
+               flush_tlb_page_nohash(vma, address);
+       }
+       return changed;
+}

So the call to assert_pte_locked() is new. And it's never going to work
for huge pages, the page table structure is different right? Notice
pte_update() checks (arch/powerpc/include/asm/pgtable-ppc64.h):

198         /* huge pages use the old page table lock */
199         if (!huge)
200                 assert_pte_locked(mm, addr);

But unlike pte_update() ptep_set_access_flags() has no way of knowing
it's been called from huge_ptep_set_access_flags().

So my guess is we either remove the call to assert_pte_locked() in
there, or have assert_pte_locked() check whether it's being called for a
huge pte.

cheers


--=-G5JoyAS1SdsJILBLp7e4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknx2cIACgkQdSjSd0sB4dJRUACdG1CsXVC2HJon9iNeQ7Xrr3A9
R8sAn0RYa56gGlHzNiF1q54LDwltEQTp
=EZFH
-----END PGP SIGNATURE-----

--=-G5JoyAS1SdsJILBLp7e4--

