Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZCDRmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZCDRmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZCDRlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:41:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56792 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbZCDRls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:41:48 -0500
Date: Wed, 4 Mar 2009 18:41:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Eric Paris <eparis@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: lockdep warning with 2.6.29-rc6-mm1 (mmotm 24-feb-2009)
Message-ID: <20090304174115.GE25962@elte.hu>
References: <20090304125709.GA6251@balbir.in.ibm.com> <1236173267.5330.7487.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236173267.5330.7487.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-03-04 at 18:27 +0530, Balbir Singh wrote:
> > I see the following on my machine. My understanding is that the
> > lockdep warning is complaining about a potential deadlock while
> > reclaiming, where we could end up waiting on holding inotify_mutex,
> > and we could end up calling reclaim with inotify_mutex held.
> > 
> > The race seems rare, since one path shows a new inode being created
> > and the other one being deleted. It seems like a false positive unless
> > the inode's in question turn out to be potentially the same.
> 
> Its not a false positive until you can guarantee the inodes will _never_
> be the same.
> 
> This thing has been reported numerous times, Ingo even posted 
> a potential fix for it, Nick poked the inotify people to speak 
> up, but they have so far been silent on the issue :-(

that particular fix is upstream, via:

  3023a3e: inotify: fix GFP_KERNEL related deadlock

so does this reproduce with latest .29-rc7-ish kernels too - or 
do we have some other problem in this area too?

	Ingo
