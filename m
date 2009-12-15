Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbZLOTpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbZLOTpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZLOTpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:45:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:49243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbZLOTpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:45:43 -0500
Message-ID: <4B27E71E.6020709@kernel.org>
Date: Tue, 15 Dec 2009 11:44:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
References: <20091215115052.GA28252@kernel.dk> <4B277AB2.8030107@kernel.org> <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org> <20091215185941.GO28252@kernel.dk> <4B27DDD7.5040301@kernel.org> <20091215191129.GQ28252@kernel.dk>
In-Reply-To: <20091215191129.GQ28252@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Dec 15 2009, Yinghai Lu wrote:
>> Jens Axboe wrote:
>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
>>>> [   13.018720] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
>>>>
>>>> [   13.100724] [Firmware Bug]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources
>>> On a "normal" non-kexec boot, I get:
>>>
>>> [   12.173583] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
>>> [   12.184075] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
>>> [   12.216874] PCI: Using configuration type 1 for base access
>>>
>> can you run following scripts in first kernel?
>>
>> cd /sys/firmware/memmap
>> for dir in * ; do
>>   start=$(cat $dir/start)
>>   end=$(cat $dir/end)
>>   type=$(cat $dir/type)
>>   printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type" >> /tmp/memmap.txt
>> done
>>
>> and send out /tmp/memmap.txt
> 
> Below.
> 
>> what is your kexec tools version? could be too old?
> 
> It says:
> 
> kexec-tools-testing 20080324 released 24th March 2008
> 
> 
> 0000000000000000-0000000000098800 (System RAM)
> 0000000000098800-00000000000a0000 (reserved)
> 0000000079301000-0000000079303000 (reserved)
> 0000000079303000-0000000079305000 (ACPI Tables)
> 0000000079305000-0000000079310000 (reserved)
> 0000000079310000-0000000079314000 (ACPI Tables)
> 0000000079314000-0000000079319000 (reserved)
> 0000000079319000-0000000079336000 (ACPI Tables)
> 0000000079336000-0000000079358000 (reserved)
> 0000000079358000-0000000079388000 (ACPI Tables)
> 0000000079388000-00000000793c9000 (reserved)
> 00000000793c9000-000000007968f000 (ACPI Tables)
> 00000000000e0000-0000000000100000 (reserved)
> 000000007968f000-00000000796bb000 (reserved)
> 00000000796bb000-00000000799d8000 (ACPI Tables)
> 00000000799d8000-0000000079bd8000 (ACPI Non-volatile Storage)
> 0000000079bd8000-0000000079d8b000 (ACPI Tables)
> 0000000079d8b000-0000000079d8c000 (reserved)
> 0000000079d8c000-0000000079dc8000 (ACPI Tables)
> 0000000079dc8000-0000000079dcb000 (reserved)
> 0000000079dcb000-0000000079e1c000 (ACPI Tables)
> 0000000079e1c000-0000000079e87000 (reserved)
> 0000000079e87000-000000007bd5f000 (ACPI Tables)
> 0000000000100000-0000000078c59000 (System RAM)
> 000000007bd5f000-000000007be4f000 (reserved)
> 000000007be4f000-000000007bf87000 (ACPI Tables)

so following ranges are not passed to second kernel by kexec?

> 000000007bf87000-000000007bfcf000 (ACPI Non-volatile Storage)
> 000000007bfcf000-000000007bfff000 (ACPI Tables)
> 000000007bfff000-0000000090000000 (reserved)
> 00000000fc000000-00000000fd000000 (reserved)
> 00000000fed1c000-00000000fed20000 (reserved)
> 00000000ff000000-0000000100000000 (reserved)
> 0000000100000000-0000001080000000 (System RAM)
> 0000000078c59000-0000000078e6d000 (ACPI Non-volatile Storage)
> 0000000078e6d000-000000007924e000 (ACPI Tables)
> 000000007924e000-00000000792c2000 (reserved)
> 00000000792c2000-00000000792d2000 (ACPI Tables)
> 00000000792d2000-00000000792e7000 (reserved)
> 00000000792e7000-0000000079301000 (ACPI Tables)
> 

second kernel only get

[    0.000000] BIOS-provided physical RAM map:

[    0.000000]  BIOS-e820: 0000000000000100 - 0000000000098800 (usable)

[    0.000000]  BIOS-e820: 0000000000098800 - 00000000000a0000 (reserved)

[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)

[    0.000000]  BIOS-e820: 0000000000100000 - 0000000078c63000 (usable)

[    0.000000]  BIOS-e820: 0000000078c63000 - 0000000078e77000 (ACPI NVS)

[    0.000000]  BIOS-e820: 0000000078e77000 - 000000007924e000 (ACPI data)

[    0.000000]  BIOS-e820: 000000007924e000 - 00000000792c2000 (reserved)

[    0.000000]  BIOS-e820: 00000000792c2000 - 00000000792d2000 (ACPI data)

[    0.000000]  BIOS-e820: 00000000792d2000 - 00000000792e7000 (reserved)

[    0.000000]  BIOS-e820: 00000000792e7000 - 0000000079301000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079301000 - 0000000079303000 (reserved)

[    0.000000]  BIOS-e820: 0000000079303000 - 0000000079305000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079305000 - 0000000079310000 (reserved)

[    0.000000]  BIOS-e820: 0000000079310000 - 0000000079314000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079314000 - 0000000079319000 (reserved)

[    0.000000]  BIOS-e820: 0000000079319000 - 0000000079336000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079336000 - 0000000079358000 (reserved)

[    0.000000]  BIOS-e820: 0000000079358000 - 0000000079388000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079388000 - 00000000793c9000 (reserved)

[    0.000000]  BIOS-e820: 00000000793c9000 - 000000007968f000 (ACPI data)

[    0.000000]  BIOS-e820: 000000007968f000 - 00000000796bb000 (reserved)

[    0.000000]  BIOS-e820: 00000000796bb000 - 00000000799d8000 (ACPI data)

[    0.000000]  BIOS-e820: 00000000799d8000 - 0000000079bd8000 (ACPI NVS)

[    0.000000]  BIOS-e820: 0000000079bd8000 - 0000000079d87000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079d87000 - 0000000079d8a000 (reserved)

[    0.000000]  BIOS-e820: 0000000079d8a000 - 0000000079dca000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079dca000 - 0000000079dcb000 (reserved)

[    0.000000]  BIOS-e820: 0000000079dcb000 - 0000000079e1c000 (ACPI data)

[    0.000000]  BIOS-e820: 0000000079e1c000 - 0000000079e87000 (reserved)

[    0.000000]  BIOS-e820: 0000000079e87000 - 000000007bd5f000 (ACPI data)

[    0.000000]  BIOS-e820: 000000007bd5f000 - 000000007be4f000 (reserved)

[    0.000000]  BIOS-e820: 000000007be4f000 - 000000007bf87000 (ACPI data)

so mmconf range is not reserved, and some ACPI data
> 0000000078c59000-0000000078e6d000 (ACPI Non-volatile Storage)
0000000078c59000 - 0000000078c63000 get currupted...

YH

