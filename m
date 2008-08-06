Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYHFLET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYHFLET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYHFLEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:04:09 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:43012 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753741AbYHFLEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:04:08 -0400
Date: Wed, 6 Aug 2008 19:03:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavel Machek <pavel@suse.cz>
Cc: Austin Zhang <austin_zhang@linux.intel.com>, bunk@kernel.org,
       dwmw2@infradead.org, davem@davemloft.net, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Message-ID: <20080806110348.GA32022@gondor.apana.org.au>
References: <1218000211.4231.23.camel@localhost.localdomain> <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:42:26AM +0200, Pavel Machek wrote:
>
> > +static int crc32c_intel_final(struct ahash_request *req)
> > +{
> > +	u32 *crcp = ahash_request_ctx(req);
> > +
> > +	*(__le32 *)req->result = ~cpu_to_le32p(crcp);
> > +	return 0;
> 
> This is not user visible, so le32 should be enough.

Unfortunately I don't think le32 exists, it'd definitely be nice
to have it though.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
