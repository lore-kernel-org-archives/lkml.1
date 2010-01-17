Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072Ab0AQWhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0AQWhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 17:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813Ab0AQWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 17:37:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:37764 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0AQWhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 17:37:12 -0500
Message-ID: <4B5390B7.5000801@kernel.org>
Date: Sun, 17 Jan 2010 14:35:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Alex Chiang <achiang@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/11] pciehp: add support for bridge resource reallocation
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org>	<1263609721-3921-11-git-send-email-yinghai@kernel.org>	<20100116045911.GI22215@ldl.fc.hp.com>	<4B518815.70006@kernel.org>	<1263683671.29907.47.camel@dc7800.home> <20100117093418.6d545b43@jbarnes-piketon>
In-Reply-To: <20100117093418.6d545b43@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2010 09:34 AM, Jesse Barnes wrote:
> On Sat, 16 Jan 2010 16:14:31 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
>> On Sat, 2010-01-16 at 01:34 -0800, Yinghai Lu wrote:
>>> On 01/15/2010 08:59 PM, Alex Chiang wrote:
>>>> * Yinghai Lu <yinghai@kernel.org>:
>>>>> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>>>>>
>>>>> With this patch, pciehp driver try to clear PCI bridge resources
>>>>> to parent bridge (root port or switch downstream port) of the
>>>>> slot
>>>>>
>>>>> so we can shrink pci bridge resource for those port
>>>>>
>>>>> This feature is enabled when 'pciehp_realloc' option is
>>>>> specified.
>>>>>
>>>>> -v2: make it could be appiled after Yinghai patchset that touch
>>>>> pci bridge resource also remove poweron check, because
>>>>> pci_bridge_release_res will check child at first
>>>>
>>>> Same comment as my earlier patch. Why not just make this the
>>>> default behavior, instead of introducing yet another command line
>>>> parameter for users to guess at?
>>>
>>> it will break Eric's setup/
>>
>> I think this is a clue that we don't understand the problem well
>> enough yet.
>>
>> I'm opposed to adding kernel parameters for this sort of thing.  It is
>> unreasonable to expect users to figure out whether they need to use
>> this parameter or not.
>>
>> Special-case switches like this make it much harder to maintain the
>> code in the future.
> 
> Agreed.  Yinghai, what's wrong in the new reassignment code that
> causes Eric's setup to break?  Can we just fix that instead and enable
> reallocation by default?

no.

Eric's setup is:
hot plug one addon card into one hotplug slots and new addon cards have more hot plug slots.

SLOTA will have SLOT B, SLOT C, and SLOT D as children. and not devices in SLOTB/C/D at first.

with the pciehp_realloc is specified, the SLOTA will not get any device assigned, and later
if put devices in SLOTB/SLOTC/SLOTD, will not get resource for those devices.
and we can not go above to update SLOT A, because: some devices on SLOTB could already have driver loaded.

if you don't like pciehp_realloc at this point, please only apply 1-8 and 11.

Thanks

Yinghai Lu
