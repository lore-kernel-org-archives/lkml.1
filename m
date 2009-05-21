Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZEUQhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZEUQhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZEUQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:37:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50093 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbZEUQhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:37:42 -0400
Date: Thu, 21 May 2009 09:37:37 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Message-ID: <20090521163737.GA7891@us.ibm.com>
References: <49ED22EC.2040204@kernel.org> <200905081640.12677.bjorn.helgaas@hp.com> <20090520164910.6939b92b@jbarnes-g45> <200905210846.18292.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905210846.18292.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 08:46:17AM -0600, Bjorn Helgaas wrote:
> On Wednesday 20 May 2009 5:49:10 pm Jesse Barnes wrote:
> > On Fri, 8 May 2009 16:40:10 -0600
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > Did anything happen with this?
> > > 
> > > The longer we wait to make "use_crs" the default, the harder it
> > > will be, so I'd like to push ahead.
> > 
> > Here's a patch to make CRS the default.  If it looks ok I can push it
> > into my linux-next branch.  I'm all for using reliable data from the
> > BIOS.  I guess we'll find out fairly quickly if this stuff isn't...
> 
> Thanks for following up on this, Jesse.  It was on my to-do list for
> yesterday, but I didn't get to it.
> 
> Yinghai mentioned a specific box where we might have trouble, but we
> never got enough details to really debug it.  So I think we might as
> well give it a shot and fine-tune it as we need to.

I just remembered that Andrew Morton once raised some concerns
related to the number of _CRS returned resources exceeding the
fixed resource array size -> http://lkml.org/lkml/2007/11/1/49

I believe PCI_BUS_NUM_RESOURCES was later increased but if 
that increase was insufficient to cover all systems that the
code will now be exposed to, it seems like the "And should we
really be silently ignoring this problem?  Should we at least
report it?" comment that was not addressed could become relevent.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

