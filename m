Return-Path: <linux-kernel-owner+w=401wt.eu-S966015AbXEUULy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966015AbXEUULy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934937AbXEUUJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:09:34 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:36408 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934889AbXEUUJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:09:32 -0400
Date: Mon, 21 May 2007 22:08:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: linux-kernel@vger.kernel.org, jan.glauber@de.ibm.com,
       randy.dunlap@oracle.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] rm_inter-arch Kconfig dep. (was Re: building i386  requires s390: "driver/crypto/Kconfig" sourcing s390 arch)
Message-ID: <20070521200858.GB9855@osiris.ibm.com>
References: <4650EF81.MailBRM1BHKC8@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4650EF81.MailBRM1BHKC8@tlinx.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 06:01:53PM -0700, Linda Walsh wrote:
> Heiko Carstens wrote:
> > Send a patch.
> 
> The following seems to work for me.  Hope the form is ok. How does
> one include source if one wants to compose using Firefox?  Seems to
> eat the tabs... :-(  Are "text/plain" attachments ok to send to the
> list?  Haven't seen any, but maybe it is not a necessary restrictly?
> 
> Anyway...whatever...here it is...

The form is not ok. Please read Documentation/SubmittingPatches
"The canonical patch format". Especially a proper description and a
Signed-off-by: line is missing.
Please resend.

> ---
> 
> diff -rNu linux-2.6.21.1/arch/s390/crypto/Kconfig linux-2.6.21.1-new/arch/s390/crypto/Kconfig
> --- linux-2.6.21.1/arch/s390/crypto/Kconfig	2007-04-27 14:49:26.000000000 -0700
> +++ linux-2.6.21.1-new/arch/s390/crypto/Kconfig	1969-12-31 16:00:00.000000000 -0800
> @@ -1,60 +0,0 @@
> -config CRYPTO_SHA1_S390
> -	tristate "SHA1 digest algorithm"
> -	depends on S390
> -	select CRYPTO_ALGAPI
> -	help
> -	  This is the s390 hardware accelerated implementation of the
> -	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
> -
> -config CRYPTO_SHA256_S390
> -	tristate "SHA256 digest algorithm"
> -	depends on S390
> -	select CRYPTO_ALGAPI
> -	help
> -	  This is the s390 hardware accelerated implementation of the
> -	  SHA256 secure hash standard (DFIPS 180-2).
> -
> -	  This version of SHA implements a 256 bit hash with 128 bits of
> -	  security against collision attacks.
> -
> -config CRYPTO_DES_S390
> -	tristate "DES and Triple DES cipher algorithms"
> -	depends on S390
> -	select CRYPTO_ALGAPI
> -	select CRYPTO_BLKCIPHER
> -	help
> -	  This us the s390 hardware accelerated implementation of the
> -	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
> -
> -config CRYPTO_AES_S390
> -	tristate "AES cipher algorithms"
> -	depends on S390
> -	select CRYPTO_ALGAPI
> -	select CRYPTO_BLKCIPHER
> -	help
> -	  This is the s390 hardware accelerated implementation of the
> -	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
> -	  algorithm.
> -
> -	  Rijndael appears to be consistently a very good performer in
> -	  both hardware and software across a wide range of computing
> -	  environments regardless of its use in feedback or non-feedback
> -	  modes. Its key setup time is excellent, and its key agility is
> -	  good. Rijndael's very low memory requirements make it very well
> -	  suited for restricted-space environments, in which it also
> -	  demonstrates excellent performance. Rijndael's operations are
> -	  among the easiest to defend against power and timing attacks.
> -
> -	  On s390 the System z9-109 currently only supports the key size
> -	  of 128 bit.
> -
> -config S390_PRNG
> -	tristate "Pseudo random number generator device driver"
> -	depends on S390
> -	default "m"
> -	help
> -	  Select this option if you want to use the s390 pseudo random number
> -	  generator. The PRNG is part of the cryptograhic processor functions
> -	  and uses triple-DES to generate secure random numbers like the
> -	  ANSI X9.17 standard. The PRNG is usable via the char device
> -	  /dev/prandom.
> diff -rNu linux-2.6.21.1/drivers/crypto/Kconfig linux-2.6.21.1-new/drivers/crypto/Kconfig
> --- linux-2.6.21.1/drivers/crypto/Kconfig	2007-04-27 14:49:26.000000000 -0700
> +++ linux-2.6.21.1-new/drivers/crypto/Kconfig	2007-05-20 16:41:44.215406026 -0700
> @@ -51,7 +51,66 @@
>  	  If unsure say M. The compiled module will be
>  	  called padlock-sha.ko
> 
> -source "arch/s390/crypto/Kconfig"
> +config CRYPTO_SHA1_S390
> +	tristate "SHA1 digest algorithm"
> +	depends on S390
> +	select CRYPTO_ALGAPI
> +	help
> +	  This is the s390 hardware accelerated implementation of the
> +	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
> +
> +config CRYPTO_SHA256_S390
> +	tristate "SHA256 digest algorithm"
> +	depends on S390
> +	select CRYPTO_ALGAPI
> +	help
> +	  This is the s390 hardware accelerated implementation of the
> +	  SHA256 secure hash standard (DFIPS 180-2).
> +
> +	  This version of SHA implements a 256 bit hash with 128 bits of
> +	  security against collision attacks.
> +
> +config CRYPTO_DES_S390
> +	tristate "DES and Triple DES cipher algorithms"
> +	depends on S390
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_BLKCIPHER
> +	help
> +	  This us the s390 hardware accelerated implementation of the
> +	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
> +
> +config CRYPTO_AES_S390
> +	tristate "AES cipher algorithms"
> +	depends on S390
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_BLKCIPHER
> +	help
> +	  This is the s390 hardware accelerated implementation of the
> +	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
> +	  algorithm.
> +
> +	  Rijndael appears to be consistently a very good performer in
> +	  both hardware and software across a wide range of computing
> +	  environments regardless of its use in feedback or non-feedback
> +	  modes. Its key setup time is excellent, and its key agility is
> +	  good. Rijndael's very low memory requirements make it very well
> +	  suited for restricted-space environments, in which it also
> +	  demonstrates excellent performance. Rijndael's operations are
> +	  among the easiest to defend against power and timing attacks.
> +
> +	  On s390 the System z9-109 currently only supports the key size
> +	  of 128 bit.
> +
> +config S390_PRNG
> +	tristate "Pseudo random number generator device driver"
> +	depends on S390
> +	default "m"
> +	help
> +	  Select this option if you want to use the s390 pseudo random number
> +	  generator. The PRNG is part of the cryptograhic processor functions
> +	  and uses triple-DES to generate secure random numbers like the
> +	  ANSI X9.17 standard. The PRNG is usable via the char device
> +	  /dev/prandom.
> 
>  config CRYPTO_DEV_GEODE
>  	tristate "Support for the Geode LX AES engine"
