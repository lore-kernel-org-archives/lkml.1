Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZHFHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZHFHU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZHFHU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:20:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:39541 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZHFHUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:20:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,332,1246863600"; 
   d="scan'208";a="714393879"
Subject: Re: [PATCH -v2 5/5] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090806071741.GB25065@gondor.apana.org.au>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com>
	 <1249285531-22422-2-git-send-email-ying.huang@intel.com>
	 <1249285531-22422-3-git-send-email-ying.huang@intel.com>
	 <1249285531-22422-4-git-send-email-ying.huang@intel.com>
	 <1249285531-22422-5-git-send-email-ying.huang@intel.com>
	 <20090806071741.GB25065@gondor.apana.org.au>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 15:20:23 +0800
Message-Id: <1249543224.20937.0.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 15:17 +0800, Herbert Xu wrote:
> On Mon, Aug 03, 2009 at 03:45:31PM +0800, Huang Ying wrote:
> > PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> > carry-less multiplication. More information about PCLMULQDQ can be
> > found at:
> > 
> > http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> > 
> > Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> > kernel_fpu_begin/end, which can be used only in process context, the
> > acceleration is implemented as crypto_ahash. That is, request in soft
> > IRQ context will be defered to the cryptd kernel thread.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> Please resubmit this patch once irq_is_fpu_using() hits mainline.

OK. I will do that.

Best Regards,
Huang Ying

