Return-Path: <linux-kernel-owner+w=401wt.eu-S1764014AbZAOKcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764014AbZAOKcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761223AbZAOKbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:31:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59041 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZAOKbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:31:36 -0500
Message-ID: <496F1078.5040904@jp.fujitsu.com>
Date: Thu, 15 Jan 2009 19:31:20 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
References: <200901042346.42723.rjw@sisk.pl> <496D815E.8010107@jp.fujitsu.com> <200901141135.31165.rjw@sisk.pl> <200901141157.32720.rjw@sisk.pl> <496EE7ED.10408@jp.fujitsu.com>
In-Reply-To: <496EE7ED.10408@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Rafael J. Wysocki wrote:
>> On Wednesday 14 January 2009, Rafael J. Wysocki wrote:
>>> On Wednesday 14 January 2009, Kenji Kaneshige wrote:
>> [...]
>>>> I'm sorry but I don't understand what the problem is.
>>>> Do you mean pci_disable_msix() doesn't work on some platforms?
>>> No, I don't.  It was just confusion on my side, sorry.
>>>
>>> Please have a look at the new version of the patch I sent yesterday
>>> (http://marc.info/?l=linux-pci&m=123185510828181&w=4).
>> BTW, in your patch the first dummy pci_enable_msix() allocates just one
>> vector, which means that the contents of both
>> msix_entries[idx_hppme].entry and msix_entries[idx_aer].entry will be the same,
>> if my reading of the spec (PCI 3.0 in this case) is correct.
> 
> According to PCI 3.0 implementation note "Handling MSI-X Vector Shortage,"
> it seems your reading is not correct.
> 
> Assume that the port have 4 entries([0-3]) in MSI-X table, and that entry[2]
> for hotplug/PME and entry[3] for AER, and that kernel only allocates 2 vector.
> Spec says that the port could be designed for software to configure entries
> assigning vectors{A,B} to multiple entries as ABAB, AABB, ABBB etc. 
> 
> So if there is just one vector, it could be AAAA.
> 

BTW, I don't think pci_enable_msix() allows this kind of configuration.
With the dummy pci_enable_msix() in my patch, it would be A---, I think.

Thanks,
Kenji Kaneshige


