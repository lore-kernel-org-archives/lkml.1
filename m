Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYFCITg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYFCITg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYFCITV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:19:21 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:37134 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751041AbYFCITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:19:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O9MkHbE08AjIUZBOrjDqnRRq3UtjQe1DWESE/XRm3XUKJKFOxuvwo0GQdGOL5iofNov2rS/RwjrUnGjc3FE8R59Y5B4OkEMFM/xwvkGjc9AXS/he8iBemHLKq550/FJVeN2nk1pTJdjsV0Aw+py/HPZ5hc5e7hX4dVS4BFs81qM=  ;
X-YMail-OSG: zcZUGQsVM1ny5QirYKANLkgSoZhBUj0NdvA_m4_jMeszQ0SfimHxz_V.T0lffr68BNrPrU_QW3GiAV0VrU.4gk_4Sni8Q3IiQd2FTMC3qrxiUqH7XAP7L7r2463v97x0vC4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 3 Jun 2008 18:19:05 +1000
User-Agent: KMail/1.9.5
Cc: Jes Sorensen <jes@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       benh@kernel.crashing.org, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
References: <1211852026.3286.36.camel@pasglop> <200806031433.12460.nickpiggin@yahoo.com.au> <20080603081552.GC117059@sgi.com>
In-Reply-To: <20080603081552.GC117059@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031819.06559.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 18:15, Jeremy Higdon wrote:
> On Tue, Jun 03, 2008 at 02:33:11PM +1000, Nick Piggin wrote:
> > On Monday 02 June 2008 19:56, Jes Sorensen wrote:

> > > Would we be able to use Ben's trick of setting a per cpu flag in
> > > writel() then and checking that in spin unlock issuing the mmiowb()
> > > there if needed?
> >
> > Yes you could, but your writels would still not be strongly ordered
> > within (or outside) spinlock regions, which is what Linus wants (and
> > I kind of agree with).
>
> Yes they would be.  Writes from the same CPU are always ordered.  Writes
> from different CPUs are not, but that's only a concern if you protect

They are not strongly ordered WRT writes to cacheable memory. If they
were, then they would not leak out of spinlocks.

