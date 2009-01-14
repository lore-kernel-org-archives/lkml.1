Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbZANGI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbZANGI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZANGIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:08:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52076 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZANGIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:08:44 -0500
Message-ID: <496D815E.8010107@jp.fujitsu.com>
Date: Wed, 14 Jan 2009 15:08:30 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
References: <200901042346.42723.rjw@sisk.pl> <200901100038.56748.rjw@sisk.pl> <496C00CD.3070302@jp.fujitsu.com> <200901131217.07537.rjw@sisk.pl>
In-Reply-To: <200901131217.07537.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 13 January 2009, Kenji Kaneshige wrote:
>> Rafael J. Wysocki wrote:
>>> On Saturday 10 January 2009, Jesse Barnes wrote:
>>>> On Thursday, January 8, 2009 12:45 pm Rafael J. Wysocki wrote:
>>>>> On Thursday 08 January 2009, Rafael J. Wysocki wrote:
>>>>>> On Thursday 08 January 2009, Kenji Kaneshige wrote:
>>>>>>> Rafael J. Wysocki wrote:
>>>>>>>> On Thursday 08 January 2009, Kenji Kaneshige wrote:
>>>>>>>>> Rafael J. Wysocki wrote:
>>>>>>>>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>>>>>>>>
>>>>>>>>>> If MSI-X interrupt mode is used by the PCI Express port driver, too
>>>>>>>>>> many vectors are allocated and it is not ensured that the right
>>>>>>>>>> vectors will be used for various services.  Namely, the PCI Express
>>>>>>>>>> specification states that both PCI Express native PME and PCI
>>>>>>>>>> Express hotplug will always use the same MSI or MSI-X message for
>>>>>>>>>> signalling interrupts, which implies that the same vector will be
>>>>>>>>>> used by both of them.  Also, the VC service does not use interrupts
>>>>>>>>>> at all. Moreover, is not clear which of the vectors allocated by
>>>>>>>>>> pci_enable_msix() will be used for PME and hotplug and which of
>>>>>>>>>> them will be used for AER if all of these services are configured.
>>>>>>>>>>
>>>>>>>>>> For these reasons, rework the allocation of interrupts for PCI
>>>>>>>>>> Express ports so that at most two vectors are allocated and ensure
>>>>>>>>>> that the right vector will be used for the right purpose.
>>>>> Appended is a cleaned-up version of the patch that also contains comments
>>>>> with references to the appropriate sections of the PCI Express spec.
>>>> We'll need testing here in any case; I'll have to re-read the specs carefully 
>>>> to see if we can really rely on the vector numbers you have here (at first 
>>>> glance Kenji-san's approach seems more robust).
>>> It has a catch too.  Namely, is there any warranty that we'll get the same
>>> vectors when the second pci_enable_msix() is called and that they will be in
>>> the same order?
>>>
>> In my understanding, the following description of Interrupt Message
>> Number in the PCI Express spec explains this.
>>
>> "[...] For a given MSI-X implementation, the entry must remain constant. [...]"
> 
> The entry - yes, but the associated interrupt vector as sent to the CPU?  That
> seems to be platform-dependent.
> 

I'm sorry but I don't understand what the problem is.
Do you mean pci_disable_msix() doesn't work on some platforms?

Thanks,
Kenji Kaneshige

