Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXH3Aqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXH3Aqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 20:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXH3Aqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 20:46:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:34556 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753701AbXH3Aqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 20:46:34 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19omARYZ0BobJTX1HV4Tl2TGiwSyN8xmQ8SAKTy2X
	RwGDZbG2dku5Qs
Date: Thu, 30 Aug 2007 02:46:41 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Lund <firefly@vax64.dk>, Christoph Hellwig <hch@infradead.org>,
       trivial@kernel.org, linux-kernel@vger.kernel.org,
       Momchil Velikov <velco@fadata.bg>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] avoid negative (and full-width) shifts in
	radix-tree.c, take 3
Message-ID: <20070830004641.GA26580@atjola.homenet>
References: <1188402291.7216.90.camel@localhost.localdomain> <Pine.LNX.4.64.0708291048250.21332@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0708291048250.21332@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.08.29 10:49:12 -0700, Christoph Lameter wrote:
> On Wed, 29 Aug 2007, Peter Lund wrote:
> 
> >  
> > -	if (tmp >= RADIX_TREE_INDEX_BITS)
> > -		index = ~0UL;
> > -	return index;
> > +	if (shift < 0)
> > +		return ~0UL;
> > +	if (shift >= 8 * sizeof(unsigned long))
> 
> 8* sizeof(unsigned long) is the constant BITS_PER_LONG.

Or in this context: RADIX_TREE_INDEX_BITS, which happens to be the old
check, which just needed to be extended to cover negative shifts.

Björn
