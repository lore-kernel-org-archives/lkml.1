Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbZJNN0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbZJNN0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbZJNN0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:26:07 -0400
Received: from lucidpixels.com ([75.144.35.66]:48586 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142AbZJNN0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:26:01 -0400
Date: Wed, 14 Oct 2009 09:25:25 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Robert Hancock <hancockrwd@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       nut-upsuser@lists.alioth.debian.org
Subject: Re: [Nut-upsuser] USB/UPS connectivity issue on Intel DP55KG
 Motherboard [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <alpine.DEB.2.00.0910140359070.15961@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910140904110.19307@p34.internal.lan>
References: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan> <4AD51C4E.1090204@gmail.com> <alpine.DEB.2.00.0910140359070.15961@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have included debugging logs-- see below, is this a nut or kernel/USB 
subsystem issue?

There are no kernel messages in dmesg/syslog that relate to this event. 
The same exact hardware was used on a different motherboard (DG965WH) 
without any problems.

Justin.

On Wed, 14 Oct 2009, Justin Piszcz wrote:

> On Tue, 13 Oct 2009, Robert Hancock wrote:
>
>> On 10/13/2009 03:55 PM, Justin Piszcz wrote:
>>> Hello,
>>> 
>>> I use the following in my ups.conf:
>>> 
>>> # USB:
>>> [apc]
>>> driver = usbhid-ups
>>> port = auto
>>> desc = "APC 1500VA"
>>> pollfreq = 5
>>> 
>>> On my new motherboard (an Intel DP55KG), every once and awhile I get this:
>>> 
>>> Broadcast Message from nut@box.com
>>> (somewhere) at 17:48 ...
>>> 
>>> Communications with UPS apc@localhost lost
>>> 
>>> 
>>> Broadcast Message from nut@box.com
>>> (somewhere) at 17:48 ...
>>> 
>>> Communications with UPS apc@localhost established
>>> 
>>> On my previous motherboard (a DG965WH), the exact same configuration was
>>> used
>>> and I never had this issue.
>>> 
>>> Any hints?
>>> 
>>> Should I increase the pollfreq to say 30 seconds?
>>> 
>>> Would this 'workaround' the problem?
>>> 
>>> Is this a known bug on this chipset?
>> 
>> Anything unusual showing up in dmesg?
>> 
>

Robert/Nut User List--

Looks like the data goes stale, please let me know if any more 
logs/debugging is required, is this a kernel/usb problem or a nut issue? 
I recall a change in the USB subsystem a few kernel versions back caused a 
different issue (on a different UPS, but nevertheless it was kernel 
related).

The following output before/during/after the lost connection:

1. upsmon -DDDDDDDDDDDDDD

polling ups: apc@localhost
get_var: apc@localhost / status
      status: [OL]
     parsing: [OL]: ups_on_line(apc@localhost) (no change)

polling ups: apc@localhost
get_var: apc@localhost / status
Poll UPS [apc@localhost] failed - Data stale
do_notify: ntype 0x0005 (COMMBAD)
Communications with UPS apc@localhost lost
polling ups: apc@localhost
get_var: apc@localhost / status
      status: [OL]
do_notify: ntype 0x0004 (COMMOK)
Communications with UPS apc@localhost established
     parsing: [OL]: ups_on_line(apc@localhost) (no change)

polling ups: apc@localhost
get_var: apc@localhost / status
      status: [OL]
     parsing: [OL]: ups_on_line(apc@localhost) (no change)

2. upsd -DDDDDDDDDDD

Pinging UPS [apc]
mainloop: polling 3 filedescriptors
Got PONG from UPS [apc]
mainloop: polling 3 filedescriptors
write: [destfd=6] [len=24] [VAR apc ups.status "OL"]
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
write: [destfd=6] [len=24] [VAR apc ups.status "OL"]
Pinging UPS [apc]
mainloop: polling 3 filedescriptors
Got PONG from UPS [apc]
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
sstate_dead: driver for UPS [apc] says data is stale
Data for UPS [apc] is stale - check driver
mainloop: polling 3 filedescriptors
mainloop: no data available
sstate_dead: driver for UPS [apc] says data is stale
mainloop: polling 3 filedescriptors
Sending error [DATA-STALE] to client 127.0.0.1
write: [destfd=6] [len=15] [ERR DATA-STALE]
sstate_dead: driver for UPS [apc] says data is stale
mainloop: polling 3 filedescriptors
mainloop: no data available
sstate_dead: driver for UPS [apc] says data is stale
mainloop: polling 3 filedescriptors
UPS [apc] data is no longer stale
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
write: [destfd=6] [len=24] [VAR apc ups.status "OL"]
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
write: [destfd=6] [len=24] [VAR apc ups.status "OL"]
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
mainloop: no data available
Pinging UPS [apc]
mainloop: polling 3 filedescriptors
Got PONG from UPS [apc]

3. /lib/nut/usbhid-ups -a apc -i 5 -u nut -DDDDDDDD

Scroll down ~149 lines to where the problem occurs, before this, all is OK:

  149 = device has been disconnected, try to reconnect =

It takes roughly 3-5 minutes until this problem occurs.

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Discharging, Type: Feature, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Entering libusb_get_report
Report[get]: (2 bytes) => 13 01
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ACPresent, Type: Feature, ReportID: 0x13, Offset: 0, Size: 8, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Entering libusb_get_report
Report[get]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x14, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.APCStatusFlag, Type: Feature, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
send_to_one: PONG
upsdrv_updateinfo...
  ok
Report[int]: (4 bytes) => 06 00 00 08
Got 3 HID objects...
Entering libusb_get_report
Report[get]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850044 -> Charging
Path: UPS.PowerSummary.Charging, Type: Input, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850045 -> Discharging
Path: UPS.PowerSummary.Discharging, Type: Input, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: ff860060 -> APCStatusFlag
Path: UPS.PowerSummary.APCStatusFlag, Type: Input, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Full update...
Entering libusb_get_report
Report[get]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.RemainingCapacity, Type: Feature, ReportID: 0x0c, Offset: 0, Size: 8, Value: 100.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 0f 32
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.WarningCapacityLimit, Type: Feature, ReportID: 0x0f, Offset: 0, Size: 8, Value: 50.000000
Report[buf]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.RunTimeToEmpty, Type: Feature, ReportID: 0x0c, Offset: 8, Size: 16, Value: 1484.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 09 4d 0a
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.PowerSummary.Voltage, Type: Feature, ReportID: 0x09, Offset: 0, Size: 16, Value: 26.370000
Entering libusb_get_report
Report[get]: (3 bytes) => 25 60 09
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Battery.ConfigVoltage, Type: Feature, ReportID: 0x25, Offset: 0, Size: 16, Value: 24.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 03 04
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.iDeviceChemistry, Type: Feature, ReportID: 0x03, Offset: 0, Size: 8, Value: 4.000000
hu_find_infoval: searching for value = 4

-> String: PbAc (len = 4/20)
hu_find_infoval: found PbAc (value: 4)

Entering libusb_get_report
Report[get]: (3 bytes) => 20 be 38
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.ManufacturerDate, Type: Feature, ReportID: 0x20, Offset: 0, Size: 16, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2008/05/30 (value: 14526)

Entering libusb_get_report
refresh_report_buffer: expected 4 bytes, but got only 3
Report[get]: (4 bytes) => 1c be 38 00
PhyMax = 0, PhyMin = 0, LogMax = 16777215, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.APCBattReplaceDate, Type: Feature, ReportID: 0x1c, Offset: 0, Size: 24, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2024/00/38 (value: 14526)

Entering libusb_get_report
Report[get]: (2 bytes) => 50 16
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerConverter.PercentLoad, Type: Feature, ReportID: 0x50, Offset: 0, Size: 8, Value: 22.000000
Entering libusb_get_report
Can't retrieve Report 21: Broken pipe
send_to_one: PONG
upsdrv_updateinfo...
Got to reconnect!

==================================================
= device has been disconnected, try to reconnect =
==================================================
Checking device (0461/4D15) (001/005)
- VendorID: 0461
- ProductID: 4d15
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (413C/2002) (001/004)
- VendorID: 413c
- ProductID: 2002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (413C/1002) (001/003)
- VendorID: 413c
- ProductID: 1002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (8087/0020) (001/002)
- VendorID: 8087
- ProductID: 0020
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (1D6B/0002) (001/001)
- VendorID: 1d6b
- ProductID: 0002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (0A12/0001) (002/003)
- VendorID: 0a12
- ProductID: 0001
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 002
Trying to match device
Device does not match - skipping
Checking device (8087/0020) (002/002)
- VendorID: 8087
- ProductID: 0020
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 002
Trying to match device
Device does not match - skipping
Checking device (1D6B/0002) (002/001)
- VendorID: 1d6b
- ProductID: 0002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 002
Trying to match device
Device does not match - skipping
Checking device (051D/0002) (002/004)
- VendorID: 051d
- ProductID: 0002
- Manufacturer: American Power Conversion
- Product: unknown
- Serial Number: 8B0822R34475 
- Bus: 002
Trying to match device
Device does not match - skipping
No appropriate HID device found
send_to_all: DATASTALE
upsdrv_updateinfo...
Got to reconnect!

==================================================
= device has been disconnected, try to reconnect =
==================================================
Checking device (0461/4D15) (001/005)
- VendorID: 0461
- ProductID: 4d15
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (413C/2002) (001/004)
- VendorID: 413c
- ProductID: 2002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (413C/1002) (001/003)
- VendorID: 413c
- ProductID: 1002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (8087/0020) (001/002)
- VendorID: 8087
- ProductID: 0020
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (1D6B/0002) (001/001)
- VendorID: 1d6b
- ProductID: 0002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 001
Trying to match device
Device does not match - skipping
Checking device (0A12/0001) (002/003)
- VendorID: 0a12
- ProductID: 0001
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 002
Trying to match device
Device does not match - skipping
Checking device (8087/0020) (002/002)
- VendorID: 8087
- ProductID: 0020
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 002
Trying to match device
Device does not match - skipping
Checking device (1D6B/0002) (002/001)
- VendorID: 1d6b
- ProductID: 0002
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 002
Trying to match device
Device does not match - skipping
Checking device (051D/0002) (002/004)
- VendorID: 051d
- ProductID: 0002
- Manufacturer: American Power Conversion
- Product: Back-UPS RS 1500 LCD FW:839.H7 .D USB FW:H7 
- Serial Number: 8B0822R34475 
- Bus: 002
Trying to match device
Device matches
failed to claim USB device: could not claim interface 0: Device or resource busy
detached kernel driver from USB device...
Entering libusb_get_report
Report[get]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.RemainingCapacity, Type: Feature, ReportID: 0x0c, Offset: 0, Size: 8, Value: 100.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 11 0a
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.RemainingCapacityLimit, Type: Feature, ReportID: 0x11, Offset: 0, Size: 8, Value: 10.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 0f 32
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.WarningCapacityLimit, Type: Feature, ReportID: 0x0f, Offset: 0, Size: 8, Value: 50.000000
Report[buf]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.RunTimeToEmpty, Type: Feature, ReportID: 0x0c, Offset: 8, Size: 16, Value: 1484.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 17 78 00
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.RemainingTimeLimit, Type: Feature, ReportID: 0x17, Offset: 0, Size: 16, Value: 120.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 09 4d 0a
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.PowerSummary.Voltage, Type: Feature, ReportID: 0x09, Offset: 0, Size: 16, Value: 26.370000
Entering libusb_get_report
Report[get]: (3 bytes) => 25 60 09
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Battery.ConfigVoltage, Type: Feature, ReportID: 0x25, Offset: 0, Size: 16, Value: 24.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: ConfigVoltage -> 00840040
string_to_path: depth = 3
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: Battery -> 00840012
hid_lookup_usage: Temperature -> 00840036
string_to_path: depth = 3
Entering libusb_get_report
Report[get]: (2 bytes) => 03 04
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.iDeviceChemistry, Type: Feature, ReportID: 0x03, Offset: 0, Size: 8, Value: 4.000000
hu_find_infoval: searching for value = 4

-> String: PbAc (len = 4/20)
hu_find_infoval: found PbAc (value: 4)

Entering libusb_get_report
Report[get]: (3 bytes) => 20 be 38
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.ManufacturerDate, Type: Feature, ReportID: 0x20, Offset: 0, Size: 16, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2008/05/30 (value: 14526)

hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: APCBattReplaceDate -> ff860016
string_to_path: depth = 3
Entering libusb_get_report
refresh_report_buffer: expected 4 bytes, but got only 3
Report[get]: (4 bytes) => 1c be 38 00
PhyMax = 0, PhyMin = 0, LogMax = 16777215, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.APCBattReplaceDate, Type: Feature, ReportID: 0x1c, Offset: 0, Size: 24, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2024/00/38 (value: 14526)

hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: Output -> 0084001c
hid_lookup_usage: PercentLoad -> 00840035
string_to_path: depth = 3
Entering libusb_get_report
Report[get]: (2 bytes) => 50 16
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerConverter.PercentLoad, Type: Feature, ReportID: 0x50, Offset: 0, Size: 8, Value: 22.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: DelayBeforeStartup -> 00840056
string_to_path: depth = 3
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: APCGeneralCollection -> ff860005
hid_lookup_usage: APCDelayBeforeStartup -> ff86007e
string_to_path: depth = 3
Entering libusb_get_report
Report[get]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 41 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeShutdown, Type: Feature, ReportID: 0x41, Offset: 0, Size: 16, Value: -1.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: DelayBeforeStartup -> 00840056
string_to_path: depth = 3
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: APCGeneralCollection -> ff860005
hid_lookup_usage: APCDelayBeforeStartup -> ff86007e
string_to_path: depth = 3
Report[buf]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: APCGeneralCollection -> ff860005
hid_lookup_usage: APCDelayBeforeShutdown -> ff86007d
string_to_path: depth = 3
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: DelayBeforeReboot -> 00840055
string_to_path: depth = 3
Entering libusb_get_report
Report[get]: (2 bytes) => 40 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeReboot, Type: Feature, ReportID: 0x40, Offset: 0, Size: 8, Value: 0.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 21 06
PhyMax = 0, PhyMin = 0, LogMax = 6, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.Test, Type: Feature, ReportID: 0x21, Offset: 0, Size: 8, Value: 6.000000
hu_find_infoval: searching for value = 6

hu_find_infoval: found No test initiated (value: 6)

Entering libusb_get_report
Report[get]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
hu_find_infoval: searching for value = 2

hu_find_infoval: found enabled (value: 2)

Entering libusb_get_report
Report[get]: (3 bytes) => 7b be 38
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.ManufacturerDate, Type: Feature, ReportID: 0x7b, Offset: 0, Size: 16, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2008/05/30 (value: 14526)

hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: ManufacturerDate -> 00850085
string_to_path: depth = 3
Entering libusb_get_report
refresh_report_buffer: expected 5 bytes, but got only 3
Report[get]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ACPresent, Type: Feature, ReportID: 0x16, Offset: 2, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Discharging, Type: Feature, ReportID: 0x16, Offset: 1, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Charging, Type: Feature, ReportID: 0x16, Offset: 0, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ShutdownImminent, Type: Feature, ReportID: 0x16, Offset: 5, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !shutdownimm (value: 0)

process_boolean_info: !shutdownimm
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x16, Offset: 4, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Overload, Type: Feature, ReportID: 0x16, Offset: 9, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !overload (value: 0)

process_boolean_info: !overload
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.NeedReplacement, Type: Feature, ReportID: 0x16, Offset: 8, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !replacebatt (value: 0)

process_boolean_info: !replacebatt
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.RemainingTimeLimitExpired, Type: Feature, ReportID: 0x16, Offset: 6, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !timelimitexp (value: 0)

process_boolean_info: !timelimitexp
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BatteryPresent, Type: Feature, ReportID: 0x16, Offset: 3, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found !nobattery (value: 1)

process_boolean_info: !nobattery
Entering libusb_get_report
Report[get]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Charging, Type: Feature, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Discharging, Type: Feature, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Entering libusb_get_report
Report[get]: (2 bytes) => 13 01
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ACPresent, Type: Feature, ReportID: 0x13, Offset: 0, Size: 8, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Entering libusb_get_report
Report[get]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x14, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ShutdownImminent, Type: Feature, ReportID: 0x14, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !shutdownimm (value: 0)

process_boolean_info: !shutdownimm
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.APCStatusFlag, Type: Feature, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Entering libusb_get_report
Report[get]: (3 bytes) => 31 7a 00
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.Voltage, Type: Feature, ReportID: 0x31, Offset: 0, Size: 16, Value: 122.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 30 78
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.ConfigVoltage, Type: Feature, ReportID: 0x30, Offset: 0, Size: 8, Value: 120.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 32 58 00
PhyMax = 0, PhyMin = 0, LogMax = 88, LogMin = 78
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.LowVoltageTransfer, Type: Feature, ReportID: 0x32, Offset: 0, Size: 16, Value: 88.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 33 8b 00
PhyMax = 0, PhyMin = 0, LogMax = 142, LogMin = 136
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.HighVoltageTransfer, Type: Feature, ReportID: 0x33, Offset: 0, Size: 16, Value: 139.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: Output -> 0084001c
hid_lookup_usage: Voltage -> 00840030
string_to_path: depth = 3
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: Output -> 0084001c
hid_lookup_usage: ConfigVoltage -> 00840040
string_to_path: depth = 3
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: APCEnvironment -> ff860006
hid_lookup_usage: APCProbe1 -> ff860007
hid_lookup_usage: Temperature -> 00840036
string_to_path: depth = 4
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: APCEnvironment -> ff860006
hid_lookup_usage: APCProbe1 -> ff860007
hid_lookup_usage: Humidity -> 00840037
string_to_path: depth = 4
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: BatterySystem -> 00840010
hid_lookup_usage: Battery -> 00840012
hid_lookup_usage: Test -> 00840058
string_to_path: depth = 4
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: BatterySystem -> 00840010
hid_lookup_usage: Battery -> 00840012
hid_lookup_usage: Test -> 00840058
string_to_path: depth = 4
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: BatterySystem -> 00840010
hid_lookup_usage: Battery -> 00840012
hid_lookup_usage: Test -> 00840058
string_to_path: depth = 4
Entering libusb_get_report
Report[get]: (2 bytes) => 79 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCPanelTest, Type: Feature, ReportID: 0x79, Offset: 0, Size: 8, Value: 0.000000
Report[buf]: (2 bytes) => 79 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCPanelTest, Type: Feature, ReportID: 0x79, Offset: 0, Size: 8, Value: 0.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: APCPanelTest -> ff860072
string_to_path: depth = 3
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: APCPanelTest -> ff860072
string_to_path: depth = 3
Report[buf]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: DelayBeforeStartup -> 00840056
string_to_path: depth = 3
Report[buf]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: PowerSummary -> 00840024
hid_lookup_usage: DelayBeforeReboot -> 00840055
string_to_path: depth = 3
Report[buf]: (3 bytes) => 41 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeShutdown, Type: Feature, ReportID: 0x41, Offset: 0, Size: 16, Value: -1.000000
hid_lookup_usage: UPS -> 00840004
hid_lookup_usage: APCGeneralCollection -> ff860005
hid_lookup_usage: APCDelayBeforeStartup -> ff86007e
string_to_path: depth = 3
Report[buf]: (3 bytes) => 41 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeShutdown, Type: Feature, ReportID: 0x41, Offset: 0, Size: 16, Value: -1.000000
Report[buf]: (2 bytes) => 40 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeReboot, Type: Feature, ReportID: 0x40, Offset: 0, Size: 8, Value: 0.000000
Report[buf]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
Report[buf]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
Report[buf]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
Report[buf]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
Report[buf]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
  ok
Report[int]: (4 bytes) => 06 00 00 08
Got 3 HID objects...
Entering libusb_get_report
Report[get]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850044 -> Charging
Path: UPS.PowerSummary.Charging, Type: Input, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850045 -> Discharging
Path: UPS.PowerSummary.Discharging, Type: Input, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: ff860060 -> APCStatusFlag
Path: UPS.PowerSummary.APCStatusFlag, Type: Input, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Quick update...
Report[buf]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
Report[buf]: (2 bytes) => 40 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeReboot, Type: Feature, ReportID: 0x40, Offset: 0, Size: 8, Value: 0.000000
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ACPresent, Type: Feature, ReportID: 0x16, Offset: 2, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Discharging, Type: Feature, ReportID: 0x16, Offset: 1, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Charging, Type: Feature, ReportID: 0x16, Offset: 0, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x16, Offset: 4, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Charging, Type: Feature, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Discharging, Type: Feature, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (2 bytes) => 13 01
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ACPresent, Type: Feature, ReportID: 0x13, Offset: 0, Size: 8, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Report[buf]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x14, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.APCStatusFlag, Type: Feature, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
send_to_all: DATAOK
upsdrv_updateinfo...
  ok
Report[int]: (4 bytes) => 0c 64 cc 05
Got 2 HID objects...
Entering libusb_get_report
Report[get]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850066 -> RemainingCapacity
Path: UPS.PowerSummary.RemainingCapacity, Type: Input, ReportID: 0x0c, Offset: 0, Size: 8, Value: 100.000000
Report[buf]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00001001 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850068 -> RunTimeToEmpty
Path: UPS.PowerSummary.RunTimeToEmpty, Type: Input, ReportID: 0x0c, Offset: 8, Size: 16, Value: 1484.000000
Full update...
Report[buf]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.RemainingCapacity, Type: Feature, ReportID: 0x0c, Offset: 0, Size: 8, Value: 100.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 0f 32
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.WarningCapacityLimit, Type: Feature, ReportID: 0x0f, Offset: 0, Size: 8, Value: 50.000000
Report[buf]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.RunTimeToEmpty, Type: Feature, ReportID: 0x0c, Offset: 8, Size: 16, Value: 1484.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 09 3c 0a
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.PowerSummary.Voltage, Type: Feature, ReportID: 0x09, Offset: 0, Size: 16, Value: 26.200000
send_to_all: SETINFO battery.voltage "26.2"
Entering libusb_get_report
Report[get]: (3 bytes) => 25 60 09
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Battery.ConfigVoltage, Type: Feature, ReportID: 0x25, Offset: 0, Size: 16, Value: 24.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 03 04
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.iDeviceChemistry, Type: Feature, ReportID: 0x03, Offset: 0, Size: 8, Value: 4.000000
hu_find_infoval: searching for value = 4

-> String: PbAc (len = 4/20)
hu_find_infoval: found PbAc (value: 4)

Entering libusb_get_report
Report[get]: (3 bytes) => 20 be 38
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.ManufacturerDate, Type: Feature, ReportID: 0x20, Offset: 0, Size: 16, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2008/05/30 (value: 14526)

Entering libusb_get_report
refresh_report_buffer: expected 4 bytes, but got only 3
Report[get]: (4 bytes) => 1c be 38 00
PhyMax = 0, PhyMin = 0, LogMax = 16777215, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.APCBattReplaceDate, Type: Feature, ReportID: 0x1c, Offset: 0, Size: 24, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2024/00/38 (value: 14526)

Entering libusb_get_report
Report[get]: (2 bytes) => 50 16
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerConverter.PercentLoad, Type: Feature, ReportID: 0x50, Offset: 0, Size: 8, Value: 22.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 40 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeReboot, Type: Feature, ReportID: 0x40, Offset: 0, Size: 8, Value: 0.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 21 06
PhyMax = 0, PhyMin = 0, LogMax = 6, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.Test, Type: Feature, ReportID: 0x21, Offset: 0, Size: 8, Value: 6.000000
hu_find_infoval: searching for value = 6

hu_find_infoval: found No test initiated (value: 6)

Entering libusb_get_report
Report[get]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
hu_find_infoval: searching for value = 2

hu_find_infoval: found enabled (value: 2)

Entering libusb_get_report
Report[get]: (3 bytes) => 7b be 38
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.ManufacturerDate, Type: Feature, ReportID: 0x7b, Offset: 0, Size: 16, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2008/05/30 (value: 14526)

Entering libusb_get_report
refresh_report_buffer: expected 5 bytes, but got only 3
Report[get]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ACPresent, Type: Feature, ReportID: 0x16, Offset: 2, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Discharging, Type: Feature, ReportID: 0x16, Offset: 1, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Charging, Type: Feature, ReportID: 0x16, Offset: 0, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ShutdownImminent, Type: Feature, ReportID: 0x16, Offset: 5, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !shutdownimm (value: 0)

process_boolean_info: !shutdownimm
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x16, Offset: 4, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Overload, Type: Feature, ReportID: 0x16, Offset: 9, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !overload (value: 0)

process_boolean_info: !overload
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.NeedReplacement, Type: Feature, ReportID: 0x16, Offset: 8, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !replacebatt (value: 0)

process_boolean_info: !replacebatt
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.RemainingTimeLimitExpired, Type: Feature, ReportID: 0x16, Offset: 6, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !timelimitexp (value: 0)

process_boolean_info: !timelimitexp
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BatteryPresent, Type: Feature, ReportID: 0x16, Offset: 3, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found !nobattery (value: 1)

process_boolean_info: !nobattery
Entering libusb_get_report
Report[get]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Charging, Type: Feature, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Discharging, Type: Feature, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Entering libusb_get_report
Report[get]: (2 bytes) => 13 01
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ACPresent, Type: Feature, ReportID: 0x13, Offset: 0, Size: 8, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Entering libusb_get_report
Report[get]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x14, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ShutdownImminent, Type: Feature, ReportID: 0x14, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !shutdownimm (value: 0)

process_boolean_info: !shutdownimm
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.APCStatusFlag, Type: Feature, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Entering libusb_get_report
Report[get]: (3 bytes) => 31 7a 00
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.Voltage, Type: Feature, ReportID: 0x31, Offset: 0, Size: 16, Value: 122.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 30 78
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.ConfigVoltage, Type: Feature, ReportID: 0x30, Offset: 0, Size: 8, Value: 120.000000
upsdrv_updateinfo...
  ok
Report[int]: (4 bytes) => 06 00 00 08
Got 3 HID objects...
Entering libusb_get_report
Report[get]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850044 -> Charging
Path: UPS.PowerSummary.Charging, Type: Input, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850045 -> Discharging
Path: UPS.PowerSummary.Discharging, Type: Input, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: ff860060 -> APCStatusFlag
Path: UPS.PowerSummary.APCStatusFlag, Type: Input, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Quick update...
Entering libusb_get_report
Report[get]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 40 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeReboot, Type: Feature, ReportID: 0x40, Offset: 0, Size: 8, Value: 0.000000
Entering libusb_get_report
refresh_report_buffer: expected 5 bytes, but got only 3
Report[get]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ACPresent, Type: Feature, ReportID: 0x16, Offset: 2, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Discharging, Type: Feature, ReportID: 0x16, Offset: 1, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Charging, Type: Feature, ReportID: 0x16, Offset: 0, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x16, Offset: 4, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Charging, Type: Feature, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Discharging, Type: Feature, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Entering libusb_get_report
Report[get]: (2 bytes) => 13 01
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ACPresent, Type: Feature, ReportID: 0x13, Offset: 0, Size: 8, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Entering libusb_get_report
Report[get]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x14, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.APCStatusFlag, Type: Feature, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
send_to_one: PONG
upsdrv_updateinfo...
  ok
Report[int]: (4 bytes) => 06 00 00 08
Got 3 HID objects...
Entering libusb_get_report
Report[get]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850044 -> Charging
Path: UPS.PowerSummary.Charging, Type: Input, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850045 -> Discharging
Path: UPS.PowerSummary.Discharging, Type: Input, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: ff860060 -> APCStatusFlag
Path: UPS.PowerSummary.APCStatusFlag, Type: Input, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Full update...
Entering libusb_get_report
Report[get]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.RemainingCapacity, Type: Feature, ReportID: 0x0c, Offset: 0, Size: 8, Value: 100.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 0f 32
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.WarningCapacityLimit, Type: Feature, ReportID: 0x0f, Offset: 0, Size: 8, Value: 50.000000
Report[buf]: (4 bytes) => 0c 64 cc 05
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.RunTimeToEmpty, Type: Feature, ReportID: 0x0c, Offset: 8, Size: 16, Value: 1484.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 09 4d 0a
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.PowerSummary.Voltage, Type: Feature, ReportID: 0x09, Offset: 0, Size: 16, Value: 26.370000
send_to_all: SETINFO battery.voltage "26.4"
Entering libusb_get_report
Report[get]: (3 bytes) => 25 60 09
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Battery.ConfigVoltage, Type: Feature, ReportID: 0x25, Offset: 0, Size: 16, Value: 24.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 03 04
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.iDeviceChemistry, Type: Feature, ReportID: 0x03, Offset: 0, Size: 8, Value: 4.000000
hu_find_infoval: searching for value = 4

-> String: PbAc (len = 4/20)
hu_find_infoval: found PbAc (value: 4)

Entering libusb_get_report
Report[get]: (3 bytes) => 20 be 38
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.ManufacturerDate, Type: Feature, ReportID: 0x20, Offset: 0, Size: 16, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2008/05/30 (value: 14526)

Entering libusb_get_report
refresh_report_buffer: expected 4 bytes, but got only 3
Report[get]: (4 bytes) => 1c be 38 00
PhyMax = 0, PhyMin = 0, LogMax = 16777215, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.APCBattReplaceDate, Type: Feature, ReportID: 0x1c, Offset: 0, Size: 24, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2024/00/38 (value: 14526)

Entering libusb_get_report
Report[get]: (2 bytes) => 50 16
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerConverter.PercentLoad, Type: Feature, ReportID: 0x50, Offset: 0, Size: 8, Value: 22.000000
Entering libusb_get_report
Report[get]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 40 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeReboot, Type: Feature, ReportID: 0x40, Offset: 0, Size: 8, Value: 0.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 21 06
PhyMax = 0, PhyMin = 0, LogMax = 6, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.Battery.Test, Type: Feature, ReportID: 0x21, Offset: 0, Size: 8, Value: 6.000000
hu_find_infoval: searching for value = 6

hu_find_infoval: found No test initiated (value: 6)

Entering libusb_get_report
Report[get]: (2 bytes) => 18 02
PhyMax = 0, PhyMin = 0, LogMax = 3, LogMin = 1
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.AudibleAlarmControl, Type: Feature, ReportID: 0x18, Offset: 0, Size: 8, Value: 2.000000
hu_find_infoval: searching for value = 2

hu_find_infoval: found enabled (value: 2)

Entering libusb_get_report
Report[get]: (3 bytes) => 7b be 38
PhyMax = 0, PhyMin = 0, LogMax = 65535, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.ManufacturerDate, Type: Feature, ReportID: 0x7b, Offset: 0, Size: 16, Value: 14526.000000
hu_find_infoval: searching for value = 14526

hu_find_infoval: found 2008/05/30 (value: 14526)

Entering libusb_get_report
refresh_report_buffer: expected 5 bytes, but got only 3
Report[get]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ACPresent, Type: Feature, ReportID: 0x16, Offset: 2, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Discharging, Type: Feature, ReportID: 0x16, Offset: 1, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Charging, Type: Feature, ReportID: 0x16, Offset: 0, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ShutdownImminent, Type: Feature, ReportID: 0x16, Offset: 5, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !shutdownimm (value: 0)

process_boolean_info: !shutdownimm
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x16, Offset: 4, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Overload, Type: Feature, ReportID: 0x16, Offset: 9, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !overload (value: 0)

process_boolean_info: !overload
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.NeedReplacement, Type: Feature, ReportID: 0x16, Offset: 8, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !replacebatt (value: 0)

process_boolean_info: !replacebatt
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.RemainingTimeLimitExpired, Type: Feature, ReportID: 0x16, Offset: 6, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !timelimitexp (value: 0)

process_boolean_info: !timelimitexp
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BatteryPresent, Type: Feature, ReportID: 0x16, Offset: 3, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found !nobattery (value: 1)

process_boolean_info: !nobattery
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Charging, Type: Feature, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Discharging, Type: Feature, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Entering libusb_get_report
Report[get]: (2 bytes) => 13 01
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ACPresent, Type: Feature, ReportID: 0x13, Offset: 0, Size: 8, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Entering libusb_get_report
Report[get]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x14, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ShutdownImminent, Type: Feature, ReportID: 0x14, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !shutdownimm (value: 0)

process_boolean_info: !shutdownimm
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.APCStatusFlag, Type: Feature, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Entering libusb_get_report
Report[get]: (3 bytes) => 31 7a 00
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.Voltage, Type: Feature, ReportID: 0x31, Offset: 0, Size: 16, Value: 122.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 30 78
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00f0d121 found 7
Path: UPS.Input.ConfigVoltage, Type: Feature, ReportID: 0x30, Offset: 0, Size: 8, Value: 120.000000
upsdrv_updateinfo...
  ok
Report[int]: (4 bytes) => 06 00 00 08
Got 3 HID objects...
Entering libusb_get_report
Report[get]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850044 -> Charging
Path: UPS.PowerSummary.Charging, Type: Input, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: 00850045 -> Discharging
Path: UPS.PowerSummary.Discharging, Type: Input, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
hid_lookup_path: 00840004 -> UPS
hid_lookup_path: 00840024 -> PowerSummary
hid_lookup_path: ff860060 -> APCStatusFlag
Path: UPS.PowerSummary.APCStatusFlag, Type: Input, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Quick update...
Entering libusb_get_report
Report[get]: (3 bytes) => 15 ff ff
PhyMax = 0, PhyMin = 0, LogMax = 32767, LogMin = -1
get_unit_expo: 00001001 found 0
Path: UPS.PowerSummary.DelayBeforeShutdown, Type: Feature, ReportID: 0x15, Offset: 0, Size: 16, Value: -1.000000
Entering libusb_get_report
Report[get]: (2 bytes) => 40 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.APCGeneralCollection.APCDelayBeforeReboot, Type: Feature, ReportID: 0x40, Offset: 0, Size: 8, Value: 0.000000
Entering libusb_get_report
refresh_report_buffer: expected 5 bytes, but got only 3
Report[get]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.ACPresent, Type: Feature, ReportID: 0x16, Offset: 2, Size: 1, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Discharging, Type: Feature, ReportID: 0x16, Offset: 1, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.Charging, Type: Feature, ReportID: 0x16, Offset: 0, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (5 bytes) => 16 0c 00 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.PresentStatus.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x16, Offset: 4, Size: 1, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Charging, Type: Feature, ReportID: 0x06, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !chrg (value: 0)

process_boolean_info: !chrg
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.Discharging, Type: Feature, ReportID: 0x06, Offset: 8, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !dischrg (value: 0)

process_boolean_info: !dischrg
Entering libusb_get_report
Report[get]: (2 bytes) => 13 01
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.ACPresent, Type: Feature, ReportID: 0x13, Offset: 0, Size: 8, Value: 1.000000
hu_find_infoval: searching for value = 1

hu_find_infoval: found online (value: 1)

process_boolean_info: online
Entering libusb_get_report
Report[get]: (3 bytes) => 14 00 00
PhyMax = 0, PhyMin = 0, LogMax = 1, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.BelowRemainingCapacityLimit, Type: Feature, ReportID: 0x14, Offset: 0, Size: 8, Value: 0.000000
hu_find_infoval: searching for value = 0

hu_find_infoval: found !lowbatt (value: 0)

process_boolean_info: !lowbatt
Report[buf]: (4 bytes) => 06 00 00 08
PhyMax = 0, PhyMin = 0, LogMax = 255, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerSummary.APCStatusFlag, Type: Feature, ReportID: 0x06, Offset: 16, Size: 8, Value: 8.000000
hu_find_infoval: searching for value = 8

hu_find_infoval: found !off (value: 8)

process_boolean_info: !off
Signal 2: exiting
upsdrv_cleanup...

