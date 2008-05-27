Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbYE0WyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbYE0WyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbYE0WyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:54:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:2910 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711AbYE0WyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,550,1204531200"; 
   d="scan'208";a="285503819"
Date: Tue, 27 May 2008 15:45:07 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, drzeus-list@drzeus.cx
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
Message-ID: <20080527154507.76c61d40@appleyard>
In-Reply-To: <200805260920.15912.jbarnes@virtuousgeek.org>
References: <20080524165828.GA29993@elte.hu>
	<20080526015232.5faac5bb.akpm@linux-foundation.org>
	<483A9050.5000206@jp.fujitsu.com>
	<200805260920.15912.jbarnes@virtuousgeek.org>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 09:20:15 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Monday, May 26, 2008 3:26 am Kenji Kaneshige wrote:
> > Andrew Morton wrote:
> > > On Mon, 26 May 2008 10:47:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > >> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> > >>> I updated Ingo's patch. If it's ok, I'll send it to Jess Barnes with
> > >>> some other patches for the other pciehp regression problems.
> > >>
> > >> looks good to me, thanks Kenji.
> > >
> > > It's a bit sad to add a large workaround like this.  I'm surprised
> > > that fixing it properly is considered unviable for 2.6.26.  Normally
> > > these fixes are pretty simple - just request the IRQ a bit later?
> >
> > Although I have not considered how to implement proper fix deeply,
> > I don't think it's so simple. For example, current pciehp is doing
> > like this:
> >
> > (1) some initialization
> > (2) request_irq()
> > (3) issue command
> > (4) initialize slot data structure
> >
> > Maybe we want to do (2) after (4) to fix the problem. But if we
> > simply move (2) after (4), we cannot detect the command completion
> > event at (3) and it will cause command timeout.
> >
> > It's just an example, and there might be other things like this.
> > This example might be fixed simply, but all my worry is that fixing
> > this quickly might cause another regressions. This is why I think
> > Ingo's approach is better in a short term.
> >
> > And another reason is I'm very nervous because I already caused
> > many problems in pciehp since 2.6.26-rcX... :(
> 
> But you also fixed the problems, which is even more important! :)  I'm ok with 
> the workaround for 2.6.26 as long as we can get a more proper fix into 
> 2.6.27.
> 
> Any thoughts, Kristen?
> 
> Thanks,
> Jesse
> 

I'm in favor of the workaround for now.
