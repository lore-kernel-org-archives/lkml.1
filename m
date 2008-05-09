Return-Path: <linux-kernel-owner+w=401wt.eu-S1763912AbYEIQqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763912AbYEIQqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYEIQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:45:57 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33772 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbYEIQpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:45:55 -0400
Date: Fri, 9 May 2008 09:45:51 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression fixed by using pci=rom
Message-ID: <20080509164551.GB6255@us.ibm.com>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com> <200805081717.54102.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org> <20080509064402.GA15754@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509064402.GA15754@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 08:44:03AM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 8 May 2008, Jesse Barnes wrote:
> > > 
> > > Hm, yeah in many cases we definitely *do* want to try to get the 
> > > expansion ROM space allocated.  But maybe it should be a lower 
> > > priority than other BARs...  Gary?
> > 
> > The thing is, a lot of these things have been done this way because 
> > not doing them that way breaks.
> > 
> > We want to allocate expansion ROM space - even if we don't enable it - 
> > because not doing so will screw up bus sizing etc, and can make it 
> > impossible to allocate later.
> > 
> > In general, changing PCI allocation strategy is really _really_ 
> > dangerous, even when it is "right", because it tends to expose a lot 
> > of issues where something worked just because it was perhaps 
> > indirectly causing a layout that worked.
> 
> i tend to believe that the best strategy would be to generally do what 
> other OSs do for PCI BAR sizing and PCI resource setup [on desktop 
> systems that would be Windows in particular] - and i believe there are 
> still a number of gratuitous-looking differences in our code that seem 
> unnecessary. Especially on the myriads of desktop systems Windows is 
> what gets tested primarily, and by deviating from that legacy layout we 
> just set up ourselves for unnecessary failures.

Ingo, Would you (or others listening to this discussion) know
exactly what Windows does with respect to BIOS unassigned
expansion ROMs?  Does Windows attempt to obtain space for the
expansion ROMs at boot-time or does it perhaps have some sort
of strategy where space is allocated on an "as needed" basis
at run-time?

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
