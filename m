Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXB0DGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXB0DGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 22:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXB0DGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 22:06:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57129 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbXB0DGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 22:06:30 -0500
Date: Tue, 27 Feb 2007 14:06:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexey Dobriyan <adobriyan@openvz.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org, ak@suse.de,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 4/3] lutimesat: compat syscall and wire up on x86_64
Message-Id: <20070227140624.5f9eb52d.sfr@canb.auug.org.au>
In-Reply-To: <20070226165024.GB11154@localhost.sw.ru>
References: <20070226165024.GB11154@localhost.sw.ru>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Feb_2007_14_06_24_+1100_sHr0r+S/1_IXqnI1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Feb_2007_14_06_24_+1100_sHr0r+S/1_IXqnI1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Mon, 26 Feb 2007 19:50:24 +0300 Alexey Dobriyan <adobriyan@openvz.org> wrote:
>
> +asmlinkage long compat_sys_lutimesat(int dfd, char __user *filename, struct compat_timespec __user *utimes)
> +{
> +	struct timespec ts[2];
> +
> +	if (utimes) {
> +		if (get_user(ts[0].tv_sec, &utimes[0].tv_sec) ||
> +		    get_user(ts[0].tv_nsec, &utimes[0].tv_nsec) ||
> +		    get_user(ts[1].tv_sec, &utimes[1].tv_sec) ||
> +		    get_user(ts[1].tv_nsec, &utimes[1].tv_nsec))
> +			return -EFAULT;

		if (get_compat_timespec(&ts[0], &utimes[0]) ||
		    get_compat_timespec(&ts[1], &utimes[1]))
			return -EFAULT;

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Feb_2007_14_06_24_+1100_sHr0r+S/1_IXqnI1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF46A1FdBgD/zoJvwRAhnDAKCYz7GHLl//DhfzPyeE5/mYBGkdLACdG8Yx
6EW/gkOTs/+WB7kOQoruglA=
=9VKZ
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Feb_2007_14_06_24_+1100_sHr0r+S/1_IXqnI1--
