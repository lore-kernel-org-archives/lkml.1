Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbZKYDMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbZKYDMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbZKYDMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:12:32 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:42754 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758262AbZKYDMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:12:32 -0500
Date: Wed, 25 Nov 2009 11:12:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091125031234.GA24801@gondor.apana.org.au>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au> <20091119110222.GA19379@youquan-linux.bj.intel.com> <20091119114730.GC6392@gondor.apana.org.au> <20091123174724.GB14372@youquan-linux.bj.intel.com> <20091123113126.GA6297@gondor.apana.org.au> <20091125103516.GA25093@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125103516.GA25093@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 05:35:16AM -0500, Youquan,Song wrote:
>
> For example:
> 
> struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32
> mask)
> 
> The parameter "name",  sometime it is "alg->cra_name" while sometime it
> become "alg->cra_driver_name". What's to lookup, algorithm or driver, depends on
> the context of parameter, So it need confirm no duplicate name exists between 
> cra_driver_name and cra_name. Therefore, there are some werid checking needed, 
> such as following:
> 
>                 if (!strcmp(q->cra_driver_name, alg->cra_name) ||
>                     !strcmp(q->cra_name, alg->cra_driver_name))
> 
> 
> I wonder, Can we define two functions: one lookup algorithm other lookup
> driver? It will be more clear. 

No that would defeat the whole point of having algorithm names
vs. driver names.  When you perform a lookup, we will look for
both algorithm matches AND driver matches.  Exactly which one
takes precedence when two matches are present is determined by
the priority.

Anyway, none of this matters to you if you're just working with
driver implementations so don't even worry about this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
