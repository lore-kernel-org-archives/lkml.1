Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZIUPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZIUPCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZIUPCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:02:33 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:41672 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZIUPCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:02:33 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
Date: Mon, 21 Sep 2009 11:02:25 -0400
User-Agent: KMail/1.12.1 (Linux/2.6.31; KDE/4.3.1; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
 <200909202035.54220.gene.heskett@verizon.net>
 <68676e00909210243h7aab926cr225779826743ed33@mail.gmail.com>
In-reply-to: <68676e00909210243h7aab926cr225779826743ed33@mail.gmail.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Content-transfer-encoding: 8BIT
Message-id: <200909211102.25354.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 September 2009, Luca Tettamanti wrote:
>On Mon, Sep 21, 2009 at 2:35 AM, Gene Heskett <gene.heskett@verizon.net> 
wrote:
>> On Sunday 20 September 2009, Luca Tettamanti wrote:
>>>On Sun, Sep 20, 2009 at 10:37 PM, Gene Heskett <gene.heskett@verizon.net>
>>
>> wrote:
>>>> Jumping in the middle of this, I am another that it87 doesn't work very
>>>> well for,  ASUS M2N SLI Deluxe board.
>>>
>>>Please define "doesn't work well". asus_atk0110 should handle that
>>>board. In case of troubles enable CONFIG_HWMON_DEBUG_CHIP, load
>>>asus_atk0110 and post the content of the kernel log.
>>
>> With that CONFIG_HWMON_DEBUG_CHIP enabled, dmesg (attached) looks semi-
>> kosher, but neither gkrellm nor sensors can show me data until it87 is
>> loaded.  I unloaded it87 and reloaded it several times just now.
>>  Something funkity someplace...  Is there a new application I need to dl
>> and install?
>
>You probably need to upgrade the lm-sensors package. Version 3.1.1 has
>support for ACPI devices.
>
Its the latest in the F10 repos, Luca.  I have these:

lm_sensors-3.0.2-1.fc10.i386
lm_sensors-sensord-3.0.2-1.fc10.i386

 I also note that while asus_atk0110 is loaded, it has no link count in an 
lsmod output.  This has little or nothing to do with the lm_sensors version, 
when the kernel itself (2.6.31 final) doesn't get any real data.  Or can it?

>From dmesg on rmmod then modprobe of asus_atk0110:
[52610.470618] ATK0110 ATK0110:00: removing...
[52622.799018] ATK0110 ATK0110:00: adding...
[52622.799047] ATK0110 ATK0110:00: board ID = M2N-SLI
[52622.799051] ATK0110 ATK0110:00: Using old hwmon interface
[52622.799126] ATK0110 ATK0110:00: voltage: 0x6020000 Vcore Voltage 
[850-1600] enabled
[52622.799131] ATK0110 ATK0110:00: voltage: 0x6020001  +3.3 Voltage 
[3000-3600] enabled
[52622.799136] ATK0110 ATK0110:00: voltage: 0x6020002  +5.0 Voltage 
[4500-5500] enabled
[52622.799140] ATK0110 ATK0110:00: voltage: 0x6020003 +12.0 Voltage 
[11200-13200] enabled
[52622.799186] ATK0110 ATK0110:00: temperature: 0x6030000 CPU Temperature 
[900-1250] enabled
[52622.799190] ATK0110 ATK0110:00: temperature: 0x6030001 MB Temperature 
[450-900] enabled
[52622.799251] ATK0110 ATK0110:00: fan: 0x6040000 CPU FAN Speed [0-1800] 
enabled
[52622.799255] ATK0110 ATK0110:00: fan: 0x6040001 CHASSIS FAN Speed [0-1800] 
enabled
[52622.799259] ATK0110 ATK0110:00: fan: 0x6040002 POWER FAN Speed [0-1800] 
enabled
[52622.799263] ATK0110 ATK0110:00: fan: 0x6040021 CHASSIS4 FAN FAN Speed 
[0-1800] enabled
[52622.799267] ATK0110 ATK0110:00: fan: 0x6040022 CHASSIS2 FAN FAN Speed 
[0-1800] enabled
[52622.799271] ATK0110 ATK0110:00: fan: 0x6040023 CHASSIS3 FAN FAN Speed 
[0-1800] enabled
[52622.799274] ATK0110 ATK0110:00: registering hwmon device
[52622.799937] ATK0110 ATK0110:00: populating sysfs directory

I've stumbled around is the /sys/fs tree looking for data, but wasn't able to 
do anything but get stuck in a re-entrant loop, that is a bowl of spaghetti, 
well stirred.  You can get back out, but each suspect link just puts you one 
level deeper in the tree and no real data is ever offered even when 10+ 
levels deep in that linkage loop.

I'll go bugzilla the F10 lm_sensors packages.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

I'd like some JUNK FOOD ... and then I want to be ALONE --
