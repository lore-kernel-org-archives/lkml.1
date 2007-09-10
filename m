Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXIJTqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXIJTqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbXIJTqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:46:07 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:37070 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbXIJTqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:46:06 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: blkcipher_get_spot() handling of buffer at end of page
Date: Mon, 10 Sep 2007 21:46:46 +0200
User-Agent: KMail/1.9.6
Cc: Bob Gilligan <gilligan@vyatta.com>, linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com> <20070908041423.GA8961@gondor.apana.org.au> <20070910075829.GA25851@gondor.apana.org.au>
In-Reply-To: <20070910075829.GA25851@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709102146.47655.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

On Monday 10 September 2007, Herbert Xu wrote:
> On Sat, Sep 08, 2007 at 12:14:23PM +0800, Herbert Xu wrote:
> > 
> > [CRYPTO] blkcipher: Fix handling of kmalloc page straddling
> 
> As Bob correctly noted, I had the boolean test inverted.
> Here is the correction:
> 
> [CRYPTO] blkcipher: Fix inverted test in blkcipher_get_spot
> 
> The previous patch had the conditional inverted.  This patch fixes it
> so that we return the original position if it does not straddle a page.

What about using max() for this to make your intention obvious?

static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
{
	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK); 
	return max(start, end_page);
}


Best Regards

Ingo Oeser 
