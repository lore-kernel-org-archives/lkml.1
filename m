Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZBPIBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZBPIBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZBPIBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:01:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57940 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZBPIBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:01:13 -0500
Message-ID: <49991D3A.7090001@jp.fujitsu.com>
Date: Mon, 16 Feb 2009 17:00:58 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
References: <m1pri623g9.fsf@fess.ebiederm.org>	<49815BF6.7060402@jp.fujitsu.com>	<200902131129.09523.jbarnes@virtuousgeek.org> <m11vu1wtk6.fsf@fess.ebiederm.org>
In-Reply-To: <m11vu1wtk6.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> 
>> Any update here, Eric?  Sounds like you're using hotplug in real environments 
>> with complex topologies (based on your earlier messages), so we're interested 
>> in what you're seeing here...
> 
> Yes.
> 
> Currently I have a test system that is a subset of what I'm worried
> about and will shortly have the real hardware, so my immediate goal is
> to get things working well enough so my internal users won't get
> blocked by bugs.  Currently I only have the pcie hotplug and pcie
> hotplug surprise case.  My basic topology is 16 hotplug slots into
> which I will be plugging in pci express switches with a couple of
> additional hotplug slots.  As for the firmware, I will have it reserving
> bus numbers and mmio space on each of the first 16 slots and the rest
> is going to be up to the linux kernel.  This is an embedded design
> so no ACPI is appears more pain than it is worth to implement.
> 

Very interesting. Can I ask you some questions?

- On hot-insertion of pci express switches with a additional hotplug
  slots, who initialize HwInit registers (for example, physical slot
  number field in the Slot Capabilities register)? OS, firmware,
  hardware or others?

- Bus numbers and MMIO space that needs to be reserved is depending
  on platform design. How do you tell kernel (or hotplug drivers) how
  many resources need to be reserved, in your current design?

> I am also looking at the case of pcie switches with two upstream
> ports, and switching which cpu they are connected to at runtime.  So
> in some cases I will have devices whose presence is detected but will
> not get link for hours or days, as opposed to the 20ms time limit in
> the pci express specification.  Call it a necessary extension.
> 
> I need to revisit the pciehp driver but my first pass through it
> looked like every corner case appeared to get something wrong. So I
> have written myself a little 430 line replaces that handles the case
> that I currently care about.  Part of what I was seeing before is that
> we don't clear pending events in the pciehp driver before we enable
> interrupts.  So if booting the system has left some pending and you
> have CONFIG_DEBUG_SHIRQ enabled you get a nice oops because p_slot has
> not been initialized and so the interrupts can't be handled.
> 

I've made a fix (c4635eb06af700820d658a163f06aff12e17cfb2) for a similar
problem several months ago. With this fix, pciehp had been changed to
initialize p_slot before installing interrupt service routine. So I still
don't understand what is happening. Could you please tell me the details
about "p_slot has not been initialized..."?

Thanks,
Kenji Kaneshige


