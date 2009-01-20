Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZATJpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZATJpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZATJo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:44:57 -0500
Received: from h155.mvista.com ([63.81.120.155]:16760 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754756AbZATJo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:44:56 -0500
Message-ID: <49759D0E.804@ru.mvista.com>
Date: Tue, 20 Jan 2009 12:44:46 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       teheo@novell.com, trenn@suse.de,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
References: <20090119202423.GA7070@ucw.cz> <200901192150.59438.rjw@sisk.pl> <20090119221508.GA2576@elf.ucw.cz> <200901200036.14640.rjw@sisk.pl>
In-Reply-To: <200901200036.14640.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Rafael J. Wysocki wrote:

>>>> In 2.6.29 (and probably earlier) kernels, booting in docking station
>>>> results in undocked s2ram failing.
>>>>
>>>> Problem seems to be that hda (cdrom in dock) is not deregistered
>>>> during undock, and that hda driver loops spitting error messages at
>>>> 'too-fast-to-read' rate when suspend with missing hda is attempted.
>>>>         
>>> What driver do you mean exactly?  Old-IDE I would guess.
>>>
>>> Does this also happen with a PATA/libata driver?
>>>       
>> I guess I'm confused. I tried:
>>
>> --- config.ok	2009-01-19 11:40:42.000000000 +0100
>> +++ ../b-linux/.config	2009-01-19 22:45:03.000000000 +0100
>> @@ -1022,7 +1022,7 @@
>>  # CONFIG_SATA_SIL24 is not set
>>  CONFIG_ATA_SFF=y
>>  CONFIG_SATA_SVW=y
>> -CONFIG_ATA_PIIX=y
>> +# CONFIG_ATA_PIIX is not set
>>  # CONFIG_SATA_MV is not set
>>  # CONFIG_SATA_NV is not set
>>  # CONFIG_PDC_ADMA is not set
>> @@ -1058,8 +1058,8 @@
>>  # CONFIG_PATA_JMICRON is not set
>>  # CONFIG_PATA_TRIFLEX is not set
>>  # CONFIG_PATA_MARVELL is not set
>> -# CONFIG_PATA_MPIIX is not set
>> -# CONFIG_PATA_OLDPIIX is not set
>> +CONFIG_PATA_MPIIX=y
>> +CONFIG_PATA_OLDPIIX=y
>>  # CONFIG_PATA_NETCELL is not set
>>  # CONFIG_PATA_NINJA32 is not set
>>  # CONFIG_PATA_NS87410 is not set
>>
>> ...but cdrom is still detected as hda.
>>     
>
> Er, CONFIG_ATA_PIIX is a SATA driver.

   Not really, it drives both SATA and PATA controllers.

MBR, Sergei


