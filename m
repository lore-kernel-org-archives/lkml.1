Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYE0RyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYE0RyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbYE0Rxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:53:52 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54481 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbYE0Rxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:53:51 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: benh@kernel.crashing.org, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <adad4n71wb3.fsf@cisco.com>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
	 <adaprr721c6.fsf@cisco.com>
	 <1211906268.3435.44.camel@localhost.localdomain>
	 <adad4n71wb3.fsf@cisco.com>
Content-Type: text/plain
Date: Tue, 27 May 2008 12:53:45 -0500
Message-Id: <1211910825.7160.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 10:38 -0700, Roland Dreier wrote:
> > Actually, this specifically should not be.  The need for mmiowb on altix
>  > is because it explicitly violates some of the PCI rules that would
>  > otherwise impede performance.   The compromise is that readX on altix
>  > contains the needed dma flush but there's a variant operator,
>  > readX_relaxed that doesn't (for drivers that know what they're doing).
>  > The altix critical drivers have all been converted to use the relaxed
>  > form for performance, and the unconverted ones should all operate just
>  > fine (albeit potentially more slowly).
> 
> Is this a recent change?  Because as of October 2007, 76d7cc03
> ("IB/mthca: Use mmiowb() to avoid firmware commands getting jumbled up")
> was needed.  But this was involving writel() (__raw_writel() actually,
> looking at the code), not readl().  But writel_relaxed() doesn't exist
> (and doesn't make sense).

Um, OK, you've said write twice now ... I was assuming you meant read.
Even on an x86, writes are posted, so there's no way a spin lock could
serialise a write without an intervening read to flush the posting
(that's why only reads have a relaxed version on altix).  Or is there
something else I'm missing?

James


