Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZHNBFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZHNBFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZHNBF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:05:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:45839 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbZHNBF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:05:28 -0400
Date: Fri, 14 Aug 2009 11:05:27 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Message-ID: <20090814010527.GA1653@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com> <20090805094506.GA12528@gondor.apana.org.au> <1249524767.24238.318.camel@yhuang-dev.sh.intel.com> <1250044020.5337.214.camel@yhuang-dev.sh.intel.com> <20090813045300.GA19993@gondor.apana.org.au> <20090813073910.GA21784@gondor.apana.org.au> <20090813131253.GA27289@gondor.apana.org.au> <1250211667.5337.288.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250211667.5337.288.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 09:01:07AM +0800, Huang Ying wrote:
>
> I see seqiv is used in rfc3686 mode, it means seqiv can not be used on
> raw counter mode but can be used for rfc3686?

Yeah, with rfc3686 a portion of the counter is available for
counting bytes within each request.  This allows a sequential
IV to be safely used as each IV is essentially 2^32 blocks apart.

With raw counter mode as soon as you process two blocks in one
request the next IV would collide with one that has alreay been
used.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
