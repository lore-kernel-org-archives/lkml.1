Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZIOOlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZIOOlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZIOOlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:41:19 -0400
Received: from fifo99.com ([67.223.236.141]:48065 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbZIOOlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:41:18 -0400
Subject: Re: [PATCH -v3] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
From: Daniel Walker <dwalker@fifo99.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <1252993367.15717.340.camel@yhuang-dev.sh.intel.com>
References: <1252993367.15717.340.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 07:42:11 -0700
Message-Id: <1253025731.11643.333.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 13:42 +0800, Huang Ying wrote:
> Hi, Herbert,
> 
> The dependency to irq_fpu_usable has been merged by linus' tree.
> 
> Best Regards,
> Huang Ying
> -------------------------------------------------------------------------->
> PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> carry-less multiplication. More information about PCLMULQDQ can be
> found at:
> 
> http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> 
> Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> kernel_fpu_begin/end, which can be used only in process context, the
> acceleration is implemented as crypto_ahash. That is, request in soft
> IRQ context will be defered to the cryptd kernel thread.
> 
> v3:
>  - Revise GHASH implementation, performance increase about 2x.


You have three style issues in this patch, for instance you shouldn't
set values inside if() statements .. If you run checkpatch on this it
will tell you all the style problems. Could you run this through
checkpatch and fix any errors it's find ?

Daniel

