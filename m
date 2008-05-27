Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbYE0RtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbYE0RtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYE0Rsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:48:53 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:8453 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbYE0Rsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:48:51 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 13:48:51 EDT
X-IronPort-AV: E=Sophos;i="4.27,549,1204531200"; 
   d="scan'208";a="14331408"
From: Roland Dreier <rdreier@cisco.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: benh@kernel.crashing.org, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<20080526204233.75b71bb8@infradead.org>
	<1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com>
	<1211906268.3435.44.camel@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 27 May 2008 10:38:56 -0700
In-Reply-To: <1211906268.3435.44.camel@localhost.localdomain> (James
	Bottomley's message of "Tue, 27 May 2008 11:37:48 -0500")
Message-ID: <adad4n71wb3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2008 17:38:57.0423 (UTC) FILETIME=[8A7159F0:01C8C020]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Actually, this specifically should not be.  The need for mmiowb on altix
 > is because it explicitly violates some of the PCI rules that would
 > otherwise impede performance.   The compromise is that readX on altix
 > contains the needed dma flush but there's a variant operator,
 > readX_relaxed that doesn't (for drivers that know what they're doing).
 > The altix critical drivers have all been converted to use the relaxed
 > form for performance, and the unconverted ones should all operate just
 > fine (albeit potentially more slowly).

Is this a recent change?  Because as of October 2007, 76d7cc03
("IB/mthca: Use mmiowb() to avoid firmware commands getting jumbled up")
was needed.  But this was involving writel() (__raw_writel() actually,
looking at the code), not readl().  But writel_relaxed() doesn't exist
(and doesn't make sense).

 - R.
