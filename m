Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYE2WGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYE2WGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYE2WGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:06:40 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:18016 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYE2WGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:06:39 -0400
X-IronPort-AV: E=Sophos;i="4.27,563,1204531200"; 
   d="scan'208";a="105763336"
From: Roland Dreier <rdreier@cisco.com>
To: Jes Sorensen <jes@sgi.com>
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
	<1211922696.3286.82.camel@pasglop> <adaiqwzsa83.fsf@cisco.com>
	<yq0iqwxrwuh.fsf@jaguar.mkp.net>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 29 May 2008 15:06:35 -0700
In-Reply-To: <yq0iqwxrwuh.fsf@jaguar.mkp.net> (Jes Sorensen's message of "29
	May 2008 10:47:18 -0400")
Message-ID: <adawslcojdg.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 May 2008 22:06:36.0027 (UTC) FILETIME=[42F15CB0:01C8C1D8]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The problem is that your two writel's, despite being both issued on
 > cpu X, due to the spin lock, in your example, can end up with the
 > first one going through NR 1 and the second one going through NR 2. If
 > there's contention on NR 1, the write going via NR 2 may hit the PCI
 > bridge prior to the one going via NR 1.

Really??  I can't see how you can expect any drivers to work reliably if
simple code like

	writel(reg1);
	writel(reg2);

might end up with the write to reg2 hitting the device before the write
to reg1.  Almost all MMIO stuff has ordering requirements and will
totally break if you allow, say, the "start IO" write to be reordered
before the "set IO address" write.

 - R.
