Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYGBEXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYGBEXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYGBEXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:23:25 -0400
Received: from mga10.intel.com ([192.55.52.92]:34568 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750774AbYGBEW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,735,1204531200"; 
   d="scan'208";a="347802544"
Message-ID: <486B0298.5030508@linux.intel.com>
Date: Tue, 01 Jul 2008 21:22:48 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
References: <1214916335.20711.141.camel@pasglop>
In-Reply-To: <1214916335.20711.141.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Here's something that's been running in the back of my mind for some
> time that could be a good topic of discussion at KS.
> 
> In various areas (I'll come up with some examples later), kernel code
> such as drivers want to defer some processing to "task level", for
> various reasons such as locking (taking mutexes), memory allocation,
> interrupt latency, or simply doing things that may take more time than
> is reasonable to do at interrupt time or do things that may block.
> 
> Currently, the main mechanism we provide to do that is workqueues. They
> somewhat solve the problem, but at the same time, somewhat can make it
> worse.
> 
> The problem is that delaying a potentially long/sleeping task to a work
> queue will have the effect of delaying everything else waiting on that
> work queue.
> 

how much of this would be obsoleted if we had irqthreads ?
