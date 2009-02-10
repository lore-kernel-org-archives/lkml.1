Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZBJUvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZBJUvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZBJUux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:50:53 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:42236 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZBJUuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:50:52 -0500
Date: Tue, 10 Feb 2009 14:49:28 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/7] integrity: IMA as an integrity service provider
Message-ID: <20090210204928.GA9454@us.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com> <ce9dbebd2ec91ddaf302f5d8146b01311b6b1bd2.1233750615.git.zohar@linux.vnet.ibm.com> <20090210202347.GA1382@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210202347.GA1382@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@suse.cz):
> Hi!
> 
> > --- /dev/null
> > +++ b/security/integrity/ima/Kconfig
> > @@ -0,0 +1,49 @@
> > +# IBM Integrity Measurement Architecture
> > +#
> > +config IMA
> > +	bool "Integrity Measurement Architecture(IMA)"
> > +	depends on ACPI
> 
> Ugh?
> 
> > +	select SECURITYFS
> > +	select CRYPTO
> > +	select CRYPTO_HMAC
> > +	select CRYPTO_MD5
> > +	select CRYPTO_SHA1
> > +	select TCG_TPM
> > +	select TCG_TIS
> > +	help
> > +	  The Trusted Computing Group(TCG) runtime Integrity
> > +	  Measurement Architecture(IMA) maintains a list of hash
> > +	  values of executables and other sensitive system files,
> > +	  as they are read or executed. If an attacker manages
> > +	  to change the contents of an important system file
> > +	  being measured, we can tell.
> > +
> > +	  If your system has a TPM chip, then IMA also maintains
> > +	  an aggregate integrity value over this list inside the
> > +	  TPM hardware, so that the TPM can prove to a third party
> > +	  whether or not critical system files have been modified.
> 
> Sound like 'well use this so people with homegrown distros can't
> access our e-shop'...

That would be tough to pull off, as they would have to have your
TPM's public key stored.

So a small shop could pull this off for their employees, I suppose, but
it's not practical for say a bank to do.  (And if they did, well, I'll
bank elsewhere.)

> > +	  Read <http://www.usenix.org/events/sec04/tech/sailer.html>
> > +	  to learn more about IMA.
> 
> Maybe some basic docs should go into Documentation?
> 
> > +config IMA_MEASURE_PCR_IDX
> > +	int
> > +	depends on IMA
> > +	range 8 14
> > +	default 10
> > +	help
> > +	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
> > +	  that IMA uses to maintain the integrity aggregate of the
> > +	  measurement list.  If unsure, use the default 10.
> 
> This is quite ugly. How do you expect enduser to get this right?
> How do you expect distro to get it right for all users?

I'd asked about this before, and here's how I understood it:

End-users aren't expected to get this right - note that it's
hidden.  If it changes, then that will be because some other
software using TPM (like trousers) uses 10, so it will be
changed in the upstream kernel for everyone.

-serge
