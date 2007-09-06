Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXIFH7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXIFH7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 03:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXIFH7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 03:59:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:30068 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbXIFH7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 03:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NoS2bwdGxf3xT9+xim6bK07EzrqlBv0sjorL+jib20M4ULhRRsBDVLqIgvViH03jUn1B294MUGUHHBYuDHGFSBhylnCQnJblPWGOYbn8wIS5IG+CR86v5Nfglmlb/QcOORqwYZ5+yYPQQe7hh07Jlh4BZunHCIeuUBEmUrJz50M=
Message-ID: <6278d2220709060059r604464fco2f5c341be29f5cd7@mail.gmail.com>
Date: Thu, 6 Sep 2007 08:59:28 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Mark Lord" <liml@rtr.ca>, "Andrey Panin" <pazke@donpac.ru>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: ICH Intel PATA short cable override...
Cc: "Tejun Heo" <htejun@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <46DF63F8.8070805@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com>
	 <20070906014209.142382c8@the-village.bc.nu> <46DF63F8.8070805@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/07, Mark Lord <liml@rtr.ca> wrote:
> Alan Cox wrote:
> > On Tue, 4 Sep 2007 13:37:22 +0100
> > "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
> >
> >> We see that in ata_piix.c, there is a whitelist for (laptop) Intel ICH
> >> controllers with short cables, tied to specific vendor subsystem IDs.
> >> Since my mini-ITX Ibase MI910F has the subsystem IDs specified as
> >> Intel [1], this is unusable.
> >>
> >> I can't find another existing mechanism to add short cable
> >> information, to allow UDMA/66 for my on-board CF socket.
> >
> > DMI is the other approach (if your box has sane responses to the
> > dmidecode command we can do this).
>
> No, something more flexible is needed here.
>
> For example, I have a Mini-ITX server here, which I personally have
> equipped with a 3" 40W IDE cable that connects to a notebook drive.
>
> The system currently uses UDMA just fine with the IDE drivers,
> but I have not been able to convert it to use the (stock) libata drivers
> because of this silly lack of end-user control.
>
> We really need an override for this -- embedded folks would also apprecaate one.
> Ditto for selecting transfer modes.
>
> Cheers

Thanks for the great suggestions guys. The only useful DMI information
the manufacturer has encoded [1], is the base board model name
('Crestline' here). This feels too generic to use, but the combination
of no vendor name and the 'Crestline' model name may be specific
enough, perhaps?

I do agree with Mark that there should be some override, for normal
PATA ports (as opposed to on-mobo sockets), since the user chooses the
cable. Perhaps we need a port mask in the DMI whitelist too, and a
port-general/specific override mechanism?

Daniel

--- [1]

# dmidecode
SMBIOS 2.3 present.
33 structures occupying 926 bytes.
Table at 0x000F0800.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
        Vendor: Phoenix Technologies, LTD
        Version: 6.00 PG
        Release Date: 05/14/2007
        Address: 0xE0000
        Runtime Size: 128 kB
        ROM Size: 1024 kB
        Characteristics:
                ISA is supported
                PCI is supported
                PNP is supported
                APM is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                ESCD support is available
                Boot from CD is supported
                Selectable boot is supported
                BIOS ROM is socketed
                EDD is supported
                5.25"/360 KB floppy services are supported (int 13h)
                5.25"/1.2 MB floppy services are supported (int 13h)
                3.5"/720 KB floppy services are supported (int 13h)
                3.5"/2.88 MB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Serial services are supported (int 14h)
                Printer services are supported (int 17h)
                CGA/mono video services are supported (int 10h)
                ACPI is supported
                USB legacy is supported
                LS-120 boot is supported
                ATAPI Zip drive boot is supported
                BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
        Manufacturer: OEM
        Product Name: OEM
        Version: OEM
        Serial Number: OEM
        UUID: Not Present
        Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 10 bytes
Base Board Information
        Manufacturer: Unknown
        Product Name: Crestline
        Version: Unknown
        Serial Number:

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
        Manufacturer: OEM
        Type: Desktop
        Lock: Not Present
        Version: OEM
        Serial Number:
        Asset Tag:
        Boot-up State: Unknown
        Power Supply State: Unknown
        Thermal State: Unknown
        Security Status: Unknown
        OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
        Socket Designation: Socket 423
        Type: Central Processor
        Family: Other
        Manufacturer: Intel
        ID: FA 06 00 00 FF FB EB BF
        Version: Intel(R)
        Voltage: 0.0 V
        External Clock: 200 MHz
        Max Speed: 4000 MHz
        Current Speed: 2000 MHz
        Status: Populated, Enabled
        Upgrade: ZIF Socket
        L1 Cache Handle: 0x0008
        L2 Cache Handle: 0x0009
        L3 Cache Handle: Not Provided
        Serial Number:
        Asset Tag:
        Part Number:

Handle 0x0005, DMI type 5, 20 bytes
Memory Controller Information
        Error Detecting Method: 8-bit Parity
        Error Correcting Capabilities:
                None
        Supported Interleave: One-way Interleave
        Current Interleave: One-way Interleave
        Maximum Memory Module Size: 2048 MB
        Maximum Total Memory Size: 4096 MB
        Supported Speeds:
                Other
        Supported Memory Types:
                DIMM
        Memory Module Voltage: 5.0 V
        Associated Memory Slots: 2
                0x0006
                0x0007
        Enabled Error Correcting Capabilities:
                None

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: A0
        Bank Connections: 0 1
        Current Speed: Unknown
        Type: DIMM
        Installed Size: 1024 MB (Double-bank Connection)
        Enabled Size: 1024 MB (Double-bank Connection)
        Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: A1
        Bank Connections: None
        Current Speed: Unknown
        Type: Unknown
        Installed Size: Not Installed
        Enabled Size: Not Installed
        Error Status: OK

Handle 0x0008, DMI type 7, 19 bytes
Cache Information
        Socket Designation: Internal Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 32 KB
        Maximum Size: 32 KB
        Supported SRAM Types:
                Synchronous
        Installed SRAM Type: Synchronous
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x0009, DMI type 7, 19 bytes
Cache Information
        Socket Designation: External Cache
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Write Back
        Location: External
        Installed Size: 4096 KB
        Maximum Size: 4096 KB
        Supported SRAM Types:
                Synchronous
        Installed SRAM Type: Synchronous
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: PRIMARY IDE
        Internal Connector Type: On Board IDE
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: SECONDARY IDE
        Internal Connector Type: On Board IDE
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: FDD
        Internal Connector Type: On Board Floppy
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: 8251 FIFO Compatible

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: COM1
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator:
        External Connector Type: DB-9 male
        Port Type: Serial Port 16450 Compatible

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: COM2
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator:
        External Connector Type: DB-9 male
        Port Type: Serial Port 16450 Compatible

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: LPT1
        Internal Connector Type: DB-25 female
        External Reference Designator:
        External Connector Type: DB-25 female
        Port Type: Parallel Port ECP/EPP

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Keyboard
        Internal Connector Type: PS/2
        External Reference Designator:
        External Connector Type: PS/2
        Port Type: Keyboard Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: PS/2 Mouse
        Internal Connector Type: PS/2
        External Reference Designator:
        External Connector Type: PS/2
        Port Type: Mouse Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB0
        External Connector Type: Other
        Port Type: USB

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB1
        External Connector Type: Other
        Port Type: USB

Handle 0x0014, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI0
        Type: 32-bit PCI
        Current Usage: Available
        Length: Long
        ID: 1
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0015, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI1
        Type: 32-bit PCI
        Current Usage: Available
        Length: Long
        ID: 2
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0016, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI2
        Type: 32-bit PCI
        Current Usage: In Use
        Length: Long
        ID: 3
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0017, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI3
        Type: 32-bit PCI
        Current Usage: In Use
        Length: Long
        ID: 4
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0018, DMI type 13, 22 bytes
BIOS Language Information
        Installable Languages: 3
                n|US|iso8859-1
                n|US|iso8859-1
                r|CA|iso8859-1
        Currently Installed Language: n|US|iso8859-1

Handle 0x0019, DMI type 16, 15 bytes
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 2 GB
        Error Information Handle: Not Provided
        Number Of Devices: 2

Handle 0x001A, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0019
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: None
        Locator: A0
        Bank Locator: Bank0/1
        Type: Unknown
        Type Detail: Synchronous
        Speed: Unknown
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001B, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0019
        Error Information Handle: Not Provided
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: DIMM
        Set: None
        Locator: A1
        Bank Locator: Bank2/3
        Type: Unknown
        Type Detail: Unknown
        Speed: Unknown
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x001C, DMI type 19, 15 bytes
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0003FFFFFFF
        Range Size: 1 GB
        Physical Array Handle: 0x0019
        Partition Width: 0

Handle 0x001D, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0003FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x001A
        Memory Array Mapped Address Handle: 0x001C
        Partition Row Position: 1

Handle 0x001E, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x000000003FF
        Range Size: 1 kB
        Physical Device Handle: 0x001B
        Memory Array Mapped Address Handle: 0x001C
        Partition Row Position: 1

Handle 0x001F, DMI type 32, 11 bytes
System Boot Information
        Status: No errors detected

Handle 0x0020, DMI type 127, 4 bytes
End Of Table
-- 
Daniel J Blueman
