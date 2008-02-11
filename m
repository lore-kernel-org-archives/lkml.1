Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYBKGFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYBKGFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 01:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYBKGF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 01:05:28 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:31969 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYBKGF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 01:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type;
        b=aIQ+gPHu6fZMqMpkeC0majhd1N9Yc9OwEpzmhyV3jsBblGMti30sIOQSZEa9zhf6GF1MtHPp3r5Gb+digTswz6fEt26srb5LpVc8vzXCcAEdzT/1OweNjgPK1+yuevDQRnsPpflhJewawFylbh1PcQx+4zXb1usTfylBCD2svik=
Message-ID: <47AFE671.9040200@gmail.com>
Date: Mon, 11 Feb 2008 04:08:49 -0200
From: "Carlos R. Mafra" <crmafra@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
References: <47AFDC4D.4070400@gmail.com> <20080210213536.5fc17d6a@laptopd505.fenrus.org>
In-Reply-To: <20080210213536.5fc17d6a@laptopd505.fenrus.org>
Content-Type: multipart/mixed;
 boundary="------------010200070706090905020208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010200070706090905020208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> On Mon, 11 Feb 2008 03:25:33 -0200
> "Carlos R. Mafra" <crmafra@gmail.com> wrote:
> 
>> The problem with suspend to RAM is that right after typing (from
>> inside X) 'echo mem > /sys/power/state' the screen becomes black and
>> the laptop freezes. I have to use SysRq+b to reboot.
>>
>> I tried to revert the above commit (bc71bec) on top of 2.6.25-rc1, but
>> the compilation fails. It turns out that I have to revert also
>> 9a0b8415 and 9b12e18c to be able to compile without errors. 
>>
>> After reverting the 3 commits mentioned above, the resulting
>> 2.6.25-rc1 kernel can suspend to RAM again (and I must say that it is
>> better that 2.6.24, because now it resumes directly into X and I
>> don't need to use Crtl-Alt-F1 and Alt-F7 to go back to X as I used to
>> do before).
>>
>> The laptop is a Core 2 Duo T7250 2.0 GHz, running Mandriva 2008.0 in
>> 64-bit mode, with the following graphics card:
>> VGA compatible controller: Intel Corporation Mobile GM965/GL960
>> Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA])
>>
>> If there is anything else I can do to help please let me know.
> 
> 
> this may be a BIOS bug; I'll let Venki dig into this ... but can you send the output of
> the dmidecode program to the list? If we need to start blacklisting bioses that information
> is going to be needed ;(

I am sending the dmidecode output attached (I erased the UUID).

Thanks for the prompt answer!






--------------010200070706090905020208
Content-Type: text/plain;
 name="dmidecode.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmidecode.txt"

# dmidecode 2.9
SMBIOS 2.4 present.
17 structures occupying 710 bytes.
Table at 0x000DC010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Phoenix Technologies LTD
	Version: R1120J7
	Release Date: 07/04/2007
	Address: 0xE6C60
	Runtime Size: 103328 bytes
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		8042 keyboard services are supported (int 9h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		AGP is supported
		Smart battery is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 12.0
	Firmware Revision: 12.0

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Sony Corporation
	Product Name: VGN-FZ240E
	Version: C60034YU
	Serial Number: 28209434-3041267
	UUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx
	Wake-up Type: Power Switch
	SKU Number: N/A
	Family: N/A

Handle 0x0002, DMI type 2, 10 bytes
Base Board Information
	Manufacturer: Sony Corporation
	Product Name: VAIO
	Version: N/A
	Serial Number: N/A

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: Sony Corporation
	Type: Notebook
	Lock: Not Present
	Version: N/A
	Serial Number: N/A
	Asset Tag: N/A
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: N/A
	Type: Central Processor
	Family: Other
	Manufacturer: GenuineIntel
	ID: FD 06 00 00 FF FB EB BF
	Version: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz
	Voltage: 1.2 V
	External Clock: 200 MHz
	Max Speed: 2000 MHz
	Current Speed: 2000 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: 0x0007
	Serial Number: N/A
	Asset Tag: N/A
	Part Number: N/A

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3 Cache
	Configuration: Disabled, Not Socketed, Level 3
	Operational Mode: Unknown
	Location: Unknown
	Installed Size: 0 KB
	Maximum Size: 0 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0008, DMI type 11, 5 bytes
OEM Strings
	String 1: 0000014327
	String 2: FNC-CCIA0gi9EXTB
	String 3: 03QJ00000000001D4448CD0160FF
	String 4: Reserved
	String 5: Reserved

Handle 0x0009, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 2048 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x000A, DMI type 17, 21 bytes
Memory Device
	Array Handle: 0x0009
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: SODIMM1
	Bank Locator: Bank 0
	Type: DDR2
	Type Detail: Unknown

Handle 0x000B, DMI type 17, 21 bytes
Memory Device
	Array Handle: 0x0009
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: SODIMM2
	Bank Locator: Bank 1
	Type: DDR2
	Type Detail: Unknown

Handle 0x000C, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x0009
	Partition Width: 0

Handle 0x000D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x000A
	Memory Array Mapped Address Handle: 0x000C
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x000E, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x000B
	Memory Array Mapped Address Handle: 0x000C
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x000F, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0010, DMI type 127, 4 bytes
End Of Table


--------------010200070706090905020208--
