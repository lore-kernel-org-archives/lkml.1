Return-Path: <linux-kernel-owner+w=401wt.eu-S935546AbXFFXPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935546AbXFFXPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935012AbXFFXO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:14:57 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49870 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932813AbXFFXO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:14:56 -0400
Date: Wed, 6 Jun 2007 16:16:42 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070606231642.GH13751@tree.beaverton.ibm.com>
References: <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com> <20070606013759.GI17143@linux-os.sc.intel.com> <20070606185829.GA26062@tree.beaverton.ibm.com> <20070606193514.GN17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Content-Disposition: inline
In-Reply-To: <20070606193514.GN17143@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rWhLK7VZz0iBluhq
Content-Type: multipart/mixed; boundary="HeFlAV5LIbMFYYuh"
Content-Disposition: inline


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 06, 2007 at 12:35:14PM -0700, Siddha, Suresh B wrote:

> Weird. Then the bug can only happen if for some reason, "mask = map"
> didn't happen in fixup_irqs(). Can you send us the disassembly of the
> fixup_irqs()?

Attached.

--D

--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=a
Content-Transfer-Encoding: quoted-printable

(gdb) disassemble fixup_irqs
Dump of assembler code for function fixup_irqs:
0xffffffff8020bf50 <fixup_irqs+0>:	push   %rbp
0xffffffff8020bf51 <fixup_irqs+1>:	mov    %rsp,%rbp
0xffffffff8020bf54 <fixup_irqs+4>:	push   %r13
0xffffffff8020bf56 <fixup_irqs+6>:	xor    %r13d,%r13d
0xffffffff8020bf59 <fixup_irqs+9>:	push   %r12
0xffffffff8020bf5b <fixup_irqs+11>:	push   %rbx
0xffffffff8020bf5c <fixup_irqs+12>:	sub    $0x28,%rsp
0xffffffff8020bf60 <fixup_irqs+16>:	mov    %rdi,0xffffffffffffffc0(%rbp)
0xffffffff8020bf64 <fixup_irqs+20>:	mov    %rsi,0xffffffffffffffc8(%rbp)
0xffffffff8020bf68 <fixup_irqs+24>:	jmp    0xffffffff8020bf73 <fixup_irqs+3=
5>
0xffffffff8020bf6a <fixup_irqs+26>:	inc    %r13d
0xffffffff8020bf6d <fixup_irqs+29>:	cmp    $0x2,%r13d
0xffffffff8020bf71 <fixup_irqs+33>:	je     0xffffffff8020bf6a <fixup_irqs+2=
6>
0xffffffff8020bf73 <fixup_irqs+35>:	mov    %r13d,%r12d
0xffffffff8020bf76 <fixup_irqs+38>:	lea    0xffffffffffffffd0(%rbp),%rbx
0xffffffff8020bf7a <fixup_irqs+42>:	lea    0xffffffffffffffc0(%rbp),%rdx
0xffffffff8020bf7e <fixup_irqs+46>:	shl    $0x8,%r12
0xffffffff8020bf82 <fixup_irqs+50>:	mov    $0x80,%ecx
0xffffffff8020bf87 <fixup_irqs+55>:	lea    0xffffffff805505f8(%r12),%rsi
0xffffffff8020bf8f <fixup_irqs+63>:	mov    %rbx,%rdi
0xffffffff8020bf92 <fixup_irqs+66>:	callq  0xffffffff802fb606 <__bitmap_and>
0xffffffff8020bf97 <fixup_irqs+71>:	mov    %rbx,%rdi
0xffffffff8020bf9a <fixup_irqs+74>:	callq  0xffffffff802fc6ad <__any_online=
_cpu>
0xffffffff8020bf9f <fixup_irqs+79>:	add    $0xffffffffffffff80,%eax
0xffffffff8020bfa2 <fixup_irqs+82>:	jne    0xffffffff8020bfc5 <fixup_irqs+1=
17>
0xffffffff8020bfa4 <fixup_irqs+84>:	mov    %r13d,%esi
0xffffffff8020bfa7 <fixup_irqs+87>:	mov    $0xffffffff804a52b0,%rdi
0xffffffff8020bfae <fixup_irqs+94>:	xor    %eax,%eax
0xffffffff8020bfb0 <fixup_irqs+96>:	callq  0xffffffff80233d28 <printk>
0xffffffff8020bfb5 <fixup_irqs+101>:	mov    0xffffffffffffffc0(%rbp),%rax
0xffffffff8020bfb9 <fixup_irqs+105>:	mov    %rax,0xffffffffffffffd0(%rbp)
0xffffffff8020bfbd <fixup_irqs+109>:	mov    0xffffffffffffffc8(%rbp),%rax
0xffffffff8020bfc1 <fixup_irqs+113>:	mov    %rax,0xffffffffffffffd8(%rbp)
0xffffffff8020bfc5 <fixup_irqs+117>:	mov    0xffffffff80550588(%r12),%rax
0xffffffff8020bfcd <fixup_irqs+125>:	mov    0x58(%rax),%rax
0xffffffff8020bfd1 <fixup_irqs+129>:	test   %rax,%rax
0xffffffff8020bfd4 <fixup_irqs+132>:	je     0xffffffff8020bfe5 <fixup_irqs+=
149>
0xffffffff8020bfd6 <fixup_irqs+134>:	mov    0xffffffffffffffd0(%rbp),%rsi
0xffffffff8020bfda <fixup_irqs+138>:	mov    0xffffffffffffffd8(%rbp),%rdx
0xffffffff8020bfde <fixup_irqs+142>:	mov    %r13d,%edi
0xffffffff8020bfe1 <fixup_irqs+145>:	callq  *%rax
0xffffffff8020bfe3 <fixup_irqs+147>:	jmp    0xffffffff8020c013 <fixup_irqs+=
195>
0xffffffff8020bfe5 <fixup_irqs+149>:	cmpq   $0x0,0xffffffff805505a8(%r12)
0xffffffff8020bfee <fixup_irqs+158>:	je     0xffffffff8020c013 <fixup_irqs+=
195>
0xffffffff8020bff0 <fixup_irqs+160>:	mov    5181486(%rip),%eax        # 0xf=
fffffff806fd024 <warned.11720>
0xffffffff8020bff6 <fixup_irqs+166>:	inc    %eax
0xffffffff8020bff8 <fixup_irqs+168>:	mov    %eax,5181478(%rip)        # 0xf=
fffffff806fd024 <warned.11720>
0xffffffff8020bffe <fixup_irqs+174>:	dec    %eax
0xffffffff8020c000 <fixup_irqs+176>:	jne    0xffffffff8020c013 <fixup_irqs+=
195>
0xffffffff8020c002 <fixup_irqs+178>:	mov    %r13d,%esi
0xffffffff8020c005 <fixup_irqs+181>:	mov    $0xffffffff804a52ce,%rdi
0xffffffff8020c00c <fixup_irqs+188>:	xor    %eax,%eax
0xffffffff8020c00e <fixup_irqs+190>:	callq  0xffffffff80233d28 <printk>
0xffffffff8020c013 <fixup_irqs+195>:	lea    0x1(%r13),%eax
0xffffffff8020c017 <fixup_irqs+199>:	cmp    $0x10ff,%eax
0xffffffff8020c01c <fixup_irqs+204>:	jbe    0xffffffff8020bf6a <fixup_irqs+=
26>
0xffffffff8020c022 <fixup_irqs+210>:	callq  0xffffffff8024e46e <trace_hardi=
rqs_on>
0xffffffff8020c027 <fixup_irqs+215>:	sti   =20
0xffffffff8020c028 <fixup_irqs+216>:	mov    $0x418958,%edi
0xffffffff8020c02d <fixup_irqs+221>:	callq  0xffffffff803018cf <__const_ude=
lay>
0xffffffff8020c032 <fixup_irqs+226>:	cli   =20
0xffffffff8020c033 <fixup_irqs+227>:	callq  0xffffffff8024cf31 <trace_hardi=
rqs_off>
0xffffffff8020c038 <fixup_irqs+232>:	add    $0x28,%rsp
0xffffffff8020c03c <fixup_irqs+236>:	pop    %rbx
0xffffffff8020c03d <fixup_irqs+237>:	pop    %r12
0xffffffff8020c03f <fixup_irqs+239>:	pop    %r13
0xffffffff8020c041 <fixup_irqs+241>:	leaveq=20
0xffffffff8020c042 <fixup_irqs+242>:	retq  =20

--HeFlAV5LIbMFYYuh--

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZ0Baa6vRYYgWQuURAlzcAJ0WhlV2JinIZsALxxGbiEsXLcWGfQCdGYcA
yFJgXt0DNOgjFbSGU4acnJ8=
=MWlD
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
