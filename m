Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYIVT33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYIVT33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYIVT3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:29:21 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:38571 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751598AbYIVT3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:29:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rUnRzD99awKMHhItHrjMILwjQR6jP5jlI/wuSuJLNijsiNAxklL6ipvxJ1wICqE5PP0rh0fiNPc3um8l8GPULFjyMCiAkNtaqeYWFlz1JP+d98LmmVlgVagmZ+kR+6LG;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Notes from LPC PCI/MSI BoF session
Date: Mon, 22 Sep 2008 12:29:18 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221229.18501.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew was kind enough to set up a BoF for those of us interested in PCI and 
MSI issues at this year's LPC.  We went over several issues there:  MSI, PCI 
hotplug, PCIe virtualization, VGA arbitration and PCI address space 
management.

MSI
---
This was probably the biggest topic; we spent almost an hour on the topic as I 
recall.  The main takeaways were these:

Issue:
Need to add something like James' lost interrupt code so we can better     
detect platforms with buggy MSI support (along with more general     
interrupt routing issues).
Owner:
Me.  I'll be handling this by integrating James' patches into the PCI tree for     
2.6.28.

Issue:
Storage drivers need to use the functionality provided above and print an oops 
message or similar so we can pick it up and blacklist the platform.
Owner:
Matthew (I think?)

Issue:
smp_affinity and MSI are currently incompatible if MSI masking and INTX 
mapping are unavailable.  Need to return -EINVAL from smp_affinity changes in 
this case.
Owner:
Me (happy to receive patches for this though).

Issue:
MSI API improvements.  Need ways to allocate MSIs at runtime, and perhaps on a 
per-CPU level and get affinity information.  And of course we need a way to 
get more than one legacy MSI allocated.
Owner:
Matthew is handling the first pass of this (the more than one legacy MSI 
addition).  I think we'll need some detailed requirements from the driver 
guys to make further improvements (e.g. per-CPU or affinity stuff).

Issue:
Need better MSI platform blacklists.
Owner:
Me.  I'll see if I can gather the list of issues the Fedora guys saw last time 
they tried to enable MSI unconditionally.  We can also improve the list 
through the added debugging described above.

PCI hotplug
-----------
PCI hotplug has seen a lot of churn lately, mainly due to long overdue fixes 
from Alex & Kenji-san.  Now that Kristen is done with LPC related planning 
and implementation, she says she'll have time to review more patches, but she 
also said PCI hotplug doesn't need a dedicated maintainer.  Assuming there 
are no objections, I'll apply a patch to remove the associated entry from 
MAINTAINERS for 2.6.28.

I'm really happy with the level of review we've been getting on hotplug 
related patches these days, I hope we can keep it up.  One of the main 
remaining issues that I can see is adding some better detection code for our 
hotplug slot drivers.  It seems like we're missing something given that we 
see so many systems with duplicate slot IDs; maybe we're not calling the 
right ACPI methods or are calling them wrong somehow?

PCIe virtualization
-------------------
Briefly discussed the SR-IOV patches Yu has been posting recently.  Except for 
a couple of changes requested by Alex & Matthew, it looks like this patch set 
is in pretty good shape.  I'll wait for Matthew & Alex to ack the next set, 
then I'll apply to my linux-next branch.

VGA arbitration
---------------
There's some code for handling legacy VGA routing floating around.  Ben put it 
together awhile back, and Tiago Vignatti has been looking after it lately.  
It's a good interface to have for multi-seat configurations that require 
multiple VGA cards to be POSTed; it mainly needs to be re-posted to the 
mailing list for final review at this point (and Ben mentioned one more API 
is needed to allow drivers to exclude themselves from arbitration once they 
no longer need legacy VGA space).

PCI address space management
----------------------------
TJ has a bunch of code to improve address space management in Linux.  We 
talked for a few minutes about this at the BoF; at this point I'm just 
waiting for TJ to post his stuff so we can start integrating it.  Hopefully 
we can start merging small pieces of it (like the multiple PCI gap stuff) for 
2.6.28, and get some more eyes on the more aggressive PCI-DMAR stuff he's 
been talking about soon.

Well that's all I have in the way of notes.  Feel free to add your own if I 
missed anything or correct me if I mischaracterized things.

Thanks,
Jesse
    
