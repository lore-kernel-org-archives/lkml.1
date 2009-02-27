Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZB0Ljo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZB0Ljo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 06:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZB0Ljf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 06:39:35 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44035 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754696AbZB0Lje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 06:39:34 -0500
Date: Fri, 27 Feb 2009 19:39:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <mbroz@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: Bug of dm-crypt?
Message-ID: <20090227113927.GA24024@gondor.apana.org.au>
References: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com> <20090227054147.GA22159@gondor.apana.org.au> <49A7A71E.50702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A7A71E.50702@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 09:41:02AM +0100, Milan Broz wrote:
> 
> Can you send me backtrace from that panic?
> 
> What's wrong in async callback now - mempool_free using async_req directly?

The req you get in the completion function is not necessarily
the req that you started with.  The only thing you can rely on
is req->data.

> (Btw in some previous discussuion I asked if cryptd can be used
> for some kind of parallel speedup for dm-crypt in async mode and response
> was that cryptd "is only meant to be a demo showing how an async
> implementation should be written".
> 
> So this changed to real working thread for AES-NI?)

Yes we changed it :) cryptd is no longer for fun only.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
