Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZI1UoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZI1UoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZI1UoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:44:05 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:56184 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbZI1UoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:44:04 -0400
Message-ID: <4AC12015.4040508@suse.de>
Date: Tue, 29 Sep 2009 00:44:05 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thomas Backlund <tmb@mandriva.org>
CC: Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [git pull request] ACPI & driver patches for Linux-2.6.32-rc0
References: <alpine.LFD.2.00.0909190237560.22030@localhost.localdomain> <4ABCB2CA.4020709@mandriva.org> <d3f22a0909261902o5e48c2a0lab56fca21edf8c5b@mail.gmail.com> <1254016503.17697.21.camel@minggr.sh.intel.com> <alpine.LFD.2.00.0909270348570.16783@localhost.localdomain> <4AC11A0F.2030806@mandriva.org>
In-Reply-To: <4AC11A0F.2030806@mandriva.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund пишет:
> Len Brown wrote:
>>>> This gets my laptop flooding logs with:
>>
>>>>> ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] 
>>>>> (20090903/evregion-424)
>>>>> ACPI Error (psparse-0537): Method parse/execution failed 
>>>>> [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
>>>>> ACPI Error (psparse-0537): Method parse/execution failed 
>>>>> [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
>>>>> ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
>>
>>> Could you do a bisect?
>>
>> In particular, please try the 2.6.31 versio of drivers/acpi/ec.c
>>
> 
> Hi,
> 
> in order to get the 2.6.31 version of ec.c to build I had to apply a 
> small patch:
> 
>> --- linux-acpi/drivers/acpi/ec.c.orig    2009-09-10 01:13:59.000000000 
>> +0300
>> +++ linux-acpi/drivers/acpi/ec.c    2009-09-28 21:09:15.359406828 +0300
>> @@ -42,6 +42,7 @@
>>  #include <asm/io.h>
>>  #include <acpi/acpi_bus.h>
>>  #include <acpi/acpi_drivers.h>
>> +#include <linux/dmi.h>
>>  
>>  #define ACPI_EC_CLASS            "embedded_controller"
>>  #define ACPI_EC_DEVICE_NAME        "Embedded Controller"
>> @@ -1078,7 +1079,6 @@ static struct acpi_driver acpi_ec_driver
>>          .add = acpi_ec_add,
>>          .remove = acpi_ec_remove,
>>          .start = acpi_ec_start,
>> -        .stop = acpi_ec_stop,
>>          .suspend = acpi_ec_suspend,
>>          .resume = acpi_ec_resume,
>>          },
> 
> After that  it built and the errors are gone.
> 
> Now this is a Acer TravelMate 5720G laptop with the latest 1.35 bios.
> Distro is Mandriva Linux Cooker, and arch is x86_64
> 
> Attached is output of "grep ACPI /var/log/dmesg"
> dmesg-acpi-20090903
> - all acpi patches as of 2.6.32-rc1
This one does not have errors you've mentioned earlier, could you find dmesg with them?
> 
> dmesg-acpi-20090903-ec-2.6.31
> - all acpi patches as of 2.6.32-rc1
> - ec.c from 2.6.31.1
> 
> 
> Should I start bisecting, or do you have any other suggestion?
There is only one patch which touch ec.c, 2a84cb9852f52c0cd1c48bca41a8792d44ad06cc. You may try to revert it, and see.


Regards,
Alex.
