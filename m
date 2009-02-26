Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZBZGla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZBZGla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 01:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZBZGlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 01:41:19 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:60044 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750733AbZBZGlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 01:41:18 -0500
Date: Thu, 26 Feb 2009 14:41:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Hohnstaedt <chohnstaedt@innominate.com>
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ixp4xx_crypto panic with fragmented packets in scatterlist
Message-ID: <20090226064108.GA11726@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225115407.GB6283@elara.bln.innominate.local>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Hohnstaedt <chohnstaedt@innominate.com> wrote:
>
> However the scatterlist iteration in the arm implementation of
> dma_map_sg() uses neither of them, but simply sg++
> 
> Please try the attached compile-tested patch.

The chaining is only allowed within the crypto layer (because
we haven't ported the generic chaining to all platforms).  So
for the time being all drivers must remove the chaining before
giving the scatter list to an external party, such as the DMA
API.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
