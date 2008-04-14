Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYDND5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYDND5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 23:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYDND5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 23:57:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49420 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbYDND5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 23:57:20 -0400
Date: Sun, 13 Apr 2008 20:52:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [rfc] hw resource debugging checks
Message-ID: <20080413205215.6073a55b@laptopd505.fenrus.org>
In-Reply-To: <86802c440804131229q7d68091bpa18ac32d379f0ef9@mail.gmail.com>
References: <200804102159.14563.rjw@sisk.pl>
	<20080410203800.GA14560@elte.hu>
	<200804110028.22290.rjw@sisk.pl>
	<200804112126.29455.rjw@sisk.pl>
	<20080413075845.GJ20332@elte.hu>
	<87d4ouw0u9.fsf@basil.nowhere.org>
	<86802c440804131119m1c43497bg1864ce9751438e85@mail.gmail.com>
	<20080413182910.GB8641@one.firstfloor.org>
	<86802c440804131229q7d68091bpa18ac32d379f0ef9@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 12:29:30 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Sun, Apr 13, 2008 at 11:29 AM, Andi Kleen <andi@firstfloor.org>
> wrote:
> > > even I could talk to BIOS
> >  > engineers everyday and tell them how to fix the problem in
> >  > BIOS,  some still can not be fixed because of the legacy BIOS
> >  > framework or big mess.
> >
> >  ... so you opt to create the big mess in the kernel. Great.
> >
> >  And it does not even fixes a real problem, but getting
> >  mmconfig or the numa bus discovery to work is not really a too
> > serious issue anyways. At best it is the icing on the cake to enable
> >  some relatively obscure functionality and be a little more
> >  efficient, but nothing really fundamental.
> >
> >  But for those things just expecting a working modern BIOS is quite
> >  reasonable.
> 
> it does fix real problem. when big system with several HT links, and
> every link some pcie slots.
> you fully load pci-e cards (with pci bridge). BIOS will stop assign
> io/mmio resource to left device if it run out of io port range.
> (though it is supposed to go on to allocate mmio to left devices) (
> modern pcie device only need mmio with drivers)
> 
> With pre set range allocation in NB pci conf, kernel could allocate
> the resource in every peer root bus ranges.
> (the code for assign resource to device that is not assigned resource
> by BIOS --- already in kernel)
> 

there is a really big difference between assigning PCI device resources
and doing a whole thing like MMCFG from scratch.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
