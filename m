Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZAVDES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZAVDES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 22:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZAVDEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 22:04:06 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:52976 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756058AbZAVDEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 22:04:05 -0500
Date: Thu, 22 Jan 2009 14:04:00 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Message-ID: <20090122030400.GA10229@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com> <20090116033105.GB10390@gondor.apana.org.au> <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 10:32:17AM +0800, Huang Ying wrote:
>
> This is the first attempt to use a dedicate workqueue for crypto. It is
> not intended to be merged. Please feedback your comments, especially on
> desgin.

Thanks for the patch!

> +		spin_lock_init(&cpu_queue->lock);

Since we're switching to per-cpu queues it would be good to just
kill the spin lock.  AFAICS the only place you really need it is
in cryptd_tfm_in_queue.  That's just used for debugging so we can
just kill it and lose this spin lock.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
