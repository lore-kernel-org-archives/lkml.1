Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYLPDbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYLPDbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYLPDa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:30:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53026 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYLPDa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:30:57 -0500
Date: Tue, 16 Dec 2008 14:30:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cpumask: add alloc_cpumask_var_node
Message-Id: <20081216143045.2afa85a7.sfr@canb.auug.org.au>
In-Reply-To: <49471353.9070204@sgi.com>
References: <49471353.9070204@sgi.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Dec_2008_14_30_45_+1100_WOzrgDj/UclcgRRe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Dec_2008_14_30_45_+1100_WOzrgDj/UclcgRRe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Just some simple comments.

On Mon, 15 Dec 2008 18:32:51 -0800 Mike Travis <travis@sgi.com> wrote:
>
> +/**
> + * alloc_cpumask_var - return an allocated struct cpumask
> + * @mask: pointer to cpumask_var_t where the cpumask is returned
> + * @cpu: GFP_ flags
       ^^^
flags

> + * alloc_cpumask_var_node - return an allocated struct cpumask on a
> + * specific node.
> + * @mask: pointer to cpumask_var_t where the cpumask is returned
> + * @cpu: GFP_ flags
       ^^^
flags

> + * @node: node to allocate memory on
> + *
> + * Only defined when CONFIG_CPUMASK_OFFSTACK=3Dy, otherwise is
> + * a nop returning a constant 1 (in <linux/cpumask.h>)
> + * Returns TRUE if memory allocation succeeded, FALSE otherwise.
> + */
> +bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
> +{
> +	if (likely(slab_is_available()))
> +		*mask =3D kmalloc_node(cpumask_size(), flags, node);
> +	else {
> +#ifdef CONFIG_DEBUG_PER_CPU_MAPS
> +		printk(KERN_ERR
> +			"=3D> alloc_cpumask_var_node: kmalloc not available!\n");
> +		dump_stack();
> +#endif
> +		*mask =3D NULL;
> +	}
> +#ifdef CONFIG_DEBUG_PER_CPU_MAPS
> +	if (!*mask) {
> +		printk(KERN_ERR "=3D> alloc_cpumask_var_node: failed!\n");
> +		dump_stack();
> +	}
> +#endif

So if !slab_is_available() and CONFIG_DEBUG_PER_CPU_MAPS is set, we get
two stack dumps?

> + * free_cpumask_var - frees memory allocated for a struct cpumask.
> + * mask: cpumask to free
      ^
missing '@'

> + * free_bootmem_cpumask_var - frees bootmem memory allocated for a struc=
t cpumask.
> + * mask: cpumask to free
      ^
here as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Dec_2008_14_30_45_+1100_WOzrgDj/UclcgRRe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklHIOUACgkQjjKRsyhoI8wOCgCfRyUmlDa7cwdFOCUfWZeIlCGE
2vMAnjDzqY72y0gj5DxUp7wMif4OZsJE
=b+Pz
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Dec_2008_14_30_45_+1100_WOzrgDj/UclcgRRe--
