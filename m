Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZIVTe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZIVTe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZIVTez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:34:55 -0400
Received: from gold.linx.net ([195.66.232.40]:52052 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbZIVTey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:34:54 -0400
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
From: Tony Vroon <tony@linx.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4AB89417.7090005@kernel.org>
References: <1253560490.2934.42.camel@localhost>
	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>
	 <4AB89417.7090005@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MmM8FBgZu5EQns4vcbym"
Organization: London Internet Exchange (LINX; AS5459)
Date: Tue, 22 Sep 2009 20:36:26 +0100
Message-Id: <1253648186.2766.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MmM8FBgZu5EQns4vcbym
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 18:08 +0900, Tejun Heo wrote:
> Can you please try the patch below?  Also, please build the kernel
> with debug info and ask gdb which line the crash corresponds to?
> ie. l *pcpu_embed_first_chunk+0x1e2

Patch applied, no additional output visible:
OAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10de8201 base: 0xfed00000
SMP: allowing 12 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at b00000000 (gap:b0000000:30000000)
NR_CPUS: 12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:2
PERCPU: Embedded 23 pages/cpu @ffff880028200000 s73688 r0 d20520 u26214
PANIC: early exception 06 rip 10:ffffffff81598250 error 0 cr2 d0fff6
Pid: 0, comm: swapper Not tainted 2.6.31-07068-g43c266-dirty #1
Call Trace:
[<ffffffff815719b5>] early_idt_handler+0x55/0x68
[<ffffffff81587259>] ? pcpu_setup_first_chunk+0x40b/0x703
[<ffffffff81587273>] ? pcpu_setup_first_chunk+0x427/0x703
[<ffffffff81587a78>] pcpu_embed_first_chunk+0x1fd/0x261
[<ffffffff8158a927>] ? pcpu_fc_alloc+0x0/0xac
[<ffffffff8157a908>] ? pcpu_fc_free+0x0/0x1f
[<ffffffff8157a749>] setup_per_cpu_areas+0x65/0x219
[<ffffffff815721ff>] start_kernel+0x124/0x2c5
[<ffffffff81571a92>] x86_64_start_reservations+0x82/0x86
[<ffffffff81571b7a>] x86_64_start_kernel+0xe4/0xeb
RIP pcpu_setup_first_chunk+0x40d/0x703

gdb output:

(gdb) l *pcpu_embed_first_chunk+0x1fd
0xffffffff81587a78 is in pcpu_embed_first_chunk (mm/percpu.c:1845).
1840=09
1841		pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu
\n",
1842			PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
1843			ai->dyn_size, ai->unit_size);
1844=09
1845		rc =3D pcpu_setup_first_chunk(ai, base);
1846		goto out_free;
1847=09
1848	out_free_areas:
1849		for (group =3D 0; group < ai->nr_groups; group++)

Regards,
Tony V.

--=-MmM8FBgZu5EQns4vcbym
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkq5JzoACgkQp5vW4rUFj5rvLgCdG/zkSAj8ayM9QgAJ5kCd7NS5
Tr8An2W3Qcii8SOmi04RZ9+lq5z/WCX5
=w+2Y
-----END PGP SIGNATURE-----

--=-MmM8FBgZu5EQns4vcbym--

