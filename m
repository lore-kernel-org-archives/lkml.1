Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYCKN23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYCKN23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYCKN2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:28:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57221 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYCKN2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:28:20 -0400
Date: Tue, 11 Mar 2008 07:28:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Gary Hade <garyhade@us.ibm.com>, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080311132800.GC21482@parisc-linux.org>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D684D0.6060200@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 10:10:40PM +0900, Kenji Kaneshige wrote:
> 1) I checked ACPI spec again and again, but I could not find any
>    reason to add Fujitsu servers to quirks list. So I'd like you to
>    add HP servers to the quirks list. I'll send the following patches
>    followed by this e-mail.

Alex pointed out that IBM interprets the spec the same way that HP does.
Are there any other machines that follow the spec the same way that
Fujitsu does?

> 2) The ACPI PCI slot detection driver would change the slot names of
>    some hotplug drivers (at least I checked shpchp and pciehp). And
>    the name of slots are depending on the order of driver loading.
>    For example, on my system which has several SHPCHP slots and
>    PCIEHP slots, the name of PCIEHP slots are changed as
>    follows. Please note that PCIEHP based slots are 0034_0027 and
>    0032_0026, and others are SHPCHP based slots.
> 
>    - Without ACPI PCI slot detection driver
>      # ls /sys/bus/pci/slots/
>      0009_0016  0014_0018  0019_0020  0021_0022  0034_0027
>      0011_0017  0016_0019  0021_0021  0032_0026
> 
>    - With ACPI PCI slot detection driver
>      # ls /sys/bus/pci/slots/
>      0009_0016  0014_0018  0019_0020  0021_0022  27
>      0011_0017  0016_0019  0021_0021  26

I hadn't realised that patch got in to put the bus name in as a
uniquifier.  I thought we'd rejected it because the problem only
occurred on one box with bad firmware.

>    - Unify slot names among all hotplug drivers

That is the plan.  I'm not sure why the shpc slots aren't renamed in
this revision of the patch -- maybe Alex dropped that part?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
