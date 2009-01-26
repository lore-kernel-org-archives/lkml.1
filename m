Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZAZCL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZAZCL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZAZCLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:11:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48973 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZAZCLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:11:49 -0500
Message-ID: <497D1BD7.9000609@jp.fujitsu.com>
Date: Mon, 26 Jan 2009 11:11:35 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, shaohua.li@intel.com
Subject: Re: ACPI hotplug panic with current git head
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com>	 <1232115546.3224.5.camel@localhost.localdomain>	 <4973D2EE.3060203@jp.fujitsu.com>	 <1232328216.3247.68.camel@localhost.localdomain>	 <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain>
In-Reply-To: <1232558780.736.24.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2009-01-19 at 12:11 +0900, Kenji Kaneshige wrote:
>> I'm sending the debug patch against 2.6.29-rc1 below. I'm also
>> sending it as an attachment. It also contains the code to prevent
>> the kernel panic from you. Please note that you will see two
>> WARN_ON(1) messages with the patch. Those are shown by my debug
>> patch.
>>
>> Could you try it and send me the whole dmsg output?
> 
> Actually, the machine is now running -rc2, so the patch doesn't quite
> apply: 
> 
> jejb@sparkweed> patch -p1 < ~/tmp.diff
> patching file include/linux/pci-acpi.h
> patching file drivers/pci/hotplug/acpiphp_glue.c
> Hunk #1 FAILED at 266.
> Hunk #2 succeeded at 467 (offset 2 lines).
> Hunk #3 succeeded at 489 (offset 2 lines).
> Hunk #4 succeeded at 518 (offset 2 lines).
> Hunk #5 succeeded at 556 (offset 2 lines).
> 
> Looks like the rejection is in the NULL check piece, so I've already
> actually sent you the information it would produce.
> 
> The dmesg output is pretty big, below.
> 

Thank you very much, James.

Thanks to you, I found the root cause of the
problem. The acpi_pci_get_bridge_handle() function assumes
pci_bus->self is NULL on the root bus. But it is not true
and pci_bus->self can have a non-NULL value on some
platfroms (like yours). So it must check pci_bus->parent
instead.

I found some other code that has the same wrong assumption.
I'll make a fix for them and send it soon.

Thanks,
Kenji Kaneshige


