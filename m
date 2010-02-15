Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0BOVmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:42:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab0BOVmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:42:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Mon, 15 Feb 2010 22:42:48 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <201001101431.38630.rjw@sisk.pl> <201002141451.17888.rjw@sisk.pl> <20100215192252.GA11074@us.ibm.com>
In-Reply-To: <20100215192252.GA11074@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002152242.48303.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010, Gary Hade wrote:
> On Sun, Feb 14, 2010 at 02:51:17PM +0100, Rafael J. Wysocki wrote:
> > On Saturday 13 February 2010, Gary Hade wrote:
> > > On Sat, Feb 13, 2010 at 01:20:29AM +0100, Rafael J. Wysocki wrote:
> > > > On Friday 12 February 2010, Rafael J. Wysocki wrote:
> > > > > On Friday 12 February 2010, Gary Hade wrote:
> > ...
> > > > In fact there are two problems in there.  First, the bridge event notification
> > > > calls handle_bridge_insertion() which attempts to install a PM notifier for
> > > > the bridge and that deadlocks, because it tries to acquire the mutex
> > > > recursively.  Second, apparently, init_bridge_misc() may be called in the
> > > > notification code path and it attempts to unregister the notifier and register
> > > > it again, which can't be done with pci_acpi_notify_mtx held.
> > > > 
> > > > I guess there are similar problems on the hot remove notification path.
> > > > 
> > > > Anyway, I have a new version of the patch and I'm going to test it a bit
> > > > over the weekend.  Unfortunately, I don't have hardware with PCI hotplug
> > > > capability, so I'll send you the new patch for testing on Monday, if you don't
> > > > mind.
> > > 
> > > I don't mind.
> > 
> > Thanks!
> > 
> > > Although I am concerned that my acpiphp only
> > > testing on our IBM System x boxes may not be sufficient to
> > > assure that PCI hotplug will work well on other PCI hotplug
> > > capable systems.  I hope that others will also do some early
> > > testing of this code.
> > 
> > The code that you've been testing is not very hardware-dependent.  It only
> > matters whether or not the hardware is capable of PCI hotplugging
> > (ACPI-based), so your testing should be sufficient.
> 
> Perhaps the tester-dependent aspect should also be considered. :)
> 
> > 
> > In fact I have two patches to test.  The first one is an ACPI CA patch that
> > allows us to use more than one system notify handler per device (below).
> > Please test it on top of [1-3/9] with the replacement for [4-6/9] I sent
> > you earlier (http://patchwork.kernel.org/patch/78814/) and (updated) [7/9].
> 
> This seemed to work OK.  I did not see any of the previously
> reported issues during hot-remove and hot-add.
> 
> > 
> > If this works, please apply the patch from
> > http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=patch;h=d42c8b334bafe3a15f2dd43e395dafefe58dc588
> > on top of the appended one and see if things still work correctly.
> 
> Results still looked good after adding this patch.

Thanks a lot for testing, it looks like the issues have been resolved, then.

Rafael
