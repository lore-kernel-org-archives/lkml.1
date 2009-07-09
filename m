Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbZGIOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbZGIOoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761027AbZGIOoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:44:23 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41713 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760974AbZGIOoW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:44:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] This is the security processor driver for the Intel mid platform
In-Reply-To: Your message of "Wed, 08 Jul 2009 13:01:02 PDT."
             <1247083262-17356-1-git-send-email-mark.a.allyn@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1247083262-17356-1-git-send-email-mark.a.allyn@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247148534_5710P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Jul 2009 10:08:54 -0400
Message-ID: <6578.1247148534@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247148534_5710P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Jul 2009 13:01:02 PDT, Mark Allyn said:
> This is the driver for the Security Processor (SEP) for the Intel MID Platform.
> 
> This device driver is used by userspace applications to use the hardware based
> security processor that is on some Intel Mobile Internet (MID) devices.

This text should probably be repeated...

> diff --git a/drivers/sep/Kconfig b/drivers/sep/Kconfig
> new file mode 100644
> index 0000000..316b79c
> --- /dev/null
> +++ b/drivers/sep/Kconfig
> @@ -0,0 +1,9 @@
> +config DX_SEP
> +	tristate "SEP driver"
> +	depends on MRST
> +	default y
> +	help
> +	  Security Processor driver
> +
> +	  If unsure say M. The compiled module will be
> +	  called sep_driver.ko

here, so the poor slob building a kernel has a clue what it's for and whether
he wants one.

Also, if you have a link to a datasheet or other info, that would be nice,
even if it's just up in the changelog section, so those of us that have never
heard of the chipset can get at least a clue how it's supposed to work.

Especially for a 'Security Processor' - it's a *lot* easier to do a code
review knowing what the threat model is. If this chipset doesn't even claim
to protect against some things, then we don't need to look at those threats.
Similarly, if it *does* claim to do X, Y, and Z, we can look at ways those
could be subverted.

I'm *guessing* it does accelerated crypto for network connections, but that's
based on this one comment:

+/*
+  This function builds input and output DMA tables for synhronic
+  symmetric operations (AES, DES). It also checks that each table
+  is of the modular block size
+*/
+int sep_prepare_input_output_dma_table(unsigned long	app_virt_in_addr,

Other comments based on a quick read of the code:

There seems to be a *lot* of memory allocation/deallocation code in here (as
in "most of the driver").  Is the chipset design oddball enough that it needs
that much marshalling code, and the existing kernel code isn't suitable?

Looks like it does *all* it's locking under one mutex (&sep_mutex). That's
certainly *workable*, but I can't tell if the expected activity level of the
code is enough that we may want to make it more fine-grained eventually.

I'm sure somebody else will contribute more detailed comments...

--==_Exmh_1247148534_5710P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKVfn2cC3lWbTT17ARAu1IAJ9ZzfnjV+yQiSz6EYWY9AUpz5JrzwCgkVFx
9CKjqL+z7DGoYJVyA6TwGHI=
=ZFfN
-----END PGP SIGNATURE-----

--==_Exmh_1247148534_5710P--
