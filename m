Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZI0MsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZI0MsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 08:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZI0MsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 08:48:20 -0400
Received: from gold.linx.net ([195.66.232.40]:33478 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZI0MsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 08:48:19 -0400
Subject: 2.6.31-09194-g0d9df25 Early boot exception
From: Tony Vroon <tony@linx.net>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4ABAC2F1.3020302@kernel.org>
References: <4ABAC2F1.3020302@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MdU56WineQCaNVDcVhXA"
Organization: London Internet Exchange (LINX; AS5459)
Date: Sun, 27 Sep 2009 13:49:57 +0100
Message-Id: <1254055797.2756.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MdU56WineQCaNVDcVhXA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 09:53 +0900, Tejun Heo wrote:
> Add PCPU_SETUP_BUG() macro which prints out enough information about
> the parameters.  As the macro still puts separate BUG() for each
> check, it won't lose any information even on the situations where only
> the program counter can be retrieved.

On Thu, 2009-09-24 at 21:49 +0900, Tejun Heo wrote:
> Warn and dump stack when percpu allocation fails.

Thank you Tejun, both patches applied, more information is now visible:

ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10de8201 base: 0xfed00000
SMP: allowing 12 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at b00000000 (gap: b0000000:30000000)
NR_CPUS: 12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:2
PERCPU: Embedded 23 pages/cpu @ffff880028200000 s73176 r0 d21032 u262144
PERCPU: failed to initialize, unit_map[cpu] =3D=3D NR_CPUS
PERCPU: cpu_possible_mask=3Dfff
pcpu-alloc: s73176 r0 d21032 u262144 alloc=3D1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 -- -- [1] 06 07 08 09 10 11 -- --
PANIC: early exception 06 rip 10:ffffffff81597feb error 0 cr2 d0fff6
Pid: 0, comm: swapper Not tainted 2.6.31-09194-g0d9df25-dirty #1
Call Trace:
 [<ffffffff81582195>] early_idt_handler+0x55/0x68
 [<ffffffff81597feb>] ? pcpu_setup_first_chunk+0x472/0x769
 [<ffffffff81597feb>] ? pcpu_setup_first_chunk+0x472/0x769
 [<ffffffff815987e8>] pcpu_embed_first_chunk+0x1e2/0x241
 [<ffffffff8158b51d>] ? pcpu_fc_alloc+0x0/0xac
 [<ffffffff8158b4fe>] ? pcpu_fc_free+0x0/0x1f
 [<ffffffff8158b33f>] setup_per_cpu_areas+0x65/0x219
 [<ffffffff815829df>] start_kernel+0x124/0x2c5
 [<ffffffff81582272>] x86_64_start_reservations+0x82/0x86
 [<ffffffff8158235a>] x86_64_start_kernel+0xe4/0xeb
RIP pcpu_setup_first_chunk+0x472/0x769

If you would like the vmlinux image again, let me know.

Regards,
Tony V.

--=-MdU56WineQCaNVDcVhXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkq/X3UACgkQp5vW4rUFj5r/CQCfd4zKDdspnDU+uQ02a1c7FeAo
hVEAn2pZ/YursfAZed4/RGcIjDlKIHEt
=NVan
-----END PGP SIGNATURE-----

--=-MdU56WineQCaNVDcVhXA--

