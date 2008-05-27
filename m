Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYE0VM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYE0VM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbYE0VMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:12:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:35116 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177AbYE0VMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:12:18 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <adaprr721c6.fsf@cisco.com>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
	 <adaprr721c6.fsf@cisco.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 07:11:36 +1000
Message-Id: <1211922696.3286.82.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 08:50 -0700, Roland Dreier wrote:
> > Though it's my understanding that at least ia64 does require the
>  > explicit barriers anyway, so we are still in a dodgy situation here
>  > where it's not clear what drivers should do and we end up with
>  > possibly excessive barriers on powerpc where I end up with both
>  > the wmb/rmb/mb that were added for ia64 -and- the ones I have in
>  > readl/writel to make them look synchronous... Not nice.
> 
> ia64 is a disaster with a slightly different ordering problem -- the
> mmiowb() issue.  I know Ben knows far too much about this, but for big
> SGI boxes, you sometimes need mmiowb() to avoid problems with driver
> code that does totally sane stuff like

This is a different issue. We deal with it on powerpc by having writel
set a per-cpu flag and spin_unlock() test it, and do the barrier if
needed there.

However, drivers such as e1000 -also- have a wmb() between filling the
ring buffer and kicking the DMA with MMIO, with a comment about this
being needed for ia64 relaxed ordering.

Ben.


