Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYLTILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYLTILq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 03:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYLTILd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 03:11:33 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:51045 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbYLTILc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 03:11:32 -0500
Date: Sat, 20 Dec 2008 19:10:45 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Vladislav Bolkhovitin <vst@vlnb.net>,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
	space data
Message-ID: <20081220081045.GA17439@gondor.apana.org.au>
References: <494012C4.7090304@vlnb.net> <494C0255.8010208@goop.org> <20081219220452.GB704@ioremap.net> <494C1E5E.7070809@goop.org> <20081219223314.GA2736@ioremap.net> <494C50BB.5030809@goop.org> <20081220020250.GA15064@gondor.apana.org.au> <494C8D57.7040808@goop.org> <20081220065105.GA16936@gondor.apana.org.au> <494CA226.9000200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494CA226.9000200@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 11:43:34PM -0800, Jeremy Fitzhardinge wrote:
>
> Hm.  So if I get a destructor call from the shared_info, can I go an  
> inspect the page refcounts to see if its really the last use?

The pages that were originally in the shared_info at creation
time may no longer be there by the time it's freed because of
pskb_pull_tail.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
