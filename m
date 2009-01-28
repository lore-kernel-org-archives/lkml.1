Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZA1DIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZA1DIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZA1DIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:08:09 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:57178 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751691AbZA1DII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:08:08 -0500
Date: Wed, 28 Jan 2009 14:08:02 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clarification of allowed context for crypto routines
Message-ID: <20090128030802.GA5536@gondor.apana.org.au>
References: <20090124093245.GA4889@gondor.apana.org.au> <200901272101.20190.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901272101.20190.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 09:01:13PM +0300, Andrey Borzenkov wrote:
> 
> - all usage is kmap_atomic; which implies it should be technically safe 
> (not advisable) to use in interrupt context as well

kmap_atomic has limited slots, we currently use two slots for
process context and two slots for softirq context.  Adding support
for hardirq context can be done by using another two slots but
that would mean adding another conditional branch in the code path.

As it stands I have not seen any convincing use cases that would
justify this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
