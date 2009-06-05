Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZFEKAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZFEKAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZFEJ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:59:53 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44651 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFEJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:59:52 -0400
Date: Fri, 5 Jun 2009 15:29:31 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605095931.GE4601@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com> <20090605092733.GA27486@in.ibm.com> <6599ad830906050232n11aa30d8xfcda0a279a482f32@mail.gmail.com> <20090605094811.GD4601@linux.vnet.ibm.com> <6599ad830906050251h18f4e037h182f61aa80a5b046@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830906050251h18f4e037h182f61aa80a5b046@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 02:51:18AM -0700, Paul Menage wrote:
> On Fri, Jun 5, 2009 at 2:48 AM, Dhaval Giani<dhaval@linux.vnet.ibm.com> wrote:
> >> > Now if 11th group with same shares comes in, then each group will now
> >> > get 9% of CPU and that 10% guarantee breaks.
> >>
> >> So you're trying to guarantee 11 cgroups that they can each get 10% of
> >> the CPU? That's called over-committing, and while there's nothing
> >> wrong with doing that if you're confident that they'll not all need
> >> their 10% at the same time, there's no way to *guarantee* them all
> >> 10%. You can guarantee them all 9% and hope the extra 1% is spare for
> >> those that need it (over-committing), or you can guarantee 10 of them
> >> 10% and give the last one 0 shares.
> >>
> >> How would you propose to guarantee 11 cgroups each 10% of the CPU
> >> using hard limits?
> >>
> >
> > You cannot guarantee 10% to 11 groups on any system (unless I am missing
> > something). The sum of guarantees cannot exceed 100%.
> 
> That's exactly my point. I was trying to counter Bharata's statement, which was:
> 
> > > Now if 11th group with same shares comes in, then each group will now
> > > get 9% of CPU and that 10% guarantee breaks.
> 
> which seemed to be implying that this was a drawback of using shares
> to implement guarantees.
> 

OK :). Glad to see I did not get it wrong.

I think we are focusing on the wrong use case here. Guarantees is just a
useful side-effect we get by using hard limits. I think the more
important use case is where the provider wants to limit the amount of
time a user gets (such as in a cloud).

Maybe we should direct our attention in solving that problem? :)

thanks,
-- 
regards,
Dhaval
