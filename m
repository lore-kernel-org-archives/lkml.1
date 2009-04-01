Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZDAFaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZDAFaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZDAFa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:30:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:40875 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZDAFa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,305,1235980800"; 
   d="scan'208";a="443867256"
Message-ID: <49D2FBEF.7080607@intel.com>
Date: Tue, 31 Mar 2009 22:30:23 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dw_dmac: set CAP_PRIVATE capability for DW DMA controller
References: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>	<129600E5E5FB004392DDC3FB599660D790F8C3EB@irsmsx504.ger.corp.intel.com> <20090401070440.326f6e7f@hcegtvedt>
In-Reply-To: <20090401070440.326f6e7f@hcegtvedt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Christian Egtvedt wrote:
> The weird part was that when testing this, the dma_request_channel()
> would not return any channel before DMA_PRIVATE flag was set. I think I
> did this some time ago, I can do a retest with the current 2.6.29 and
> see how it behaves.
> 

If CONFIG_NET_DMA=y then available channels will be consumed for 
'public' usage.  I would turn that option off for AVR32 as it hurts 
performance on dma-incoherent archs like ARM.  Async_tx will also 
consume public channels if loaded.  2.6.30 will have the 
CONFIG_ASYNC_TX_DMA option to turn off this allocation... or just set 
DMA_PRIVATE and not worry these :-).

--
Dan
