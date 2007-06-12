Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbXFLW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbXFLW2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXFLW2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:28:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:28681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXFLW2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:28:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,413,1175497200"; 
   d="scan'208";a="238428395"
Date: Tue, 12 Jun 2007 15:24:32 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@elte.hu>,
       asit.k.mallick@intel.com
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
Message-ID: <20070612222432.GC17143@linux-os.sc.intel.com>
References: <m1tztt3yqy.fsf@ebiederm.dsl.xmission.com> <200706122252.10886.rjw@sisk.pl> <20070612215659.GB17143@linux-os.sc.intel.com> <200706130016.09490.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706130016.09490.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 12:16:08AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, 12 June 2007 23:56, Siddha, Suresh B wrote:
> > On Tue, Jun 12, 2007 at 10:52:09PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, 12 June 2007 20:19, Eric W. Biederman wrote:
> > > > Because you are calling unfixably broken code.  That should be a decent
> > > > incentive to do something else won't it?
> > > 
> > > Can you please tell me _what_ else can be done?
> > > 
> > > > IOAPICs do not support what the code is doing here.  There is lots of
> > > > practical evidence including bad experiences and practical tests that
> > > > support this.
> > > 
> > > Well, AFAICS, Suresh has tried to debug one failing case recently without
> > > any consistent conclusions.  I don't know of any other test cases (links,
> > > please?).
> > 
> > Rafael, Darrick Wong's issue looks different and hence I was motivated to
> > look and fix if it was a SW issue. For now, I am not able to comprehend
> > what is happening on Darrick Wong's system. Need more help from Darrick
> > as he has the golden failing system.
> > 
> > Meanwhile I talked to our hardware folks about the irq migration in general.
> > 
> > One good news is that future versions of chipsets will have an Interrupt
> > Remapping feature(for more details please refer to
> > http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf)
> > where in we can reliably migrate the irq to someother cpu in the process
> > context.
> > 
> > And for the existing platforms, chipset folks don't see a reason why the
> > Eric's algorithm(specified below) should fail.
> > 
> > Eric's algorithm for level triggered(edge triggered should be easier than
> > level triggered):
> > - Mask the irq in process context.
> > - Poll RIRR until an ack of for the irq was not pending.
> > - Migrate the irq.
> > 
> > Eric had a problem of stuck remote IRR on E75xx chipset with this algorithm
> > and my next step is to reproduce this issue on this platform and understand
> > the behavior.
> 
> OK
> 
> In that case, do I understand correctly that we are going to implement the
> Eric's algorithm above for the CPU hotunplugging on x86 once you've figured
> out what's the E75xx issue?

That is the idea. Thanks.
