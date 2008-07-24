Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYGXNON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYGXNON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYGXNN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:13:58 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:47260 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751014AbYGXNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:13:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HaYispjW2gc1Mwbi7sdMRfXhHEf+dKhp4J5kVaNb4NKQjcEPKarpnhPSm9H+0vJDnYqX6XvtK+cS9HZzsRUUwHljUat8Q8fXIByNamk7lsP4vxcPD8V+W/arhPJpdrBA5owIM8xT/CHLtA1T6h5SdjDRA4ZDXAFE6npfYntjcpo=  ;
X-YMail-OSG: amVDtPMVM1laayiZ0ntQRo5PSTA4g_TkzFSDYfA8zMypnNHklw_s882myOuNxYTHA_MzeiftNxy0kmLrk5HtxubvnaeeVNKeUW68.W3f0bSMkFfnOPBh7eyUCmlwUzfL1nQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL pointer dereference
Date: Thu, 24 Jul 2008 23:13:46 +1000
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Patrick McHardy <kaber@trash.net>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de, rjw@sisk.pl,
       ilpo.jarvinen@helsinki.fi, Dave Jones <davej@redhat.com>,
       Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20080724060448.GA10203@elte.hu> <200807242256.09107.nickpiggin@yahoo.com.au> <20080724130422.GB7426@gondor.apana.org.au>
In-Reply-To: <20080724130422.GB7426@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242313.47041.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 23:04, Herbert Xu wrote:
> On Thu, Jul 24, 2008 at 10:56:08PM +1000, Nick Piggin wrote:
> > OTOH, skb allocation uses kmalloc don't they? So you could still use
> > SLOB ksize for that I guess.
>
> Yes I was referring to the data portion which is kmalloc'ed.
> That is also why I'm interested in ksize because a priori we
> don't know exactly how big it's going to be.  However, we do
> know that statistically 1500 will dominate.
>
> I'm not interested in ksize for kmem_cache at all.  So in fact
> we could have something simpler that's based on kmalloc's rounding
> algorithm instead.

Yes you could definitely have a function that returns allocated
bytes for a given kmalloc size. Should be about as fast or faster
than extracting the size from the kaddr...

