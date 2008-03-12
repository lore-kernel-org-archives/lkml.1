Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbYCLFwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbYCLFwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYCLFwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:52:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51532 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYCLFwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:52:41 -0400
Message-ID: <47D76F60.6000709@jp.fujitsu.com>
Date: Wed, 12 Mar 2008 14:51:28 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@atrey.karlin.mff.cuni.cz, Matthew Wilcox <matthew@wil.cx>,
       Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
References: <20080229002341.GA21420@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com> <20080311132800.GC21482@parisc-linux.org> <200803110956.37619.jbarnes@virtuousgeek.org>
In-Reply-To: <200803110956.37619.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jesse Barnes wrote:
> On Tuesday, March 11, 2008 6:28 am Matthew Wilcox wrote:
>> On Tue, Mar 11, 2008 at 10:10:40PM +0900, Kenji Kaneshige wrote:
>>> 1) I checked ACPI spec again and again, but I could not find any
>>>    reason to add Fujitsu servers to quirks list. So I'd like you to
>>>    add HP servers to the quirks list. I'll send the following patches
>>>    followed by this e-mail.
>> Alex pointed out that IBM interprets the spec the same way that HP does.
>> Are there any other machines that follow the spec the same way that
>> Fujitsu does?
> 
> So Kenji is arguing that _STA should be called before _SUN (iow that the _SUN 
> value is bogus unless _STA indicates that the slot is powered)?

Yes. And the another reason is _STA is not for representing the presence
of PCI adapter card on the hot-plug slots because ACPI2.0 or later says
"For _HID devices, OSPM evaluates the _STA method. For _ADR devices, OSPM
checks with the bus driver for that device." in the explanation of _EJx.
Since PCI adapter card on a hotplug slot is _ADR device, we must not
provide _STA to represent the presence of PCI adapter card on a hotplug
slot. Please look at the sample ASL codes for PCI hotplug slots in ACPI
spec. There should be no _STA, of course.

This is not described in ACPI1.0b spec and Alex's machine was based on
ACPI1.0b. So I've suggested to check ACPI version in ACPI PCI slot
detection driver. But it turned out that this suggestion didn't work
because HP's ACPI2.0 based machine is doing same as ACPI1.0b based one.

>                                                                 That seems 
> harder for the user; often times you want to find a slot even if it's powered 
> down & empty (say to add a new card)...  It looks like the current code won't 
> provide a slot name on Fujitsu machines in this case, or am I missing 
> something?
 
No. Even if we evaluate _STA before _SUN, ACPI PCI slot detection driver
detects all of the slot on Fujitsu machine regardless of slot status
(present or not) because Fujitsu server never provide _STA for representing
presence of PCI adapter card on the slot.

Thanks,
Kenji Kaneshige

