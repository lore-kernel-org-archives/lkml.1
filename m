Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZHFIbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZHFIbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZHFIa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:30:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50223 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZHFIa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:30:58 -0400
Date: Thu, 6 Aug 2009 18:30:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/5] x86: Provide CPU topology information for
 multi-node processors
Message-Id: <20090806183046.8aaa7404.sfr@canb.auug.org.au>
In-Reply-To: <20090805154811.GC6520@alberich.amd.com>
References: <20090805154402.GA6520@alberich.amd.com>
	<20090805154811.GC6520@alberich.amd.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Aug_2009_18_30_46_+1000_QFV1Bcft3iSP.cht"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Aug_2009_18_30_46_+1000_QFV1Bcft3iSP.cht
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrea,

On Wed, 5 Aug 2009 17:48:11 +0200 Andreas Herrmann <andreas.herrmann3@amd.c=
om> wrote:
>
> @@ -1061,8 +1070,10 @@ void __init native_smp_prepare_cpus(unsigned int m=
ax_cpus)
>  	for_each_possible_cpu(i) {
>  		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
>  		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> +		alloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
>  		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
>  		cpumask_clear(per_cpu(cpu_core_map, i));
> +		cpumask_clear(per_cpu(cpu_node_map, i));

I noticed this in linux-next ... you can use zalloc_cpumask_var() instead
of alloc_cpumask_var() followed by cpumask_clear().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Aug_2009_18_30_46_+1000_QFV1Bcft3iSP.cht
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp6lLYACgkQjjKRsyhoI8w//gCfYJNzoKoyBpQxQF2nRjdSZSj9
9mcAoIEayfIrL+/KaXqF1P4hae4Ng8Xp
=S4hq
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Aug_2009_18_30_46_+1000_QFV1Bcft3iSP.cht--
