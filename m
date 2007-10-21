Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbXJUJtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbXJUJtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXJUJtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:49:45 -0400
Received: from m-04.th.seeweb.it ([217.64.195.227]:42723 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbXJUJto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:49:44 -0400
Message-ID: <471B1F44.5050801@users.sourceforge.net>
Date: Sun, 21 Oct 2007 11:43:32 +0200
From: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070908)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Laptop keyboard unusable when ACPI is active was Re: [2.6.22]
 i8042, ACPI, ipw2100 and issues reported by psmouse.c atkbd.c
References: <47001841.1000107@users.sourceforge.net> <470DD906.9090504@users.sourceforge.net> <20071018195202.GA6962@ucw.cz> <4719EAEB.6060703@users.sourceforge.net> <20071020183309.GB11373@elf.ucw.cz>
In-Reply-To: <20071020183309.GB11373@elf.ucw.cz>
Content-Type: multipart/mixed;
 boundary="------------020408080808030308090403"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020408080808030308090403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Pavel Machek ha scritto:
> Hi!
Hi!
>>> Try disabling acpi embedded controller.
>>>   
>>>       
>> How can I accomplish this? Are you referring to the i8042?
>>     
>
> rmmod acpi_ec or how is it called. But I'm not sure how easy this is.
>   
My lsmod doesn't list any acpi module - but I have kacpid, kacpi_listen
and hald-addon-acpi processes running.
I have compiled the kernel with embedded ACPI support, not modular -
maybe that's what you are talking about?

>   
>>> Try watching keyboard interrupts. Are they lost?
>>>   
>>>       
>> I am pretty sure they are. I think that ACPI pauses interrupts for a
>> while (100ms?) and so some keyboard interrupts are lost.
>>     
> input layer can poll keyboard on its own, perhaps that helps?
>   
I am not yet very good at kernel hacking - however yes, it gives me more
clues about identifying the issue (see also below link).

> Can you try to measure the interrupt latencies?
>   
I will try to do it myself, however somebody else the same problem of
mine has already made the tests, please see
http://dev.laptop.org/ticket/2401

> Does this happen in init=/bin/bash?
>   
I will perform a test, however the problem rarely verifies in a VT
console. I have tried both the kbd and keyboard drivers of X, without
any difference. The keyboard problem happens a lot more when plugging in
the battery (more ACPI traffic?).

I have emerged lm_sensors but can't get it running - it keeps saying "No
sensors found!" and complaining about kernel drivers not properly setup.
I have attached the output of sensors-detect, from which it seems that
the kernel is OK.

Thank you,
--
  Daniele

> 							Pavel
>
>   


--------------020408080808030308090403
Content-Type: text/x-log;
 name="sensors-detect.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sensors-detect.log"

# sensors-detect revision 4171 (2006-09-24 03:37:01 -0700)

This program will help you determine which kernel modules you need
to load to use lm_sensors most effectively. It is generally safe
and recommended to accept the default answers to all questions,
unless you know what you're doing.

We can start with probing for (PCI) I2C or SMBus adapters.
Do you want to probe now? (YES/no): Y
Probing for PCI bus adapters...
Use driver `i2c-i801' for device 0000:00:1f.3: Intel 82801DB ICH4

We will now try to load each adapter module in turn.
Module `i2c-i801' already loaded.
If you have undetectable or unsupported adapters, you can have them
scanned by manually loading the modules before running this script.

We are now going to do the I2C/SMBus adapter probings. Some chips may
be double detected; we choose the one with the highest confidence
value in that case.
If you found that the adapter hung after probing a certain address,
you can specify that address to remain unprobed.

Next adapter: SMBus I801 adapter at 1880
Do you want to scan it? (YES/no/selectively): Y
Client found at address 0x08
Client found at address 0x1a
Probing for `Analog Devices ADM1021'...                     No
Probing for `Analog Devices ADM1021A/ADM1023'...            No
Probing for `Maxim MAX1617'...                              No
Probing for `Maxim MAX1617A'...                             No
Probing for `TI THMC10'...                                  No
Probing for `National Semiconductor LM84'...                No
Probing for `Genesys Logic GL523SM'...                      No
Probing for `Onsemi MC1066'...                              No
Probing for `Maxim MAX1619'...                              No
Probing for `National Semiconductor LM82/LM83'...           No
Probing for `Philips Semiconductors PCA9556'...             No
Client found at address 0x44
Probing for `Maxim MAX6633/MAX6634/MAX6635'...              No
Client found at address 0x51
Handled by driver `eeprom' (already loaded), chip type `eeprom'
Client found at address 0x57
Handled by driver `eeprom' (already loaded), chip type `eeprom'
Client found at address 0x69

Some chips are also accessible through the ISA I/O ports. We have to
write to arbitrary I/O ports to probe them. This is usually safe though.
Yes, you do have ISA I/O ports even if you do not have any ISA slots!
Do you want to scan the ISA I/O ports? (YES/no): Y
Probing for `National Semiconductor LM78' at 0x290...       No
Probing for `National Semiconductor LM78-J' at 0x290...     No
Probing for `National Semiconductor LM79' at 0x290...       No
Probing for `Winbond W83781D' at 0x290...                   No
Probing for `Winbond W83782D' at 0x290...                   No
Probing for `Winbond W83627HF' at 0x290...                  No
Probing for `Silicon Integrated Systems SIS5595'...         No
Probing for `VIA VT82C686 Integrated Sensors'...            No
Probing for `VIA VT8231 Integrated Sensors'...              No
Probing for `AMD K8 thermal sensors'...                     No
Probing for `IPMI BMC KCS' at 0xca0...                      No
Probing for `IPMI BMC SMIC' at 0xca8...                     No

Some Super I/O chips may also contain sensors. We have to write to
standard I/O ports to probe them. This is usually safe.
Do you want to scan for Super I/O sensors? (YES/no): Y
Probing for Super-I/O at 0x2e/0x2f
Trying family `ITE'...                                      Yes
Found unknown chip with ID 0xea11
Trying family `National Semiconductor'...                   Yes
Found `Nat. Semi. PC8739x Super IO'                         
    (no hardware monitoring capabilities)
Trying family `SMSC'...                                     Yes
Found unknown chip with ID 0xea11
Trying family `VIA/Winbond/Fintek'...                       Yes
Found unknown chip with ID 0xea11
Probing for Super-I/O at 0x4e/0x4f
Trying family `ITE'...                                      No
Trying family `National Semiconductor'...                   No
Trying family `SMSC'...                                     No
Trying family `VIA/Winbond/Fintek'...                       No

Now follows a summary of the probes I have just done.
Just press ENTER to continue: 

Driver `eeprom' (should be inserted):
  Detects correctly:
  * Bus `SMBus I801 adapter at 1880'
    Busdriver `i2c-i801', I2C address 0x51
    Chip `eeprom' (confidence: 6)
  * Bus `SMBus I801 adapter at 1880'
    Busdriver `i2c-i801', I2C address 0x57
    Chip `eeprom' (confidence: 6)

  EEPROMs are *NOT* sensors! They are data storage chips commonly
  found on memory modules (SPD), in monitors (EDID), or in some
  laptops, for example.

I will now generate the commands needed to load the required modules.
Just press ENTER to continue:  


If you want to load the modules at startup, generate a config file
below and make sure lm_sensors gets started at boot time; e.g
$ rc-update add lm_sensors default
To make the sensors modules behave correctly, add these lines to
/etc/modules.d/lm_sensors and run modules-update:

#----cut here----
# I2C module options
alias char-major-89 i2c-dev
#----cut here----

If you have some drivers built into your kernel, the list above will
contain too many modules. Skip the appropriate ones! You really
should try these commands right now to make sure everything is
working properly. Monitoring programs won't work until the needed
modules are loaded.

To load everything that is needed, execute the commands below...

#----cut here----
# I2C adapter drivers
modprobe i2c-i801
# Chip drivers
modprobe eeprom
# sleep 2 # optional
/usr/bin/sensors -s # recommended
#----end cut here----

Do you want to overwrite /etc/conf.d/lm_sensors? Enter s to specify other file name?
  (yes/NO/s): Y
Done.

--------------020408080808030308090403--
