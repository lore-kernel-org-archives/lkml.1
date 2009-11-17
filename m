Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZKQBCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZKQBCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZKQBCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:02:42 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:43064 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755393AbZKQBCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:02:42 -0500
Date: Tue, 17 Nov 2009 09:02:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: David Miller <davem@davemloft.net>, ghaskins@novell.com, mst@redhat.com,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
Message-ID: <20091117010238.GA10029@gondor.apana.org.au>
References: <4AF98A8C.9040201@novell.com> <20091114011229.GA18580@gondor.apana.org.au> <4AFE08EF.2030308@gmail.com> <20091113.190438.78469912.davem@davemloft.net> <4B016041.5030000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B016041.5030000@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 09:22:57AM -0500, Gregory Haskins wrote:
> 
> But really, this is somewhat orthogonal to the original problem, so let
> me see if we can bring it back on topic.  Michael stated that this patch
> in question may be problematic because there are places in the stack
> that can get_page() without also maintaining a reference to the shinfo
> object.  Evgeniy seems to say the opposite.  I am not sure who is right,
> or if I misunderstood one or both of them.  Any thoughts?

There are loads of places where this can happen.  Start with
pskb_expand_head.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
