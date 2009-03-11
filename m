Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZCKRbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZCKRbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZCKRbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:31:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbZCKRbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:31:22 -0400
Date: Wed, 11 Mar 2009 18:30:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090311173044.GA9720@elte.hu>
References: <20090311121007.GC13835@in.ibm.com> <Pine.LNX.4.44L0.0903111232300.2692-100000@iolanthe.rowland.org> <20090311172506.GC9547@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311172506.GC9547@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> On Wed, Mar 11, 2009 at 12:34:43PM -0400, Alan Stern wrote:
> > On Wed, 11 Mar 2009, K.Prasad wrote:
> > 
> > > The hardware breakpoint interfaces haven't been put under any CONFIG_
> > > till now, but I think we should bring them under a new config, say
> > > CONFIG_HW_BREAKPOINT. It would help create a dependancy for
> > > CONFIG_KSYM_TRACER too.
> > 
> > With these patches, ptrace is dependent on hw-breakpoint.  
> > You can't disable CONFIG_HW_BREAKPOINT without breaking 
> > ptrace.
> > 
> > Alan Stern
> > 
> 
> Agreed. We might have to retain the old code for ptrace and 
> put the new implementation under #ifdef CONFIG_HW_BREAKPOINT 
> to get them working. What do you think?

With the simple reservation mechanism i suggested i have no 
problem with having HW_BREAKPOINT enabled [selected] 
unconditionally on x86.

Your ptrace changes are an improvement in terms of code quality 
so as long as the facility is simple and obvious, it's a step 
forward.

#ifdefs are ugly and hard to maintain - especially in such a
rarely used and still critical API as ptrace.

	Ingo
