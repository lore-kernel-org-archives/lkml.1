Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZASBKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZASBKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbZASBKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:10:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33276 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZASBKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:10:14 -0500
Message-ID: <4973D2EE.3060203@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 10:10:06 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, shaohua.li@intel.com
Subject: Re: ACPI hotplug panic with current git head
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com> <1232115546.3224.5.camel@localhost.localdomain>
In-Reply-To: <1232115546.3224.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-01-16 at 15:07 +0900, Kenji Kaneshige wrote:
>>> It looks like acpi_pci_get_bridge_handle() is returning NULL, so this is
>>> the fix that works for me.
>>>
>> I'm sorry for troubling you, and thank you for your patience.
>>
>> The patch seems to avoid the kernel panic, but I still don't know
>> why acpi_pci_get_bridge_handle() returns NULL here. I assumed
>> it should return non-NULL value here. So I'd like to investigate
>> it more.
> 
> Sure, Len and I couldn't work out why it was returning NULL on this box
> (other than that perhaps it doesn't have an ACPI entry).  The two
> offending busses which trigger this are the two internal ones (which
> aren't hotplug).  The layout of the box is:
> 
> sparkweed:~# lspci -t
> -+-[0000:0c]---00.0
>  +-[0000:0a]---00.0
>  +-[0000:08]---00.0
>  +-[0000:06]---00.0
>  +-[0000:04]---00.0
>  +-[0000:02]---00.0
>  +-[0000:01]-+-00.0
>  |           +-01.0
>  |           +-01.1
>  |           \-02.0
>  \-[0000:00]-+-00.0
>              +-01.0
>              +-03.0
>              +-03.1
>              +-03.2
>              +-0f.0
>              +-0f.1
>              \-0f.3
> sparkweed:~# lspci   
> 00:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 00:01.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY
> [Radeon 7000/VE]
> 00:03.0 USB Controller: NEC Corporation USB (rev 43)
> 00:03.1 USB Controller: NEC Corporation USB (rev 43)
> 00:03.2 USB Controller: NEC Corporation USB 2.0 (rev 04)
> 00:0f.0 Host bridge: Broadcom CSB6 South Bridge (rev a0)
> 00:0f.1 IDE interface: Broadcom CSB6 RAID/IDE Controller (rev a0)
> 00:0f.3 ISA bridge: Broadcom GCLE-2 Host Bridge
> 01:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 01:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704
> Gigabit Ethernet (rev 10)
> 01:01.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704
> Gigabit Ethernet (rev 10)
> 01:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
> non-RAID) (rev 08)
> 02:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 04:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 06:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 08:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 0a:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 0c:00.0 Host bridge: IBM Calgary PCI-X Host Bridge (rev 02)
> 
> And when I annotate the problem, the two busses returning NULL are
> 0000:00 and 0000:01
> 

Thank you very much for the information. It seems there are
something special in the data structure of host bridge for
0000:00 and 0000:01.

I'm making a debug patch now and will send it to you as soon
as possible. I'm sorry to trouble you, but could you try it
later.

Thanks,
Kenji Kaneshige


