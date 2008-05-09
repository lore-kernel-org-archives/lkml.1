Return-Path: <linux-kernel-owner+w=401wt.eu-S1763047AbYEIQF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763047AbYEIQF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYEIQFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:05:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45129 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbYEIQFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:05:47 -0400
Date: Fri, 9 May 2008 09:05:16 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression fixed by using pci=rom
Message-ID: <20080509160516.GA6255@us.ibm.com>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com> <200805081717.54102.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org> <200805082329.39987.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805082329.39987.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 11:29:39PM -0700, Jesse Barnes wrote:
> On Thursday, May 08, 2008 6:46 pm Linus Torvalds wrote:
> > On Thu, 8 May 2008, Jesse Barnes wrote:
> > > Hm, yeah in many cases we definitely *do* want to try to get the
> > > expansion ROM space allocated.  But maybe it should be a lower priority
> > > than other BARs... Gary?
> >
> > The thing is, a lot of these things have been done this way because not
> > doing them that way breaks.
> >
> > We want to allocate expansion ROM space - even if we don't enable it -
> > because not doing so will screw up bus sizing etc, and can make it
> > impossible to allocate later.
> >
> > In general, changing PCI allocation strategy is really _really_ dangerous,
> > even when it is "right", because it tends to expose a lot of issues where
> > something worked just because it was perhaps indirectly causing a layout
> > that worked.
> 
> Yeah, that was my first impression too, but the patch went upstream awhile ago 
> and I didn't see any background except for the changelog.
> 
> If anything, we should have a pci=norom option instead, so that big systems 
> that don't need the ROMs can use their address space more efficiently.

This is actually the solution I was going to suggest.  I will 
work on it.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
