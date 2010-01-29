Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520Ab0A2Cpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0A2Cpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227Ab0A2Cpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:45:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:62681 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab0A2Cpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:45:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,363,1262592000"; 
   d="scan'208";a="535621474"
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garrett <jeff@jgarrett.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <201001282128.33389.rjw@sisk.pl>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <4B61D554.9000003@kernel.org>
	 <20100128110331.61455a15@jbarnes-piketon>  <201001282128.33389.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 10:44:03 +0800
Message-ID: <1264733043.9599.48.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 04:28 +0800, Rafael J. Wysocki wrote:
> On Thursday 28 January 2010, Jesse Barnes wrote:
> > On Thu, 28 Jan 2010 10:20:04 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > On 01/28/2010 08:09 AM, Bjorn Helgaas wrote:
> > > > On Wednesday 27 January 2010 10:53:51 pm Yinghai Lu wrote:
> > > >> On 01/27/2010 08:26 PM, Bjorn Helgaas wrote:
> > > >>> On Wed, 2010-01-27 at 15:34 -0800, Yinghai Lu wrote:
> > > > 
> > > >>>> 2. how about when apci is disabled?
> > > >>>
> > > >>> When ACPI is disabled, I think we just have to accept that we
> > > >>> lose some functionality.  I don't see the need for alternate ways
> > > >>> to accomplish everything that ACPI does.  It's becoming less and
> > > >>> less useful to disable ACPI; I think it's only interesting as a
> > > >>> debugging tool, and even then it's a sledgehammer.
> > > >>
> > > >> some systems when acpi is enabled could have interrupt storm. 
> > > >> and have to disable acpi.
> > > > 
> > > > We should fix that problem rather than just covering it up by
> > > > disabling ACPI.  Can you provide any details?
> > > that is not covering problem. acpi just cause too many problems.
> > > 
> > > systems using acpi hotplug support, and use acpi aml code to monitor
> > > the hotplug status instead of HW and after one or two days will have
> > > interrupt storm with sci/acpi interrupt aka 9.
> > 
> > 
> > But disabling it gets us into trouble too.  When platforms are designed
> > for Linux, they may be designed to have ACPI disabled (though this is
> > probably rare for general purpose PCs and servers).
> 
> Well, not quite.  On recent SMP systems it's next to impossible to get all of
> the necessary system configuration information without ACPI, since it only is
> provided by the ACPI tables (the configuration of APICs, interrupt routing,
> CPU C states, other stuff).
> 
> [BTW, I think it's better to CC linux-acpi and Len at this point.]
> 
IMO, Disabling ACPI is wrong.
"acpi=off" should just be used for debug purpose. For example, it is a
good excuse to dedicate an uncleared bug to ACPI if the problem doesn't
exist with acpi=off, although they may be not ACPI related sometime.

So if there are some platforms that
1. work in Windows.
2. don't work in Linux when ACPI is on.
3. work in Linux when ACPI is off.
please file a bug at
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

thanks,
rui

> > However when they're designed for Windows, they're generally designed to use
> > ACPI, so if we disable it we run the risk of hitting all sorts of bugs since
> > we're running in an untested configuration.
> 
> I guess without ACPI we're guaranteed to run into troubles on many modern
> hardware configurations.
> 
> > So fixing the issues with ACPI enabled seems like a better idea; after
> > all, presumably Windows works on this platform with ACPI enabled, why
> > shouldn't we?
> > 
> > But I'm speaking in general here; we'd have to dig into the details of
> > the particular problem you mention to figure out the best course of
> > action (but I'm still pretty sure it's not "disable ACPI").
> 
> Agreed.
> 
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


