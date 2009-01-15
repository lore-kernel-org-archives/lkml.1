Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZAOGZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZAOGZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZAOGZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:25:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42593 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZAOGZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:25:20 -0500
Message-ID: <496ED6BA.6060500@jp.fujitsu.com>
Date: Thu, 15 Jan 2009 15:24:58 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
References: <200901042346.42723.rjw@sisk.pl> <496D815E.8010107@jp.fujitsu.com> <200901141135.31165.rjw@sisk.pl> <200901141157.32720.rjw@sisk.pl>
In-Reply-To: <200901141157.32720.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday 14 January 2009, Rafael J. Wysocki wrote:
>> On Wednesday 14 January 2009, Kenji Kaneshige wrote:
> [...]
>>> I'm sorry but I don't understand what the problem is.
>>> Do you mean pci_disable_msix() doesn't work on some platforms?
>> No, I don't.  It was just confusion on my side, sorry.
>>
>> Please have a look at the new version of the patch I sent yesterday
>> (http://marc.info/?l=linux-pci&m=123185510828181&w=4).
> 
> BTW, in your patch the first dummy pci_enable_msix() allocates just one
> vector, which means that the contents of both
> msix_entries[idx_hppme].entry and msix_entries[idx_aer].entry will be the same,
> if my reading of the spec (PCI 3.0 in this case) is correct.
> 
> However, if the second pci_enable_msix() allocates two vectors, the contents of the
> message number fields in the PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS
> registers may change as a result.
> 

For MSI, the interrupt message number field may change if the Multiple
Message Enable Field was changed. On the other hand, for MSI-X, I think
the interrupt message number field is constant. This is what the "[...]
For a given MSI-X implementation, the entry must remain constant. [...]"
explains in PCI Express spec, I think.

Thanks,
Kenji Kaneshige


