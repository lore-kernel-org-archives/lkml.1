Return-Path: <linux-kernel-owner+w=401wt.eu-S1750970AbYCKXjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970AbYCKXjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYCKXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:39:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:18469 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYCKXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,482,1199692800"; 
   d="scan'208";a="217499167"
Date: Tue, 11 Mar 2008 16:34:11 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080311163411.7ddd9267@appleyard>
In-Reply-To: <47D684D0.6060200@jp.fujitsu.com>
References: <20080229002341.GA21420@ldl.fc.hp.com>
	<20080301144307.GD24386@parisc-linux.org>
	<20080304054927.GA15566@suse.de>
	<200803041018.29035.jbarnes@virtuousgeek.org>
	<20080304193036.GB5534@suse.de>
	<20080304230937.GD3694@ldl.fc.hp.com>
	<47CDF339.3060304@jp.fujitsu.com>
	<20080305202052.GN3694@ldl.fc.hp.com>
	<47D684D0.6060200@jp.fujitsu.com>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 22:10:40 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> Hi Alex-san,
>
> I tried your patches, and I have two comments. I want 1) to be fixed
> before merge to Greg's tree (or linux-next?), at least.

yes, we will not merge these patches without your ack.

> 
>  1) I checked ACPI spec again and again, but I could not find any
>     reason to add Fujitsu servers to quirks list. So I'd like you to
>     add HP servers to the quirks list. I'll send the following patches
>     followed by this e-mail.

I have followed up with a question on this on another thread, so I'll
skip to #2...
<snip>

> 
>  2) The ACPI PCI slot detection driver would change the slot names of
>     some hotplug drivers (at least I checked shpchp and pciehp). And
>     the name of slots are depending on the order of driver loading.
>     For example, on my system which has several SHPCHP slots and
>     PCIEHP slots, the name of PCIEHP slots are changed as
>     follows. Please note that PCIEHP based slots are 0034_0027 and
>     0032_0026, and others are SHPCHP based slots.
> 
>     - Without ACPI PCI slot detection driver
>       # ls /sys/bus/pci/slots/
>       0009_0016  0014_0018  0019_0020  0021_0022  0034_0027
>       0011_0017  0016_0019  0021_0021  0032_0026
> 
>     - With ACPI PCI slot detection driver
>       # ls /sys/bus/pci/slots/
>       0009_0016  0014_0018  0019_0020  0021_0022  27
>       0011_0017  0016_0019  0021_0021  26
> 
>     I had thought it is not a big problem before because people who
>     don't like new names would not load the PCI slot driver. But since
>     it is loaded automatically at boot time, I'm wondering that it
>     would be a problem. For example, some platform, not fujitsu,
>     depends on the old slot name to work, IIRC (Maybe Kristen knows
>     the background about it). And I don't think the fact that slot
>     names are changed depending on the order of driver loading is
>     acceptable by system management people/software, though I don't
>     have such software.
> 
>     Though I don't have any specific idea about this, folliwings might
>     be candidates.
> 
>     - Override slot names with hotplug driver's slot names

I think this should be done - if the pci slot driver detects that a
hotplug driver is controlling a slot, it should allow that driver to
set the name of the slot.

>     - Unify slot names among all hotplug drivers

I'm not sure if we can do this, since slot name might depend on what
spec people are implementing.

>     - Stop automatic loading of ACPI PCI slot driver

I think we should definitely implement this one ^^^.

