Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZKYC7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZKYC7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbZKYC7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:59:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:37351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758225AbZKYC7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:59:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,283,1257148800"; 
   d="scan'208";a="470355880"
Date: Wed, 25 Nov 2009 05:35:16 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091125103516.GA25093@youquan-linux.bj.intel.com>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au> <20091119110222.GA19379@youquan-linux.bj.intel.com> <20091119114730.GC6392@gondor.apana.org.au> <20091123174724.GB14372@youquan-linux.bj.intel.com> <20091123113126.GA6297@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123113126.GA6297@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 23, 2009 at 12:47:24PM -0500, Youquan,Song wrote:
> >
> > The alg->cra_name and alg->cra_driver_name, from the description,
> > cra_name is the algorithm name and cra_driver_name is the driver name.
> 
> For each algorithm you may have an arbitrary number of drivers
> implementing it.  The driver name must be unique.  However,
> duplicates are allowed so that a new version of a driver may
> be loaded while the older instances of it are still in use.
> 
> > But when I read the code, I often get confuse about these two names.
> > They often mix each other.  
> > 
> > Can you give me some instruction about them? or Can we make them more clear? Thanks. 
> 
> Well can you tell me what exactly confuses you?

Thanks. 
For example:

struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32
mask)

The parameter "name",  sometime it is "alg->cra_name" while sometime it
become "alg->cra_driver_name". What's to lookup, algorithm or driver, depends on
the context of parameter, So it need confirm no duplicate name exists between 
cra_driver_name and cra_name. Therefore, there are some werid checking needed, 
such as following:

                if (!strcmp(q->cra_driver_name, alg->cra_name) ||
                    !strcmp(q->cra_name, alg->cra_driver_name))


I wonder, Can we define two functions: one lookup algorithm other lookup
driver? It will be more clear. 
 

Thanks.
