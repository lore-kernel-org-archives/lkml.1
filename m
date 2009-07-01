Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZGAWnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZGAWnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZGAWnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:43:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbZGAWne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:43:34 -0400
Message-ID: <4A4BE64A.3050805@kernel.org>
Date: Thu, 02 Jul 2009 07:42:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <4A4A9DC6.6020003@kernel.org> <20090701064250.GM6760@one.firstfloor.org> <4A4B38C5.1070504@kernel.org> <20090701122312.GP6760@one.firstfloor.org> <4A4B5C32.1010009@kernel.org> <20090701131146.GR6760@one.firstfloor.org> <alpine.DEB.1.10.0907011330450.9522@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0907011330450.9522@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 22:42:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 1 Jul 2009, Andi Kleen wrote:
> 
>> And it's imho unclear if that is all worth it just to avoid
>> wasting some memory in the "256 possible CPUs" case (which
>> I doubt is particularly realistic anyways, at least I don't
>> know of any Hypervisor today that scales to 256 CPUs)
> 
> I basically agree. Its not worth it given the rare cases where this
> matters. It will be a lot of code with callbacks in each subsystem.
> 
> One of the motivations of working on revising the percpu handling for
> me was that we could get rid of these screwy callbacks that are rarely
> tested and cause all sorts of other issues with locking and serialization.

Hmmm.... yeah.  I have to agree that callbacks are nasty and requiring
all users to use callbacks wouldn't be very nice.  Once the current
dust settles down, I'll look around and see whether this can be solved
in some reasonable way.

Thanks.

-- 
tejun
