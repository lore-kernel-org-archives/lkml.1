Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbZBLKoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbZBLKoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZBLKoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:44:20 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:45103 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756355AbZBLKoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:44:19 -0500
Date: Thu, 12 Feb 2009 18:43:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] Export symbol ksize()
Message-ID: <20090212104349.GA13859@gondor.apana.org.au>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com> <20090210134651.GA5115@epbyminw8406h.minsk.epam.com> <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 04:06:53PM +0200, Pekka J Enberg wrote:
> 
> Herbert, what do you think of this (untested) patch? Alternatively, we 
> could do something like kfree_secure() but it seems overkill for this one 
> call-site.

I don't understand why you want to limit the use of ksize.  If
kmalloc is reserving more memory than what the user is asking for,
then we should let them know the exact amount so that the extra
bits aren't wasted.

The only way to do that is through ksize.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
