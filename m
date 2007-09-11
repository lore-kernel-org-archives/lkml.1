Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbXIKCVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbXIKCVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 22:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761744AbXIKCVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 22:21:24 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1339 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761656AbXIKCVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 22:21:23 -0400
Date: Tue, 11 Sep 2007 10:21:10 +0800
From: Herbert Xu <herbert.xu@redhat.com>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jeff@garzik.org,
       afleming@freescale.com
Subject: Re: [PATCH resend] Fix a lock problem in generic phy code
Message-ID: <20070911022110.GC1544@gondor.apana.org.au>
References: <E1IUf6h-0006qu-00@gondolin.me.apana.org.au> <200709102045.51063.hjk@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200709102045.51063.hjk@linutronix.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 08:45:50PM +0200, Hans-Jürgen Koch wrote:
>
> > Could you please audit all instances of physdev->lock and add
> > _bh where necessary?  I can see that at least phys_stop also
> > needs the _bh.
> 
> I think the patch does all that's necessary. At least, there're no error
> messages in the logs anymore. I didn't check if there's an error on
> unload, though.

Sorry, but you can't rely on the non-existence of lockdep
messages as a proof of correctness :)

If we're going to fix the obvious bugs here, we should fix
the subtle ones too as otherwise they'll be much harder to
notice with this patch merged.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
