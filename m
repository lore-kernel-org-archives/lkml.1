Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZIPBUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZIPBUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZIPBUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:20:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:15572 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZIPBUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:20:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,393,1249282800"; 
   d="scan'208";a="493833851"
Subject: Re: [PATCH -v3] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
From: Huang Ying <ying.huang@intel.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <1253025731.11643.333.camel@desktop>
References: <1252993367.15717.340.camel@yhuang-dev.sh.intel.com>
	 <1253025731.11643.333.camel@desktop>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 09:20:32 +0800
Message-Id: <1253064032.15717.369.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 22:42 +0800, Daniel Walker wrote: 
> On Tue, 2009-09-15 at 13:42 +0800, Huang Ying wrote:
> > Hi, Herbert,
> > 
> > The dependency to irq_fpu_usable has been merged by linus' tree.
> > 
> > Best Regards,
> > Huang Ying
> > -------------------------------------------------------------------------->
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
> > v3:
> >  - Revise GHASH implementation, performance increase about 2x.
> 
> 
> You have three style issues in this patch, for instance you shouldn't
> set values inside if() statements .. If you run checkpatch on this it
> will tell you all the style problems. Could you run this through
> checkpatch and fix any errors it's find ?

Thanks, I will fix them.

Best Regards,
Huang Ying

