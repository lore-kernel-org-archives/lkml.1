Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZHLSmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZHLSmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZHLSmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:42:19 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:43353 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZHLSmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:42:18 -0400
Message-ID: <4A830B8C.5000402@colorfullife.com>
Date: Wed, 12 Aug 2009 20:35:56 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de> <4A81B646.5060301@colorfullife.com> <4A81B728.7040200@oracle.com> <20090812040756.GA5330@wotan.suse.de>
In-Reply-To: <20090812040756.GA5330@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2009 06:07 AM, Nick Piggin wrote:
> A semaphore set with 250 will use 2K before, and 10K afterward. I
> don't know that it is a huge amount really, given that they also
> have to presumably be *protecting* stuff.
>
>    
The allocation uses vmalloc for larger allocations, thus 10k should not 
be an issue.
> We can convert them to hlists (I was going to send a patch to do
> everything in hlists, but hlists are missing some _rcu variants...
> maybe I should just convert the pending lists to start with).
>
>    
Is it possible to use list_add and list_add_tail instead?
Add the "waiting for zero" to the beginning and "waiting for nonzero" to 
the end.

Basically, the same approach for "simple" and "complex" operations:
- if all operations are simple operations, then all operations affect 
only individual semaphores
--> use per semaphore lists
- if there is one complex operation, then the global, per 
semaphore-array lists are used.


--
     Manfred
