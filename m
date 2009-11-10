Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZKJEUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZKJEUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZKJEUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:20:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:51439 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbZKJEUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:20:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,713,1249282800"; 
   d="scan'208";a="568070672"
Subject: Re: [BUGFIX -v2 for .32] crypto, gcm, fix another complete call in
 complete fuction
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20091110031022.GA13710@gondor.apana.org.au>
References: <1257751454.22519.2287.camel@yhuang-dev.sh.intel.com>
	 <20091109190250.GC9588@gondor.apana.org.au>
	 <1257821399.22519.2410.camel@yhuang-dev.sh.intel.com>
	 <20091110031022.GA13710@gondor.apana.org.au>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 12:20:55 +0800
Message-Id: <1257826855.22519.2503.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 11:10 +0800, Herbert Xu wrote: 
> On Tue, Nov 10, 2009 at 10:49:59AM +0800, Huang Ying wrote:
> >
> > Yes. This is for performance only. Because crypto_gcm_reqctx(req) is not
> > so trivial (it needs access tfm), and used by every xxx_done function,
> > so I think it is better to just call crypto_gcm_reqctx once and pass it
> > down. Do you think so?
> 
> Since we only support blocksize == 16, that means the alignment
> cannot exceed 16 bytes.  So just always align to 16 bytes and that
> should make crypto_gcm_reqctx trivial once optimised by the
> compiler.

Does it seem a little tricky?

Anyway, I will prepare a patch for pure bug fix, and leave performance
optimization for later.

Best Regards,
Huang Ying


