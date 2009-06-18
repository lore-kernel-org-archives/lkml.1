Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZFRBtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZFRBtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZFRBtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:49:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:34330 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbZFRBtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:49:31 -0400
Date: Thu, 18 Jun 2009 09:48:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Message-ID: <20090618014858.GA1368@gondor.apana.org.au>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com> <20090617164622.GB25357@elte.hu> <4A3922A4.1080300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3922A4.1080300@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 10:06:44AM -0700, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >>  
> >> +static inline int kernel_fpu_using(void)
> >> +{
> >> +	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> >> +		return 1;
> >> +	return 0;
> >> +}
> >> +
> > 
> > Looks sane to me. Herbert, do you ack it?

Ack.  Please pick it up in your tree.  Thanks!

> Huang: if I recall correctly, these functions were originally designed
> to deal with the fact that VIA processors generate spurious #TS faults
> due to broken design of the Padlock instructions.  The AES and PCLMUL
> instructions actually use SSE registers and so will require different
> structure.

No irq_ts_save was the one designed for the VIA, the Intel stuff
does save the FPU state.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
