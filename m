Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbZFRLkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbZFRLkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFRLkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:40:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47414 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821AbZFRLkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:40:32 -0400
Date: Thu, 18 Jun 2009 19:40:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX 2/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP flag in
	AES-NI accelerated ecb/cbc mode
Message-ID: <20090618114032.GB6596@gondor.apana.org.au>
References: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 05:04:57PM +0800, Huang Ying wrote:
> Because AES-NI instructions will touch XMM state, corresponding code
> must be enclosed within kernel_fpu_begin/end, which used
> preempt_disable/enable. So sleep should be prevented between
> kernel_fpu_begin/end.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

I'll apply this for now.  But it would be much better to allow
sleeping in this case.

Couldn't we simply move the kernel_fpu_begin/end inside the loop?
It shouldn't be too expensive when it runs the 2nd time since it
doesn't have to save anything, right?

Cheer,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
