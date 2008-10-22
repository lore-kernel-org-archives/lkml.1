Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYJVHaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYJVHaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYJVHaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:30:00 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:45346 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbYJVH37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:29:59 -0400
Message-ID: <48FED672.4060008@suse.de>
Date: Wed, 22 Oct 2008 11:29:54 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Dmitry Nezhevenko <dion@inhex.net>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: Strange ACPI errors sometimes after resume from s2disk
References: <20081021220034.GA18248@laptop.local> <200810220044.01259.rjw@sisk.pl>
In-Reply-To: <200810220044.01259.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> [Adding CCs]
> 
> On Wednesday, 22 of October 2008, Dmitry Nezhevenko wrote:
>> Hiall. Just got these strange messages with 2.6.27.2. They flood dmesg.. (same block every second). 
>>
>> [42016.520062] ACPI: EC: acpi_ec_wait timeout, status = 0x1a, event = "b1=0"
>> [42016.520079] ACPI: EC: input buffer is not empty, aborting transaction
>> [42017.025050] ACPI: EC: acpi_ec_wait timeout, status = 0x1a, event = "b1=0"
>> [42017.025197] ACPI: EC: input buffer is not empty, aborting transaction
>> [42017.025254] ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for [EmbeddedControl] [20080609]
>> [42017.025350] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.SBRG.EC__.BAT1.UPBS] (Node f78353b0), AE_TIME
>> [42017.025546] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.SBRG.EC__.BAT1._BST] (Node f7835400), AE_TIME
>> [42017.025715] ACPI Exception (battery-0360): AE_TIME, Evaluating _BST [20080609]
>>
>> Battery state "freezes" after this.. So if it was charged to 90%, it will
>> be 90% forever.  Also information about charger (plugged/unplugged) is not
>> updating... BIOS automatically increases display brightness just after
>> plugging charger but powersave thinks that it's unplugged.
>>
>> After turning laptop off I can't turn it on any more.. I can hear fan noise,
>> but it don't boots (There are no even BIOS splash/message)
>>
>> I should remove battery and wait ~5 seconds...
>>
>> v2.6.26 was non-working here, but as far as I remember, there was no such
>> problem with 2.6.25.  It's very difficult to reproduce it (this is just
>> second case for ~2-3 weeks).  So bisecting is impossible.
>>
>> Any ideas? Should I fill a bugreport?
Please try changing msleep(1) to udelay(50) in drivers/acpi/ec.c 
Do you have msi-laptop module loaded?
Please fill a bugreport and attach all the information there.

Thanks,
Alex.
