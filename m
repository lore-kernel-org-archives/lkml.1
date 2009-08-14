Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZHNI6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZHNI6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZHNI6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:58:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:41712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZHNI6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:58:43 -0400
Date: Fri, 14 Aug 2009 10:58:41 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
Message-ID: <20090814085841.GF32342@wotan.suse.de>
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de> <4A81B646.5060301@colorfullife.com> <4A81B728.7040200@oracle.com> <20090812040756.GA5330@wotan.suse.de> <4A830B8C.5000402@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A830B8C.5000402@colorfullife.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 08:35:56PM +0200, Manfred Spraul wrote:
> On 08/12/2009 06:07 AM, Nick Piggin wrote:
> >A semaphore set with 250 will use 2K before, and 10K afterward. I
> >don't know that it is a huge amount really, given that they also
> >have to presumably be *protecting* stuff.
> >
> >   
> The allocation uses vmalloc for larger allocations, thus 10k should not 
> be an issue.
> >We can convert them to hlists (I was going to send a patch to do
> >everything in hlists, but hlists are missing some _rcu variants...
> >maybe I should just convert the pending lists to start with).
> >
> >   
> Is it possible to use list_add and list_add_tail instead?
> Add the "waiting for zero" to the beginning and "waiting for nonzero" to 
> the end.

The only problem with this is that it means we have to walk
through the list of wait-for-zero for every increment operation,
before getting to the list of negative ops.

The wait-for-zero list should be empty in the case of simple modify
operations which are strictly +1/-1 I guess though.

I do like how it cleanly splits the modify and non-modify operations
though. But if you feel strongly about saving the sapce, I will
do as you suggest.

Thanks,
Nick
