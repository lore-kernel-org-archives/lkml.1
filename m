Return-Path: <linux-kernel-owner+w=401wt.eu-S1760489AbYHHUVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489AbYHHUVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbYHHUUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:20:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28674 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875AbYHHUUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:20:47 -0400
Date: Fri, 8 Aug 2008 13:06:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 4/4] integrity: IMA as an integrity service provider
Message-Id: <20080808130613.7086f9a0.randy.dunlap@oracle.com>
In-Reply-To: <1218221796.4444.14.camel@localhost.localdomain>
References: <20080808184349.999902616@linux.vnet.ibm.com>
	<1218221796.4444.14.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 14:56:36 -0400 Mimi Zohar wrote:

> Index: security-testing-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- security-testing-2.6.orig/Documentation/kernel-parameters.txt
> +++ security-testing-2.6/Documentation/kernel-parameters.txt
> @@ -44,6 +44,7 @@ parameter is applicable:
>  	FB	The frame buffer device is enabled.
>  	HW	Appropriate hardware is enabled.
>  	IA-64	IA-64 architecture is enabled.
> +	IMA     Integrity measurement architecture is enabled.
>  	INTEGRITY Integrity support is enabled.
>  	IOSCHED	More than one I/O scheduler is enabled.
>  	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
> @@ -862,6 +863,10 @@ and is between 256 and 4096 characters. 
>  	ihash_entries=	[KNL]
>  			Set number of hash buckets for inode cache.
>  
> +	ima_hash=	[IMA] runtime ability to define hash crypto alg.

Please spell out algorithm.

> +			Format: { "MD5" | "SHA1" }
> +			Default is "SHA1".
> +
>  	in2000=		[HW,SCSI]
>  			See header of drivers/scsi/in2000.c.
>  
> Index: security-testing-2.6/security/integrity/ima/Kconfig
> ===================================================================
> --- /dev/null
> +++ security-testing-2.6/security/integrity/ima/Kconfig
> @@ -0,0 +1,48 @@
> +#
> +# IBM Integrity Measurement Architecture
> +#
> +
> +config IMA
> +	bool "Integrity Measurement Architecture(IMA)"
> +	depends on INTEGRITY
> +	depends on ACPI
> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_MD5
> +	select CRYPTO_SHA1
> +	select TCG_TPM
> +	select TCG_TIS
> +	help
> +	  The Trusted Computing Group(TCG) runtime Integrity
> +	  Measurement Architecture(IMA) maintains a list of hash
> +	  values of executables and other sensitive system files
> +	  loaded into the run-time of this system.  If your system
> +	  has a TPM chip, then IMA also maintains an aggregate
> +	  integrity value over this list inside the TPM hardware.
> +	  These measurements and the aggregate (signed inside the
> +	  TPM) can be retrieved and presented to remote parties to
> +	  establish system properties. If unsure, say N.
> +
> +config IMA_MEASURE_PCR_IDX
> +	int "PCR for Aggregate (8<= Index <= 14)"

Use consistent spacing (8 <= Index <= 14).

> +	depends on IMA
> +	range 8 14
> +	default 10
> +	help
> +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> +	  that IMA uses to maintain the integrity aggregate of the
> +	  measurement list.  If unsure, use the default 10.
> +
> +config IMA_BASE_HOOKS
> +	bool "IMA base hooks"
> +	depends on IMA
> +	default n
> +	help
> +	  Enable this option to allow the LSM module to enforce integrity.
> +
> +config IMA_LSM_RULES
> +	bool "Enable LSM measurement policy rules"
> +	depends on IMA && (SELINUX || SMACK)
> +	default y
> +	help
> +	  Disabling this option will not enforce LSM based policy rules.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
