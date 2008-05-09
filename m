Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYEIGo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYEIGo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYEIGoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:44:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbYEIGoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:44:20 -0400
Date: Fri, 9 May 2008 08:44:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression fixed by using pci=rom
Message-ID: <20080509064402.GA15754@elte.hu>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com> <200805081717.54102.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 8 May 2008, Jesse Barnes wrote:
> > 
> > Hm, yeah in many cases we definitely *do* want to try to get the 
> > expansion ROM space allocated.  But maybe it should be a lower 
> > priority than other BARs...  Gary?
> 
> The thing is, a lot of these things have been done this way because 
> not doing them that way breaks.
> 
> We want to allocate expansion ROM space - even if we don't enable it - 
> because not doing so will screw up bus sizing etc, and can make it 
> impossible to allocate later.
> 
> In general, changing PCI allocation strategy is really _really_ 
> dangerous, even when it is "right", because it tends to expose a lot 
> of issues where something worked just because it was perhaps 
> indirectly causing a layout that worked.

i tend to believe that the best strategy would be to generally do what 
other OSs do for PCI BAR sizing and PCI resource setup [on desktop 
systems that would be Windows in particular] - and i believe there are 
still a number of gratuitous-looking differences in our code that seem 
unnecessary. Especially on the myriads of desktop systems Windows is 
what gets tested primarily, and by deviating from that legacy layout we 
just set up ourselves for unnecessary failures.

To Linux the primary interest is in devices not failing due to 
unexpected layout and them not overlapping any magic areas - good 
resource compression is something that larger systems can opt-in into 
anyway if it's really needed. In that sense this commit that came 
through us failed that strict benchmark :-/

> So the reason I immediately reverted this is that it was simply 
> totally wrong. If somebody cares about multi-node systems, the onus of 
> making those work should be on *that*, not on old systems that already 
> work.
> 
> Ingo, Thomas: I would _seriously_ suggest that you don't consider the 
> x86 PCI setup code to be "x86" code. Because it isn't. Not in that 
> sense. Just don't take patches to it.

yeah, we stopped doing that in this window (the commits you got form us 
in this window were all leftovers and acked by Jesse) - and we've 
already bounced over all PCI-looking patches to Jesse and asked Jesse 
about all PCI affecting pulls as well in this window. Even this window's 
leftovers we made separate topics and sent separate pull requests for 
them (all tested and acked by Jesse) because it's not really arch/x86 
and PCI commits just need to be considered separately from all other 
changes.

	Ingo
