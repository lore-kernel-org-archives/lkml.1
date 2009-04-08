Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbZDHBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbZDHBEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZDHBE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:04:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37138 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZDHBE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:04:27 -0400
Message-ID: <49DBF80F.7080802@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 10:04:15 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Patterson <andrew.patterson@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH] Add support for turning PCIe ECRC on or off
References: <20090402221751.11757.36392.stgit@bob.kio>	 <49D56F87.9030104@jp.fujitsu.com> <1238777923.19984.110.camel@grinch>	 <49DAAFBE.5040808@jp.fujitsu.com> <1239122157.19984.188.camel@grinch>
In-Reply-To: <1239122157.19984.188.camel@grinch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson wrote:
> On Tue, 2009-04-07 at 10:43 +0900, Kenji Kaneshige wrote:
>> Andrew Patterson wrote:
>>> On Fri, 2009-04-03 at 11:08 +0900, Kenji Kaneshige wrote:
>>>> Andrew Patterson wrote:
>>>>> Add support for turning PCIe ECRC on or off
>>>>>

(snip.)

> 
>> The reason why I think we need to request control over AER from firmware
>> is based on the following descriptions in "6.2.9 _OSC (Operating System
>> Capabilities) of ACPI3.0b spec. For example,
>>
>>    "... If any bits in the Control Field are returned cleared (masked
>>    to zero) by the _OSC control method, the respective feature is
>>    designated unsupported by the platform and must not be enabled by the
>>    OS. Some of these features may be controlled by platform firmware
>>    prior to OS boot or during runtime for a legacy OS, while others may
>>    be disabled/inoperative until native OS support is available. ..."
>>    (in "6.2.9.1 _OSC Implementation Example for PCI Host Bridge Devices")
>>
>>    "... The OS must evaluate _OSC under the following conditions:
>>     During initialization of any driver that provides native support for
>>     features described in the section above. ..." (in "6.2.9.1.1.2
>>     Evaluation Conditions")
>>
>> Please also see "Table 6-10 Interpretation of _OSC Control Field, Passed
>> in via Arg3" and "Table 6-11 Interpretation of _OSC Control Field,
>> Returned Value".
>>
> 
> Here is the AER entry in table 6-11:
> 
> "The firmware sets this bit to 1 to grant control over PCI Express
> Advanced Error  Reporting. If firmware allows the OS control of this
> feature, then in the context of
> the _OSC method it must ensure that error messages are routed to device
> interrupts as described in the PCI Express Base Specification.
> Additionally, after control is transferred to the OS, firmware must not
> modify the Advanced Error Reporting Capability. If control of this
> feature was requested and denied or was not requested, firmware returns
> this bit set to 0."
> 
> Does this mean that you can't access any of the bits in any AER
> registers unless you take control via _OSC? On the other hand, given
> that firmware cannot touch AER registers after _OSC grants control, it
> makes some sense that software cannot do so without permission.
> 

Yes, I think so.
(I think we cannot program AER registers).

> 
>> And my interpretation is also based on the following spec in "6.2.7.3
>> PCI Express Setting Record (Type 2)" in ACPI3.0b.
>>
>>    "... The Type 2 Setting Record allows a PCI Express-aware OS that
>>     supports native hot plug to configure the specified registers of the
>>     hot plugged PCI Express device. A PCI Express-aware OS that has
>>     assumed ownership of native hot plug (via _OSC) but does not support
>>     or does not have ownership of the AER register set must use the data
>>     values returned by the _HPX object‘s Type 2 record to program the
>>     AER registers of a hot-added PCI Express device. ..."
>>
>> I believe "PCI Express Advanced Error capabilities and Control Register"
>> is one of the AER registers.
> 
> Yes. 
> 
> I am mostly convinced. I will rework this.
> 

Just in case, what I thought from the description of _HPX is that the
OS must not program AER registers by its own decision if the OS does
not have ownership of the AER registers.

Thanks,
Kenji Kaneshige

