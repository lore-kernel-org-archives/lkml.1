Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZJPUZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZJPUZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZJPUZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 16:25:13 -0400
Received: from lucidpixels.com ([75.144.35.66]:55851 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZJPUZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 16:25:12 -0400
Date: Fri, 16 Oct 2009 16:25:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jean Delvare <khali@linux-fr.org>
cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
  DP55KG motherboard? (chip ID: 0xb473)
In-Reply-To: <20091016215842.4573e816@hyperion.delvare>
Message-ID: <alpine.DEB.2.00.0910161624160.11211@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan> <alpine.DEB.2.00.0910140403150.15961@p34.internal.lan> <alpine.DEB.2.00.0910140856190.19307@p34.internal.lan> <20091015100557.22243433@hyperion.delvare> <alpine.DEB.2.00.0910150422400.21030@p34.internal.lan>
 <20091016111504.5d9cb0ba@hyperion.delvare> <alpine.DEB.2.00.0910160553221.2841@p34.internal.lan> <20091016125353.1c8795f4@hyperion.delvare> <alpine.DEB.2.00.0910160838500.31450@p34.internal.lan> <20091016204155.377fe67d@hyperion.delvare>
 <20091016215842.4573e816@hyperion.delvare>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Oct 2009, Jean Delvare wrote:

> On Fri, 16 Oct 2009 20:41:55 +0200, Jean Delvare wrote:
>> On Fri, 16 Oct 2009 09:40:51 -0400 (EDT), Justin Piszcz wrote:
>>> Ok, luckily it does not appear to have caused any issues:
>>>
>>> # i2cdump 0 0x2c b
>>> WARNING! This program can confuse your I2C bus, cause data loss and worse!
>>> I will probe file /dev/i2c-0, address 0x2c, mode byte
>>> Continue? [Y/n] y
>>>       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
>>> 00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
>>> 10: 00 00 00 00 00 00 00 00 00 00 80 80 80 04 7e 10    ..........????~?
>>> 20: 75 51 c0 c3 c3 80 28 2d bd 0f de 0f 3b 1d a9 16    uQ????(-????;???
>>> 30: 33 4d 4d c2 81 00 c2 00 ff ff ff e6 7b fb 41 6f    3MM??.?....?{?Ao
>>> 40: 35 90 40 00 00 ff 00 ff 00 ff 00 ff 00 ff 81 7f    5?@...........??
>>> 50: 81 7f 81 7f ff ff ff ff ff ff ff ff 0a a2 a2 ca    ????........????
>>> 60: 8a 8a e0 aa 33 4c 4c 5a 2d 2d 64 41 41 04 42 00    ????3LLZ--dAA?B.
>>> 70: 00 00 00 00 00 00 6c 60 f0 00 00 55 01 00 00 00    ......l`?..U?...
>>> 80: 00 00 00 00 00 00 ff ff 00 00 fb 64 64 64 00 00    ..........?ddd..
>>> 90: 00 59 59 59 00 00 00 00 00 00 00 00 00 00 00 00    .YYY............
>>> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
>>> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
>>> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
>>> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
>>> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
>>> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
>>> #
>>
>> Smells like an Analog Devices chip, but not one we know... And I can't
>> see it on the web site you mentioned. Please search for a small-size
>> chip named ADTxxxx (more likely ADT74xx).
>
> Ah, ADT7490. Please try:
>
> http://dl.lm-sensors.org/lm-sensors/files/sensors-detect
>
> We don't have support for that chip, but the datasheet suggests some
> form of compatibility with the ADT7473 and ADT7475, which we do have
> support for. So support for the ADT7490 is probably not too far away.
>
> The presence of this monitoring ASIC explains why the hardware
> monitoring features of the W83677HG super-I/O are disabled.
>
> -- 
> Jean Delvare
> http://khali.linux-fr.org/wishlist.html
>

Hi,

Cool.

# md5sum sensors-detect*
fa620c961858c633a7bb4559e3557217  sensors-detect
c7bca109121af547d2f9684174394530  sensors-detect.1

Here is the new run:

# ./sensors-detect.1 
# sensors-detect revision 5785 (2009-10-16 22:21:15 +0200)
# Board: Intel Corporation DP55KG

This program will help you determine which kernel modules you need
to load to use lm_sensors most effectively. It is generally safe
and recommended to accept the default answers to all questions,
unless you know what you're doing.

Some south bridges, CPUs or memory controllers contain embedded sensors.
Do you want to scan for them? This is totally safe. (YES/no): YES
Silicon Integrated Systems SIS5595...                       No
VIA VT82C686 Integrated Sensors...                          No
VIA VT8231 Integrated Sensors...                            No
AMD K8 thermal sensors...                                   No
AMD Family 11h thermal sensors...                           No
Intel Core family thermal sensor...                         No
Intel AMB FB-DIMM thermal sensor...                         No
VIA C7 thermal and voltage sensors...                       No

Some Super I/O chips contain embedded sensors. We have to write to
standard I/O ports to probe them. This is usually safe.
Do you want to scan for Super I/O sensors? (YES/no): YES
Probing for Super-I/O at 0x2e/0x2f
Trying family `National Semiconductor'...                   No
Trying family `SMSC'...                                     No
Trying family `VIA/Winbond/Nuvoton/Fintek'...               Yes
Found `Nuvoton W83677HG-I Super IO Sensors'
     (but no address specified)
Probing for Super-I/O at 0x4e/0x4f
Trying family `National Semiconductor'...                   No
Trying family `SMSC'...                                     No
Trying family `VIA/Winbond/Nuvoton/Fintek'...               No
Trying family `ITE'...                                      No

Some systems (mainly servers) implement IPMI, a set of common interfaces
through which system health data may be retrieved, amongst other things.
We first try to get the information from SMBIOS. If we don't find it
there, we have to read from arbitrary I/O ports to probe for such
interfaces. This is normally safe. Do you want to scan for IPMI
interfaces? (YES/no): YES
Probing for `IPMI BMC KCS' at 0xca0...                      No
Probing for `IPMI BMC SMIC' at 0xca8...                     No

Some hardware monitoring chips are accessible through the ISA I/O ports.
We have to write to arbitrary I/O ports to probe them. This is usually
safe though. Yes, you do have ISA I/O ports even if you do not have any
ISA slots! Do you want to scan the ISA I/O ports? (YES/no): YES
Probing for `National Semiconductor LM78' at 0x290...       No
Probing for `National Semiconductor LM79' at 0x290...       No
Probing for `Winbond W83781D' at 0x290...                   No
Probing for `Winbond W83782D' at 0x290...                   No

Lastly, we can probe the I2C/SMBus adapters for connected hardware
monitoring devices. This is the most risky part, and while it works
reasonably well on most systems, it has been reported to cause trouble
on some systems.
Do you want to probe the I2C/SMBus adapters now? (YES/no): YES
Found unknown SMBus adapter 8086:3b30 at 0000:00:1f.3.
Sorry, no supported PCI bus adapters found.

Next adapter: SMBus I801 adapter at 6000 (i2c-0)
Do you want to scan it? (YES/no/selectively): YES
Client found at address 0x2c
Probing for `Myson MTP008'...                               No
Probing for `National Semiconductor LM78'...                No
Probing for `National Semiconductor LM79'...                No
Probing for `National Semiconductor LM80'...                No
Probing for `National Semiconductor LM85'...                No
Probing for `National Semiconductor LM96000 or PC8374L'...  No
Probing for `Analog Devices ADM1027'...                     No
Probing for `Analog Devices ADT7460 or ADT7463'...          No
Probing for `SMSC EMC6D100 or EMC6D101'...                  No
Probing for `SMSC EMC6D102'...                              No
Probing for `SMSC EMC6D103'...                              No
Probing for `Winbond WPCD377I'...                           No
Probing for `Analog Devices ADT7470'...                     No
Probing for `Analog Devices ADT7476'...                     No
Probing for `Analog Devices ADT7490'...                     Success!
     (confidence 5, driver `to-be-written')
Probing for `Andigilog aSC7611'...                          No
Probing for `Andigilog aSC7621'...                          No
Probing for `National Semiconductor LM87'...                No
Probing for `Analog Devices ADM1024'...                     No
Probing for `National Semiconductor LM93'...                No
Probing for `Winbond W83781D'...                            No
Probing for `Winbond W83782D'...                            No
Probing for `Winbond W83791D'...                            No
Probing for `Winbond W83792D'...                            No
Probing for `Winbond W83793R/G'...                          No
Probing for `Nuvoton W83795G/ADG'...                        No
Probing for `Winbond W83627HF'...                           No
Probing for `Winbond W83627EHF'...                          No
Probing for `Winbond W83627DHG/W83667HG/W83677HG'...        No
Probing for `Asus AS99127F (rev.1)'...                      No
Probing for `Asus AS99127F (rev.2)'...                      No
Probing for `Asus ASB100 Bach'...                           No
Probing for `Genesys Logic GL518SM'...                      No
Probing for `Genesys Logic GL520SM'...                      No
Probing for `Analog Devices ADM9240'...                     No
Probing for `Dallas Semiconductor DS1780'...                No
Probing for `National Semiconductor LM81'...                No
Probing for `Analog Devices ADM1026'...                     No
Probing for `Analog Devices ADM1025'...                     No
Probing for `Philips NE1619'...                             No
Probing for `Analog Devices ADM1029'...                     No
Probing for `Analog Devices ADM1030'...                     No
Probing for `Analog Devices ADM1031'...                     No
Probing for `Analog Devices ADM1022'...                     No
Probing for `Texas Instruments THMC50'...                   No
Probing for `ITE IT8712F'...                                No
Probing for `ALi M5879'...                                  No
Probing for `SMSC LPC47M15x/192/292/997'...                 No
Probing for `SMSC DME1737'...                               No
Probing for `SMSC SCH5027D-NW'...                           No
Probing for `Winbond W83791SD'...                           No
Client found at address 0x2d
Probing for `Myson MTP008'...                               No
Probing for `National Semiconductor LM78'...                No
Probing for `National Semiconductor LM79'...                No
Probing for `National Semiconductor LM80'...                No
Probing for `National Semiconductor LM85'...                No
Probing for `National Semiconductor LM96000 or PC8374L'...  No
Probing for `Analog Devices ADM1027'...                     No
Probing for `Analog Devices ADT7460 or ADT7463'...          No
Probing for `SMSC EMC6D100 or EMC6D101'...                  No
Probing for `SMSC EMC6D102'...                              No
Probing for `SMSC EMC6D103'...                              No
Probing for `Winbond WPCD377I'...                           No
Probing for `Analog Devices ADT7476'...                     No
Probing for `Analog Devices ADT7490'...                     No
Probing for `Andigilog aSC7611'...                          No
Probing for `Andigilog aSC7621'...                          No
Probing for `National Semiconductor LM87'...                No
Probing for `Analog Devices ADM1024'...                     No
Probing for `National Semiconductor LM93'...                No
Probing for `Winbond W83781D'...                            No
Probing for `Winbond W83782D'...                            No
Probing for `Winbond W83783S'...                            No
Probing for `Winbond W83791D'...                            No
Probing for `Winbond W83792D'...                            No
Probing for `Winbond W83793R/G'...                          No
Probing for `Nuvoton W83795G/ADG'...                        No
Probing for `Winbond W83627HF'...                           No
Probing for `Winbond W83627EHF'...                          No
Probing for `Winbond W83627DHG/W83667HG/W83677HG'...        Success!
     (confidence 8, driver `use-isa-instead')
Probing for `Asus AS99127F (rev.1)'...                      No
Probing for `Asus AS99127F (rev.2)'...                      No
Probing for `Asus ASB100 Bach'...                           No
Probing for `Winbond W83L784R/AR/G'...                      No
Probing for `Winbond W83L785R/G'...                         No
Probing for `Genesys Logic GL518SM'...                      No
Probing for `Genesys Logic GL520SM'...                      No
Probing for `Genesys Logic GL525SM'...                      No
Probing for `Analog Devices ADM9240'...                     No
Probing for `Dallas Semiconductor DS1780'...                No
Probing for `National Semiconductor LM81'...                No
Probing for `Analog Devices ADM1026'...                     No
Probing for `Analog Devices ADM1025'...                     No
Probing for `Philips NE1619'...                             No
Probing for `Analog Devices ADM1029'...                     No
Probing for `Analog Devices ADM1030'...                     No
Probing for `Analog Devices ADM1031'...                     No
Probing for `Analog Devices ADM1022'...                     No
Probing for `Texas Instruments THMC50'...                   No
Probing for `VIA VT1211 (I2C)'...                           No
Probing for `ITE IT8712F'...                                No
Probing for `ALi M5879'...                                  No
Probing for `SMSC LPC47M15x/192/292/997'...                 No
Probing for `SMSC DME1737'...                               No
Probing for `SMSC SCH5027D-NW'...                           No
Probing for `Fintek F75373S/SG'...                          No
Probing for `Fintek F75375S/SP'...                          No
Probing for `Fintek F75387SG/RG'...                         No
Probing for `Winbond W83791SD'...                           No
Client found at address 0x48
Probing for `National Semiconductor LM75'...                No
Probing for `Dallas Semiconductor DS75'...                  No
Probing for `National Semiconductor LM77'...                No
Probing for `Dallas Semiconductor DS1621/DS1631'...         No
Probing for `Maxim MAX6650/MAX6651'...                      No
Probing for `National Semiconductor LM73'...                No
Probing for `National Semiconductor LM92'...                No
Probing for `National Semiconductor LM76'...                No
Probing for `Maxim MAX6633/MAX6634/MAX6635'...              No
Client found at address 0x50
Probing for `Analog Devices ADM1033'...                     No
Probing for `Analog Devices ADM1034'...                     No
Probing for `SPD EEPROM'...                                 No
Probing for `EDID EEPROM'...                                No
Client found at address 0x51
Probing for `Analog Devices ADM1033'...                     No
Probing for `Analog Devices ADM1034'...                     No
Probing for `SPD EEPROM'...                                 No
Client found at address 0x52
Probing for `Analog Devices ADM1033'...                     No
Probing for `Analog Devices ADM1034'...                     No
Probing for `SPD EEPROM'...                                 No
Client found at address 0x53
Probing for `Analog Devices ADM1033'...                     No
Probing for `Analog Devices ADM1034'...                     No
Probing for `SPD EEPROM'...                                 No

Now follows a summary of the probes I have just done.
Just press ENTER to continue:

Driver `to-be-written':
   * Bus `SMBus I801 adapter at 6000'
     Busdriver `i2c_i801', I2C address 0x2c
     Chip `Analog Devices ADT7490' (confidence: 5)

Note: there is no driver for Analog Devices ADT7490 yet.
Check http://www.lm-sensors.org/wiki/Devices for updates.

No modules to load, skipping modules configuration.

#

Justin.

