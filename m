Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZFOGwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZFOGwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbZFOGwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:52:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:52601 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681AbZFOGwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:52:33 -0400
Date: Mon, 15 Jun 2009 08:52:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when feature is disabled
Message-ID: <20090615065232.GC18390@wotan.suse.de>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu> <20090612125741.GA6140@localhost> <20090612131754.GA32105@elte.hu> <alpine.LFD.2.01.0906120827020.3237@localhost.localdomain> <20090612153501.GA5737@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612153501.GA5737@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 05:35:01PM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, 12 Jun 2009, Ingo Molnar wrote:
> > > 
> > > This seems like trying to handle a failure mode that cannot be 
> > > and shouldnt be 'handled' really. If there's an 'already 
> > > corrupted' page then the box should go down hard and fast, and 
> > > we should not risk _even more user data corruption_ by trying to 
> > > 'continue' in the hope of having hit some 'harmless' user 
> > > process that can be killed ...
> > 
> > No, the box should _not_ go down hard-and-fast. That's the last 
> > thing we should *ever* do.
> > 
> > We need to log it. Often at a user level (ie we want to make sure 
> > it actually hits syslog, possibly goes out the network, maybe pops 
> > up a window, whatever).
> > 
> > Shutting down the machine is the last thing we ever want to do.
> > 
> > The whole "let's panic" mentality is a disease.
> 
> No doubt about that - and i'm removing BUG_ON()s and panic()s 
> wherever i can and havent added a single new one myself in the past 
> 5 years or so, its a disease.

In HA failover systems you often do want to panic ASAP (after logging
to serial cosole I guess) if anything like this happens so the system
can be rebooted with minimal chance of data corruption spreading.
 
