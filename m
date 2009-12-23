Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZLWIZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZLWIZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZLWIZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:25:19 -0500
Received: from mga12.intel.com ([143.182.124.36]:54675 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751397AbZLWIZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:25:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="225959556"
Message-ID: <4B31D3E7.5000302@linux.intel.com>
Date: Wed, 23 Dec 2009 09:25:11 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org> <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu> <4B31C210.4010100@kernel.org>
In-Reply-To: <4B31C210.4010100@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 8:09, Tejun Heo wrote:
> Doing several conversions shouldn't be difficult at all.  I'll try to
> convert async and slow work.

btw for async, it is essential that all the scheduled async functions runs as soon as possible;
so make sure that no async work is held back for lack of threads.. just make more immediately.
(the async work is rather latency sensitive, in general it is <poke hardware> <wait a long time> <done>,
the <poke hardware> step needs to be done as soon as possible to cut down the total time; latencies are often
cumulative in async due to dependencies)
