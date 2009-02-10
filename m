Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZBJUYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZBJUYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZBJUX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:23:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39603 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZBJUX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:23:57 -0500
Date: Tue, 10 Feb 2009 21:23:47 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/7] integrity: IMA as an integrity service provider
Message-ID: <20090210202347.GA1382@ucw.cz>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com> <ce9dbebd2ec91ddaf302f5d8146b01311b6b1bd2.1233750615.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce9dbebd2ec91ddaf302f5d8146b01311b6b1bd2.1233750615.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- /dev/null
> +++ b/security/integrity/ima/Kconfig
> @@ -0,0 +1,49 @@
> +# IBM Integrity Measurement Architecture
> +#
> +config IMA
> +	bool "Integrity Measurement Architecture(IMA)"
> +	depends on ACPI

Ugh?

> +	select SECURITYFS
> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_MD5
> +	select CRYPTO_SHA1
> +	select TCG_TPM
> +	select TCG_TIS
> +	help
> +	  The Trusted Computing Group(TCG) runtime Integrity
> +	  Measurement Architecture(IMA) maintains a list of hash
> +	  values of executables and other sensitive system files,
> +	  as they are read or executed. If an attacker manages
> +	  to change the contents of an important system file
> +	  being measured, we can tell.
> +
> +	  If your system has a TPM chip, then IMA also maintains
> +	  an aggregate integrity value over this list inside the
> +	  TPM hardware, so that the TPM can prove to a third party
> +	  whether or not critical system files have been modified.

Sound like 'well use this so people with homegrown distros can't
access our e-shop'...

> +	  Read <http://www.usenix.org/events/sec04/tech/sailer.html>
> +	  to learn more about IMA.

Maybe some basic docs should go into Documentation?

> +config IMA_MEASURE_PCR_IDX
> +	int
> +	depends on IMA
> +	range 8 14
> +	default 10
> +	help
> +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> +	  that IMA uses to maintain the integrity aggregate of the
> +	  measurement list.  If unsure, use the default 10.

This is quite ugly. How do you expect enduser to get this right?
How do you expect distro to get it right for all users?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
