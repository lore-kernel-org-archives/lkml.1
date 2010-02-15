Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0BONvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 08:51:31 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:52935 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab0BONv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 08:51:29 -0500
Message-ID: <4B79515E.4070303@blueyonder.co.uk>
Date: Mon, 15 Feb 2010 13:51:26 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.3 Thunderbird/3.0.1 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #15144] HDA Intel Audio hang on boot
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>	<d3IDKWHT5gE.A.MEC.a7hZLB@chimera>	<4B6635F1.8060909@blueyonder.co.uk>	<s5h3a1lh2wr.wl%tiwai@suse.de>	<4B785D0D.3070804@blueyonder.co.uk>	<s5haavb9dli.wl%tiwai@suse.de>	<4B79422B.7080701@blueyonder.co.uk> <s5hocjqu0c7.wl%tiwai@suse.de>
In-Reply-To: <s5hocjqu0c7.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/10 12:53, Takashi Iwai wrote:
> At Mon, 15 Feb 2010 12:46:35 +0000,
> Sid Boyce wrote:
>>
>> On 15/02/10 07:12, yTakashi Iwai wrote:
>>> At Sun, 14 Feb 2010 20:29:01 +0000,
>>> Sid Boyce wrote:
>>>>
>>>> On 01/02/10 06:43, Takashi Iwai wrote:
>>>>> At Mon, 01 Feb 2010 02:01:21 +0000,
>>>>> Sid Boyce wrote:
>>>>>>
>>>>>> On 01/02/10 00:22, Rafael J. Wysocki wrote:
>>>>>>> This message has been generated automatically as a part of a report
>>>>>>> of recent regressions.
>>>>>>>
>>>>>>> The following bug entry is on the current list of known regressions
>>>>>>> from 2.6.32.  Please verify if it still should be listed and let me know
>>>>>>> (either way).
>>>>>>>
>>>>>>>
>>>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15144
>>>>>>> Subject		: HDA Intel Audio hang on boot
>>>>>>> Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
>>>>>>> Date		: 2010-01-15 1:24 (17 days old)
>>>>>>> References	: http://marc.info/?l=linux-kernel&m=126351866722507&w=4
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Still not fixed in 2.6.33-rc6. Takashi wrote that the fix was scheduled
>>>>>> for 2.6.33-rc6, but it did not appear.
>>>>>
>>>>> It just slipped from rc6 due to my busy load.
>>>>> The pull request was sent yesterday.
>>>>>
>>>>>
>>>>> Takashi
>>>>>
>>>>
>>>> Up to 2.6.33-rc8 still needs the work around in
>>>> /etc/modprobe.d/50-sound.conf, so the kernel blacklist fix does not work.
>>>
>>> Check the kernel message.  Don't you have a message like "hda_intel:
>>> msi for device 1043:829c set to 0"?  Otherwise give alsa-info.sh
>>> again.
>>>
>> No mention of it - 2.6.33-rc8.
>> tindog:~ # dmesg|grep 1043
>> tindog:~ # grep 1043 /var/log/boot.msg
>> tindog:~ # grep 1043 /var/log/messages
>> tindog:~ #
>> The patch seems to be addressing the wrong  device, alsa-info.sh shows
>> it as
>>         Subsystem: 1043:81f6
>> Subsystem Id: 0x104381f6
>>   Components    : 'HDA:11d4198b,104381f6,00100300'
>>
>> tindog:/usr/src/linux-2.6.33-rc8 # grep 1043 ./sound/pci/hda/hda_intel.c
>>         SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
>>         SND_PCI_QUIRK(0x1043, 0x1262, "ASUS W5Fm", 0x103),
>>         SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
>>         SND_PCI_QUIRK(0x1043, 0x829c, "ASUS", 0), /* nvidia */
>>
>> I shall change the 0x81f2 to 0x81f6 and test.
> 
> Yes, please.  And update the bugzilla with the correct alsa-info.sh
> output, too.
> 
>>> But, essentially this is a problem of your mobo and Linux MSI
>>> handling, not exactly a driver issue, IMO...
>>>
>> I think you are correct, could be the motherboard or BIOS. I have tried
>> a number of BIOS versions with the same result. I am about to change to
>> a Asus Crosshair III motherboard in a few days when the memory arrives.
>> It also wouldn't boot if I have kgdb enabled in .config, I get a stream
>> of Traces with "Tainted".
>>
>>> I guess the problem will go away if you remove your another sound card
>>> on the PCI slot.  Or maybe it'd work even by moving to another
>>> slot...
>>>
>> It's the on-board sound. Before the work around I had to disable it in
>> the BIOS and use the USB sound card.
> 
> Hm, then I must I have checking really a different alsa-info.sh.
>
I went back and checked the first alsa-info.txt I sent.

My mistake this end, using ssh into that box, used scp to copy it to
this box and inadvertently provided the wrong alsa-info.txt which was
the one (1043:829c) for this box where email lives.
Sincere apologies for the mixup.
> 
> thanks,
> 
The change works, it should be "0x1043, 0x81f6" instead of 0x829c.
> Takashi
> 
Regards
Sid.


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

