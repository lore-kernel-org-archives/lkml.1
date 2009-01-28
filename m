Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZA1Jwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZA1Jwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZA1JwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:52:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:49052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZA1JwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:52:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,337,1231142400"; 
   d="scan'208";a="485215597"
Subject: Re: hardware time stamping with optional structs in data area
From: Patrick Ohly <patrick.ohly@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
In-Reply-To: <20090128090821.GA15770@gondor.apana.org.au>
References: <20090128090821.GA15770@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 10:52:13 +0100
Message-Id: <1233136333.26507.38.camel@pohly-MOBL>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 11:08 +0200, Herbert Xu wrote:
> Patrick Ohly <patrick.ohly@intel.com> wrote:
> >
> > True - at this time. But what if this extension mechanism turns out to
> > be useful and we end up with more optional structures? I was hoping that
> > this might be the case and thus tried to make it easy to add more
> > structures.
> 
> You're putting the extension in the skb->end area, right?

Right.

> How big are the time stamps? If they're not that big, why don't
> we put it into the shinfo structure itself? For the common case,
> we have plenty of space due to kmalloc padding anyway.

Two 64 bit fields have to be added for time stamps plus 3 bits for flags
(for time stamping instructions, currently in skb_shared_tx).

Putting that into shinfo should work fine. I thought extending that
structure with information that isn't needed for all packets was as bad
as extending sk_buff itself. If that isn't the case, then extending
shinfo definitely is the simplest solution.

Bye, Patrick


