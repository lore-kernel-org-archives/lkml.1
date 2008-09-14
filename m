Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYINCWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYINCWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 22:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYINCWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 22:22:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53686 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYINCWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 22:22:04 -0400
Message-ID: <48CC7542.3010603@garzik.org>
Date: Sat, 13 Sep 2008 22:21:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] SATA: Blacklist systems that spin off disks during ACPI
 power off
References: <200808290002.55026.rjw@sisk.pl> <200808291241.04183.rjw@sisk.pl> <48B7D286.7050104@gmail.com> <200809061923.29020.rjw@sisk.pl> <48C50EA4.2020700@gmail.com>
In-Reply-To: <48C50EA4.2020700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Rafael J. Wysocki wrote:
>> SATA: Blacklist systems that spin off disks during ACPI power off
>>
>> Some notebooks from HP have the problem that their BIOSes attempt to
>> spin down hard drives before entering ACPI system states S4 and S5.
>> This leads to a yo-yo effect during system power-off shutdown and the
>> last phase of hibernation when the disk is first spun down by the
>> kernel and then almost immediately turned on and off by the BIOS.
>> This, in turn, may result in shortening the disk's life times.
>>
>> To prevent this from happening we can blacklist the affected systems
>> using DMI information.  However, only the on-board controlles should
>> be blacklisted and their PCI slot numbers can be used for this
>> purpose.  Unfortunately the existing interface for checking DMI
>> information of the system is not very convenient for this purpose,
>> because to use it, we would have to define special callback functions
>> or create a separate struct dmi_system_id table for each blacklisted
>> system.
>>
>> To overcome this difficulty introduce a new function
>> dmi_first_match() returning a pointer to the first entry in an array
>> of struct dmi_system_id elements that matches the system DMI
>> information.  Then, we can use this pointer to access the entry's
>> .driver_data field containing the additional information, such as
>> the PCI slot number, allowing us to do the desired blacklisting.
>>
>> Introduce a new libata flag ATA_FLAG_NO_POWEROFF_SPINDOWN that, if
>> set, will prevent disks from being spun off during system power off
>> and hibernation (to handle the hibernation case we need a new system
>> state SYSTEM_HIBERNATE_ENTER that can be checked against by libata,
>> in analogy with SYSTEM_POWER_OFF).  Use dmi_first_match() to set this
>> flag for some systems affected by the problem described above (HP nx6325,
>> HP nx6310, HP 2510p).
>>
>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> libata part looks good to me but I think it would be better to
> separate out DMI changes into a separate patch.

Did these changes ever get separated out?

