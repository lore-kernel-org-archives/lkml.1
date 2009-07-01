Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZGANIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZGANIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZGANIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:08:00 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47785 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752257AbZGANIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:08:00 -0400
Date: Wed, 1 Jul 2009 21:07:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090701130758.GA2428@gondor.apana.org.au>
References: <87eit3l7y6.fsf@basil.nowhere.org> <20090701033924.GA29762@gondor.apana.org.au> <20090701062732.GK6760@one.firstfloor.org> <20090701070332.GA31103@gondor.apana.org.au> <20090701072226.GN6760@one.firstfloor.org> <20090701083144.GA31863@gondor.apana.org.au> <20090701084430.GC4769@jolsa.lab.eng.brq.redhat.com> <20090701105852.GA925@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701105852.GA925@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 06:58:52PM +0800, Herbert Xu wrote:
> 
> It would be good to know whether this bug occurs on the upstream
> kernel because as it stands, the patch is a no-op for the upstream
> kernel on x86-64.

I take that back.  Andi, please look at section 8.2.3.4 of the
IA-32 Architectures Software Developer's Manual Volume 3A, "Loads
May Be Reordered with Earlier Stores to Different Locations.
This seems to be exactly the scenario that we have here, and shows
why mfence is required.

In our case, we're doing

CPU1					CPU2
Write data ready			Add ourselves to wait queue
Read wait queue to notify		Check data ready

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
