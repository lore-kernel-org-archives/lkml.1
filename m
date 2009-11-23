Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZKWJpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZKWJpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZKWJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:45:07 -0500
Received: from mga10.intel.com ([192.55.52.92]:53671 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753791AbZKWJpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:45:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,271,1257148800"; 
   d="scan'208";a="516464419"
Date: Mon, 23 Nov 2009 12:21:17 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091123172117.GA14372@youquan-linux.bj.intel.com>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au> <20091119110222.GA19379@youquan-linux.bj.intel.com> <20091119114730.GC6392@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119114730.GC6392@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you show me a sample /proc/crypto showing this problem and how
> you created it?
> 
Sorry for late. I use the cryptodev-2.6 tree, enable AESNI and PCLMULQDQ NI.

Step: like this.  
A. modprobe tcrypt mode=35
B. modprobe aesni-intel
C. modprobe tcrypt mode=35

After I do A. Because it do not load aesni-intel, so I do B, then repeat C.

cat /proc/crypto.

there is two identical gcm: 

name         : gcm(aes)
driver       : gcm_base(ctr-aes-aesni,ghash-clmulni)
module       : gcm
priority     : 400
refcnt       : 1
selftest     : unknown
type         : aead
async        : yes
blocksize    : 1
ivsize       : 16
maxauthsize  : 16
geniv        : <built-in>

name         : gcm(aes)
driver       : gcm_base(ctr-aes-aesni,ghash-clmulni)
module       : gcm
priority     : 400
refcnt       : 1
selftest     : unknown
type         : aead
async        : yes
blocksize    : 1
ivsize       : 16
maxauthsize  : 16
geniv        : <built-in>

name         : fpu(ctr(__aes-aesni))
driver       : cryptd(fpu(ctr(__driver-aes-aesni)))
module       : cryptd
priority     : 50
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : fpu(ctr(__aes-aesni))
driver       : fpu(ctr(__driver-aes-aesni))
module       : fpu
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16

 

