Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXEKGLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXEKGLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbXEKGLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:11:38 -0400
Received: from ns.suse.de ([195.135.220.2]:33128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbXEKGLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:11:37 -0400
Date: Fri, 11 May 2007 09:08:53 +0200
From: Andi Kleen <ak@suse.de>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: getcpu after sched_setaffinity
Message-ID: <20070511070853.GD2012@bingen.suse.de>
References: <46439BBA.2070705@redhat.com> <20070510234446.GC2012@bingen.suse.de> <4643A616.3090202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4643A616.3090202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 04:09:10PM -0700, Ulrich Drepper wrote:
> >is only designed for the case where you don't set the affinity explicitely;
> >otherwise you should already know where you are and don't need it.
> 
> That's not true in general.  Yes, because I want to test vgetcpu() I 
> restrict the set to just one CPU.
> 
> But if I have more than 2 "CPUs" and I set the affinity to two CPUs 
> which currently are not used you cannot make this argument.

All the users I talked to never mentioned this as a use case.
They were only interested in fully unrestricted programs. 

Anyways you can handle it too, just invalidate or do getcpu with 
a new cache afterwards.

Or just wait the jiffie for the cache to expire.

> 
> getcpu should always work correctly not only if you cannot determine it 
> in another way.

getcpu by design is approximate. If you don't understand this
don't bother using it.

-Andi

