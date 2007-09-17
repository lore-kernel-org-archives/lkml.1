Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbXIQG26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbXIQG26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 02:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXIQG2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 02:28:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54081 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXIQG2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 02:28:48 -0400
Date: Mon, 17 Sep 2007 16:28:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 09/10] ppc64: Convert cpu_sibling_map to a per_cpu data
 array (v3)
Message-Id: <20070917162831.b2a9d675.sfr@canb.auug.org.au>
In-Reply-To: <20070912015647.486500682@sgi.com>
References: <20070912015644.927677070@sgi.com>
	<20070912015647.486500682@sgi.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_Sep_2007_16_28_31_+1000_tjewKN/mkN4kGaNl"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2007_16_28_31_+1000_tjewKN/mkN4kGaNl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Sep 2007 18:56:53 -0700 travis@sgi.com wrote:
>
> Convert cpu_sibling_map to a per_cpu cpumask_t array for the ppc64
> architecture.  This fixes build errors in block/blktrace.c and
> kernel/sched.c when CONFIG_SCHED_SMT is defined.
>=20
> Note: these changes have not been built nor tested.

After applying all 10 patches, the ppc64_defconfig builds but:

	vmlinux is larger:

   text    data     bss     dec     hex filename
7705776 1756984  504624 9967384  981718 ppc64/vmlinux
7706228 1757120  504624 9967972  981964 trav.bld/vmlinux

	the topology (on my POWERPC5+ box) is not correct:

cpu0/topology/thread_siblings:0000000f
cpu1/topology/thread_siblings:0000000f
cpu2/topology/thread_siblings:0000000f
cpu3/topology/thread_siblings:0000000f

it used to be:

cpu0/topology/thread_siblings:00000003
cpu1/topology/thread_siblings:00000003
cpu2/topology/thread_siblings:0000000c
cpu3/topology/thread_siblings:0000000c

Similarly on my iSeries box, the topology is displayed as above
while it used to be:

cpu0/topology/thread_siblings:00000001
cpu1/topology/thread_siblings:00000002
cpu2/topology/thread_siblings:00000004
cpu3/topology/thread_siblings:00000008

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_Sep_2007_16_28_31_+1000_tjewKN/mkN4kGaNl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG7h6VTgG2atn1QN8RAmB+AJ9HOw5MvcVaJSHu/pECUTF9I4l5VACgj//+
2tXfkc5WNeX4tppxSpnOXis=
=XiPX
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2007_16_28_31_+1000_tjewKN/mkN4kGaNl--
