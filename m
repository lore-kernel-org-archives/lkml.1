Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYE0Vfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYE0Vfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758493AbYE0VfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:35:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32612 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbYE0VfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:35:24 -0400
X-IronPort-AV: E=Sophos;i="4.27,550,1204531200"; 
   d="scan'208";a="104676549"
From: Roland Dreier <rdreier@cisco.com>
To: benh@kernel.crashing.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<20080526204233.75b71bb8@infradead.org>
	<1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com>
	<1211922696.3286.82.camel@pasglop>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 27 May 2008 14:33:48 -0700
In-Reply-To: <1211922696.3286.82.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Wed, 28 May 2008 07:11:36 +1000")
Message-ID: <adaiqwzsa83.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2008 21:33:49.0091 (UTC) FILETIME=[59BB3F30:01C8C041]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > This is a different issue. We deal with it on powerpc by having writel
 > set a per-cpu flag and spin_unlock() test it, and do the barrier if
 > needed there.

Cool... I assume you do this for mutex_unlock() etc?

Is there any reason why ia64 can't do this too so we can kill mmiowb and
save everyone a lot of hassle?  (mips, sh and frv have non-empty
mmiowb() definitions too but I'd guess that these are all bugs based on
misunderstandings of the mmiowb() semantics...)

 > However, drivers such as e1000 -also- have a wmb() between filling the
 > ring buffer and kicking the DMA with MMIO, with a comment about this
 > being needed for ia64 relaxed ordering.

I put these barriers into mthca, mlx4 etc, although it came from my
possible misunderstanding of the memory ordering rules in the kernel
more than any experience of problems (as opposed the the mmiowb()s,
which all came from real world bugs).

 - R.
