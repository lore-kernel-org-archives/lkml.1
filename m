Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZFKSBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZFKSBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbZFKSBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:01:19 -0400
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:41462 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756303AbZFKSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:01:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=U8+bPCEB4HgehdY0O7K8ZleyCEGrBRvD0eEUKHRcucYDD3qI7MMmxfR2mSn0HDsW2t6VSnzjqZZ6XPjFVoMi1ZQOalo1yp+ZMkCf3w3I8zM6C1an5IJeoGwOLZn11uTm;
Date: Thu, 11 Jun 2009 11:00:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       linux-acpi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Message-ID: <20090611110035.209122a4@jbarnes-g45>
In-Reply-To: <20090527194144.GA7933@us.ibm.com>
References: <49ED22EC.2040204@kernel.org>
	<200905081640.12677.bjorn.helgaas@hp.com>
	<20090520164910.6939b92b@jbarnes-g45>
	<200905210846.18292.bjorn.helgaas@hp.com>
	<20090521163737.GA7891@us.ibm.com>
	<20090527194144.GA7933@us.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 12:41:44 -0700
Gary Hade <garyhade@us.ibm.com> wrote:

> On Thu, May 21, 2009 at 09:37:37AM -0700, Gary Hade wrote:
> > On Thu, May 21, 2009 at 08:46:17AM -0600, Bjorn Helgaas wrote:
> > > On Wednesday 20 May 2009 5:49:10 pm Jesse Barnes wrote:
> > > > On Fri, 8 May 2009 16:40:10 -0600
> > > > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > > > Did anything happen with this?
> > > > > 
> > > > > The longer we wait to make "use_crs" the default, the harder
> > > > > it will be, so I'd like to push ahead.
> > > > 
> > > > Here's a patch to make CRS the default.  If it looks ok I can
> > > > push it into my linux-next branch.  I'm all for using reliable
> > > > data from the BIOS.  I guess we'll find out fairly quickly if
> > > > this stuff isn't...
> > > 
> > > Thanks for following up on this, Jesse.  It was on my to-do list
> > > for yesterday, but I didn't get to it.
> > > 
> > > Yinghai mentioned a specific box where we might have trouble, but
> > > we never got enough details to really debug it.  So I think we
> > > might as well give it a shot and fine-tune it as we need to.
> > 
> > I just remembered that Andrew Morton once raised some concerns
> > related to the number of _CRS returned resources exceeding the
> > fixed resource array size -> http://lkml.org/lkml/2007/11/1/49
> > 
> > I believe PCI_BUS_NUM_RESOURCES was later increased but if 
> > that increase was insufficient to cover all systems that the
> > code will now be exposed to, it seems like the "And should we
> > really be silently ignoring this problem?  Should we at least
> > report it?" comment that was not addressed could become relevent.
> 
> Not only do we not warn, if we did warn based on the current
>     'if (info->res_num >= PCI_BUS_NUM_RESOURCES)'
> resource array overrun avoidance criteria it would be incorrect
> for a root bus that is connected to a subordinate bus with a
> transparent bridge.  We need to avoid the last 3 slots of the
> resource array since they do not get mapped to a transparent
> bridge connected subordinate bus.  I believe the below patch
> addresses these issues.
> 
> With PCI_BUS_NUM_RESOURCES currently at 16 we still have space
> to accomodate 13 _CRS returned resource descriptors which will
> hopefully be sufficient.

Ok, applied the patch (with Yinghai's suggested name change) to my
linux-next branch.  We'll see now it goes and revert it if there's
trouble.


-- 
Jesse Barnes, Intel Open Source Technology Center
