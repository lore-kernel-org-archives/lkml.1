Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZA3T3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZA3T3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZA3T3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:29:31 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34150 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZA3T3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:29:31 -0500
Subject: Re: [PATCH 2/6] integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <alpine.LRH.1.10.0901301032080.29870@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
	 <eae67eb66b76df32f0e95c4cda33fd6271567c94.1233262163.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.1.10.0901301032080.29870@tundra.namei.org>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 14:29:28 -0500
Message-Id: <1233343768.8801.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 11:07 +1100, James Morris wrote:
> On Thu, 29 Jan 2009, Mimi Zohar wrote:
> 
> > +++ b/security/integrity/ima/Kconfig
> > @@ -0,0 +1,49 @@
> > +# IBM Integrity Measurement Architecture
> > +#
> > +config IMA
> > +	bool "Integrity Measurement Architecture(IMA)"
> > +	depends on ACPI
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
> 
> Out of interest, do you know if the TCG has analyzed their use of SHA-1 
> in light of various attacks on the algorithm over the last few years?
> 
> The IETF has published analysis and recommendations relating to the use of 
> SHA-1 (and other cryptographic hashes) with IP protocols:
> 
> http://www.ietf.org/rfc/rfc4894.txt
> http://www.ietf.org/rfc/rfc4270.txt
> 
> It would be useful to know if similar analysis has been performed for TPM.
> 
> 
> - James

Sorry, the TCG does not have a postion paper on this.  We do not see
the current SHA-1 collision weakness being applicable to how the TPM
is currently being used by IMA.  If, however, it does becomes an issue,
we could replace the SHA-1 template measurement with SHA-256.

Mimi

