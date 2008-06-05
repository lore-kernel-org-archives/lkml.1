Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYFEIow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYFEIow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYFEIom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:44:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:37702 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYFEIol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:44:41 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jes Sorensen <jes@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Jeremy Higdon <jeremy@sgi.com>,
       Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <4847A690.302@sgi.com>
References: <1211852026.3286.36.camel@pasglop> <4843C3D7.7000609@sgi.com>
	 <200806031433.12460.nickpiggin@yahoo.com.au>
	 <200806030952.10360.jbarnes@virtuousgeek.org>  <4847A690.302@sgi.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 18:43:53 +1000
Message-Id: <1212655433.9496.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 10:40 +0200, Jes Sorensen wrote:
> Jesse Barnes wrote:
> > Now, in hindsight, using a PIO write set & test flag approach in 
> > writeX/spin_unlock (ala powerpc) might have been a better approach, but iirc 
> > that never came up in the discussion, probably because we were focused on PCI 
> > posting and not uncached vs. cached ordering.
> 
> Hi Jesse,
> 
> I am going to take a stab at implementing this so we can see how much
> of an impact it will have.

Note that the powerpc implementation currently clears the flag
on spin_lock and tests it on unlock. We are considering changing
that to not touch the flag on spin_lock and just clear it whenever
we do a sync (ie, on unlock, on explicit mmiowb, and possibly even
on readl's where we happen to do sync's).

Ben.


