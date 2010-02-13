Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0BMB1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:27:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49626 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0BMB1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:27:21 -0500
Date: Fri, 12 Feb 2010 17:27:11 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-pm@lists.linux-foundation.org,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME
	wake-up (rev. 7)
Message-ID: <20100213012711.GA18009@us.ibm.com>
References: <201001101431.38630.rjw@sisk.pl> <20100212015508.GD10298@us.ibm.com> <201002121219.36350.rjw@sisk.pl> <201002130120.29385.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002130120.29385.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 01:20:29AM +0100, Rafael J. Wysocki wrote:
> On Friday 12 February 2010, Rafael J. Wysocki wrote:
> > On Friday 12 February 2010, Gary Hade wrote:
> ... 
> > > There seems to be a problem.
> > > 
> > > The first time I booted I was able to successfully hot-remove
> > > a PCIe card and then successfully hot-add it to a different slot.
> > > When I tried to hot-remove a PCI-X card that was also present
> > > during boot I saw that lingering blinking amber LED issue.
> > > 
> > > After rebooting I tried the same thing but this time I did
> > > not see the lingering blinking amber LED after removing the
> > > PCI-X card but I did see it when removing the PCIe card.
> > > I then tried to hot-add the PCIe card to a different slot
> > > and noticed the below messages.
> > > 
> > > I don't think I will be able to try to characterize this
> > > better or test any more patches until Monday.  
> > 
> > OK, thanks for testing.
> > 
> > It seems we have a deadlock on pci_acpi_notify_mtx, but I'm yet to understand
> > the exact mechanism of it.
> 
> In fact there are two problems in there.  First, the bridge event notification
> calls handle_bridge_insertion() which attempts to install a PM notifier for
> the bridge and that deadlocks, because it tries to acquire the mutex
> recursively.  Second, apparently, init_bridge_misc() may be called in the
> notification code path and it attempts to unregister the notifier and register
> it again, which can't be done with pci_acpi_notify_mtx held.
> 
> I guess there are similar problems on the hot remove notification path.
> 
> Anyway, I have a new version of the patch and I'm going to test it a bit
> over the weekend.  Unfortunately, I don't have hardware with PCI hotplug
> capability, so I'll send you the new patch for testing on Monday, if you don't
> mind.

I don't mind.  Although I am concerned that my acpiphp only
testing on our IBM System x boxes may not be sufficient to
assure that PCI hotplug will work well on other PCI hotplug
capable systems.  I hope that others will also do some early
testing of this code.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

