Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZKWKwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZKWKwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZKWKwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:52:46 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:48086 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757103AbZKWKwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:52:45 -0500
Date: Mon, 23 Nov 2009 18:52:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091123105249.GA5915@gondor.apana.org.au>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au> <20091119110222.GA19379@youquan-linux.bj.intel.com> <20091119114730.GC6392@gondor.apana.org.au> <20091123172117.GA14372@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123172117.GA14372@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 12:21:17PM -0500, Youquan,Song wrote:
>
> Sorry for late. I use the cryptodev-2.6 tree, enable AESNI and PCLMULQDQ NI.
> 
> Step: like this.  
> A. modprobe tcrypt mode=35
> B. modprobe aesni-intel
> C. modprobe tcrypt mode=35
> 
> After I do A. Because it do not load aesni-intel, so I do B, then repeat C.
> 
> cat /proc/crypto.
> 
> there is two identical gcm: 
> 
> name         : gcm(aes)
> driver       : gcm_base(ctr-aes-aesni,ghash-clmulni)
> module       : gcm
> priority     : 400
> refcnt       : 1
> selftest     : unknown

It's creating a second copy because the first one failed the
self-test.

So you should try to identify the reason for the failed self-test.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
