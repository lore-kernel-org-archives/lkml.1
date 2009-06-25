Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZFYH3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZFYH3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZFYH3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:29:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:37440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZFYH3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:29:01 -0400
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one
 root bus
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090625070347.GB2676@elte.hu>
References: <20090624122433.GA24781@elte.hu>
	 <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org>
	 <4A42AFAC.6000300@kernel.org>
	 <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
	 <alpine.LFD.2.01.0906241615160.18460@localhost.localdomain>
	 <20090624163705.0389c8f0@jbarnes-g45>
	 <alpine.LFD.2.01.0906241645300.3605@localhost.localdomain>
	 <20090624170114.385322df@jbarnes-g45>  <20090625070347.GB2676@elte.hu>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 12:58:26 +0530
Message-Id: <1245914906.3116.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 09:03 +0200, Ingo Molnar wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > > [ There's a difference between "we're supposed to find and fix bugs
> > > in the -rc series", and "I release known-buggy -rc1's since we're
> > > supposed to fix it later". For similar reasons, I hate pulling
> > > known-buggy stuff during the merge window - it's ok if it shows
> > > itself to be buggy _later_, but if people send me stuff that they
> > > know is buggy as they send it to me, then that's a problem. ]
> > 
> > Yeah, 100% agreed.  I didn't hear any reports until after people 
> > started using your tree, so I think this case was handled 
> > correctly: push something that *seems* ok upstream, but with eyes 
> > wide open for the possibility we'd need to revert.
> 
> There's only one small gripe i have with the handling of it: the 
> timing. "9e9f46c: PCI: use ACPI _CRS data by default" was written 
> and committed on June 11th, two days _after_ the merge window 
> opened.
> 
> That's way too late for maybe-broken changes to x86 lowlevel details 
> (especially if it touches hw-environmental interaction - which is 
> very hard to test with meaningful coverage), and it's also pretty 
> much the worst moment to solicit testing from people who are busy 
> getting their stuff to Linus and who are busy testing out any of the 
> unexpected interactions and bugs.
> 
> So this was, to a certain degree, a predictable outcome. Trees in 
> the Linux "critical path" of testing (core kernel, x86, core 
> networking, very common drivers, PCI, driver core, VFS, etc.) should 
> generally try to cool down 1-2 weeks before the merge window - 
> because breakage there can do a lot of knock-on cascading damage. 
> Two weeks is not a lot of time and the effects of showstopper bugs 
> get magnified disproportionately.
> 

Yes, I was also thinking about this when I checked the commit date. And
totally agree with Ingo's suggestions.

Thanks,
--
JSR

