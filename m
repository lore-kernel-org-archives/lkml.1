Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXKYQkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXKYQkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 11:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXKYQkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 11:40:37 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:56746 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXKYQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:40:36 -0500
Message-ID: <4749A3EF.1010606@kernel.org>
Date: Sun, 25 Nov 2007 08:33:51 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] -mm (2.6.24-rc3-mm1) Smack using capabilities 32 and
 33
References: <47490DE2.4030608@schaufler-ca.com>
In-Reply-To: <47490DE2.4030608@schaufler-ca.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Casey Schaufler wrote:
> diff -uprN -X linux-2.6.24-rc3-mm1-base/Documentation/dontdiff linux-2.6.24-rc3-mm1-base/include/linux/capability.h linux-2.6.24-rc3-mm1-smack/include/linux/capability.h
> --- linux-2.6.24-rc3-mm1-base/include/linux/capability.h	2007-11-22 01:51:36.000000000 -0800
> +++ linux-2.6.24-rc3-mm1-smack/include/linux/capability.h	2007-11-24 11:26:51.000000000 -0800
> @@ -314,6 +314,23 @@ typedef struct kernel_cap_struct {
>  
>  #define CAP_SETFCAP	     31
>  
> +/* Override MAC access.
> +   The base kernel enforces no MAC policy.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based overrides of that policy, this is
> +   the capability it should use to do so. */
> +
> +#define CAP_MAC_OVERRIDE     32
> +
> +/* Allow MAC configuration or state changes.
> +   The base kernel requires no MAC configuration.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based checks on modifications to that
> +   policy or the data required to maintain it, this is the
> +   capability it should use to do so. */
> +
> +#define CAP_MAC_ADMIN        33
> +
>  /*
>   * Bit location of each capability (used by user-space library and kernel)
>   */
> @@ -334,7 +351,8 @@ typedef struct kernel_cap_struct {
>  			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
>  			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
>  			    | CAP_TO_MASK(CAP_FOWNER)		\
> -			    | CAP_TO_MASK(CAP_FSETID))
> +			    | CAP_TO_MASK(CAP_FSETID) \

The following looks a bit fishy:
> +			    | CAP_TO_MASK(CAP_MAC_OVERRIDE))

  (1<<32) & 0xffffffff == 0

I think you need to define CAP_FS_MASK_B1.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHSaPvmwytjiwfWMwRAjC8AJ9V4pntMzw4ayK1lb5mgUdjKYlCPQCeLkkz
jas90SJYDo58pQ8Skw1IK60=
=5PUQ
-----END PGP SIGNATURE-----
