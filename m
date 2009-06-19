Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZFSAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZFSAz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZFSAzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:55:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:25121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZFSAzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,248,1243839600"; 
   d="scan'208";a="467726955"
Subject: Re: [BUGFIX 2/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP flag in
 AES-NI accelerated ecb/cbc mode
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090618114032.GB6596@gondor.apana.org.au>
References: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
	 <20090618114032.GB6596@gondor.apana.org.au>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 08:55:20 +0800
Message-Id: <1245372920.22246.15.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 19:40 +0800, Herbert Xu wrote:
> On Mon, Jun 15, 2009 at 05:04:57PM +0800, Huang Ying wrote:
> > Because AES-NI instructions will touch XMM state, corresponding code
> > must be enclosed within kernel_fpu_begin/end, which used
> > preempt_disable/enable. So sleep should be prevented between
> > kernel_fpu_begin/end.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> I'll apply this for now.  But it would be much better to allow
> sleeping in this case.
> 
> Couldn't we simply move the kernel_fpu_begin/end inside the loop?
> It shouldn't be too expensive when it runs the 2nd time since it
> doesn't have to save anything, right?

I will test the performance difference.

Best Regards,
Huang Ying


