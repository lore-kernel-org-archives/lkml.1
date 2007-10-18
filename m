Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbXJRVfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbXJRVfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbXJRVfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:35:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:45745 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbXJRVff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:35:35 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <E1IiWTY-0000jx-00@gondolin.me.apana.org.au>
References: <E1IiWTY-0000jx-00@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 07:35:05 +1000
Message-Id: <1192743305.7367.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-18 at 22:35 +0800, Herbert Xu wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > Note that some kind of read barrier or compiler barrier should be needed
> > regardless, or we are just not sync'ing with anything at all (we may
> > have loaded the value ages ago and thus operate on a totally stale
> > value). I prefer a full barrier to also ensure all previous stores are
> > pushed out.
> 
> We already have a compiler barrier there in the form of cpu_relax.

Isn't it too late ? The barrier should be before the test_bit, to
prevent it from moving up.

Ben.
 

