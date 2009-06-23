Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZFWUPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZFWUPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZFWUOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:14:52 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:52944 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZFWUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gyva90XbORG+NUt154jGfnT1RmvrdMTTYENEKsyUrY1kD0JGA5n+yNYSfBudSe160v
         5BNmgSnbY40kWOO1Q1yBJbwiAWplGf6pB19di+V+BaYtpxhsjGJJrnIWnpMocjT4i8A/
         JtBf+BNTy60N+tO7DJkVLk7dr6BZyXqRoZXSQ=
MIME-Version: 1.0
In-Reply-To: <6dd519ae0905120915s5dc1f4b9h8c0b80a243f9cf7f@mail.gmail.com>
References: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com>
	 <1241821498.4903.69.camel@localhost.localdomain>
	 <6dd519ae0905110030n2abd87c0j507e476fb5622d87@mail.gmail.com>
	 <1242031614.3384.10.camel@localhost.localdomain>
	 <6dd519ae0905120915s5dc1f4b9h8c0b80a243f9cf7f@mail.gmail.com>
Date: Tue, 23 Jun 2009 23:14:51 +0300
Message-ID: <6dd519ae0906231314k930be18p296281c1e59ba798@mail.gmail.com>
Subject: Re: Regression: Problem in using USB Bluetooth Dongle (Worked fine in 
	2.6.24.x)
From: Brian Marete <bgmarete@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00163646bcb2b0ee25046d09a48e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163646bcb2b0ee25046d09a48e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Tue, May 12, 2009 at 7:15 PM, Brian Marete<bgmarete@gmail.com> wrote:
> On Mon, May 11, 2009 at 11:46 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
>> Hi Brian,
>>
>>> >> At least until kernel version 2.6.24, I was able to use my USB
>>> >> bluetooth dongle to download contacts from my phone. I made a jump
>>> >> from 2.6.24 to 2.6.27, so I am not sure exactly which kernel version
>>> >> starts the problem, but all kernels from the latter (2.6.27) now do
>>> >> not work. The latest kernel I have tested is 2.6.29.2.
>>> >
>>> > can you test 2.6.30-rc4 or bluetooth-testing.git. I am pretty sure that
>>> > whatever broke in 2.6.27 has been fixed by now. Some cheapo USB dongles
>>> > behaved wrongly and it was a long time not clear what caused it.
>>>
>>> Alas, the regression is still there in 2.6.30-rc5 which I tested over
>>> the weekend.
>>>
>>> I also forgot to mention that, even with the kernels with the
>>> regression, device pairing using the dongle still works.
>>>
>>> Would a packet capture (usbmon) help? Willing to capture whatever
>>> other debugging data that you think may help
>>
>> if device pairing works fine, the I guess this is a different problem.
>> It could be that your USB host controller doesn't like the device. Or
>> you forgot to load the EHCI driver or something. Otherwise your dongle
>> should work fine. Since pairing works, what does hciconfig -a says?
>>
>
> Hello,
>
> EHCI is actually loaded. See my regression report in my original email.
>
> Regarding some conflict with the host controller, well, it did work
> fine in 2.6.24.
>
> Is there some other debug output I can collect or some other
> information that I can provide to help identify the source of the
> regression?
>

Hello,

The regression persists even in the latest kernels.

Decided to collect some more debug information on this problem. This
output is from the same system detailed above running on
kernel 2.6.28.10:

Here is the output of hciconfig -a:

hci0:	Type: USB
	BD Address: BB:4A:BB:33:40:36 ACL MTU: 339:6 SCO MTU: 180:1
	UP RUNNING PSCAN ISCAN
	RX bytes:14299 acl:0 sco:0 events:386 errors:0
	TX bytes:2221 acl:0 sco:0 commands:231 errors:0
	Features: 0xef 0x3e 0x09 0xf0 0x0b 0x08 0x00 0x80
	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
	Link policy: RSWITCH HOLD SNIFF PARK
	Link mode: SLAVE ACCEPT
	Name: 'oqb-0'
	Class: 0x08010c
	Service Classes: Capturing
	Device Class: Computer, Laptop
	HCI Ver: 1.2 (0x2) HCI Rev: 0x2 LMP Ver: 1.2 (0x2) LMP Subver: 0x2
	Manufacturer: Accel Semiconductor Ltd. (74)
-----------------------------------------------------------------------------

Here is the output and hcidump of l2ping:

$ sudo l2ping 00:21:AB:9D:0C:C8
Can't connect: Device or resource busy

HCI sniffer - Bluetooth packet analyzer ver 1.40
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Create Connection (0x01|0x0005) plen 13
  C8 0C 9D AB 21 00 18 CC 02 00 00 00 01
> HCI Event: Command Status (0x0f) plen 4
  00 01 05 04
> HCI Event: Connect Complete (0x03) plen 11
  00 00 00 C8 0C 9D AB 21 00 01 00
< HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
  00 00
> HCI Event: Command Status (0x0f) plen 4
  0C 01 1B 04
< HCI Command: Remote Name Request (0x01|0x0019) plen 10
  C8 0C 9D AB 21 00 02 00 00 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 19 04
> HCI Event: Max Slots Change (0x1b) plen 3
  00 00 05
< HCI Command: Disconnect (0x01|0x0006) plen 3
  00 00 13
> HCI Event: Command Status (0x0f) plen 4
  00 01 06 04
> HCI Event: Disconn Complete (0x05) plen 4
  00 00 00 16
--------------------------------------------------------------------------------------

And here is the output followed by the hcidump of an attempt to
connect with rfcomm:

$ sudo rfcomm connect 0
Can't connect RFCOMM socket: Device or resource busy

HCI sniffer - Bluetooth packet analyzer ver 1.40
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Create Connection (0x01|0x0005) plen 13
  C8 0C 9D AB 21 00 18 CC 02 00 00 00 01
> HCI Event: Command Status (0x0f) plen 4
  00 01 05 04
> HCI Event: Connect Complete (0x03) plen 11
  00 00 00 C8 0C 9D AB 21 00 01 00
< HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
  00 00
> HCI Event: Command Status (0x0f) plen 4
  0C 01 1B 04
< HCI Command: Remote Name Request (0x01|0x0019) plen 10
  C8 0C 9D AB 21 00 02 00 00 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 19 04
> HCI Event: Max Slots Change (0x1b) plen 3
  00 00 05
< HCI Command: Disconnect (0x01|0x0006) plen 3
  00 00 13
> HCI Event: Command Status (0x0f) plen 4
  00 01 06 04
> HCI Event: Disconn Complete (0x05) plen 4
  00 00 00 16

-----------------------------------------------------------------------

Here is the output followed by a hcidump of using hcitool scan:

~$ sudo hcitool scan
Scanning ...
        00:21:AB:9D:0C:C8       Marete_

HCI sniffer - Bluetooth packet analyzer ver 1.40
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Inquiry (0x01|0x0001) plen 5
  33 8B 9E 08 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 01 04
> HCI Event: Inquiry Result with RSSI (0x22) plen 15
  01 C8 0C 9D AB 21 00 01 02 04 02 5A 4C 35 00
> HCI Event: Inquiry Complete (0x01) plen 1
  00

----------------------------------------------------------------------

Here is the output and hcidump of running hcitool inq

$ hcitool inq 00:21:AB:9D:0C:C8
Inquiring ...
        00:21:AB:9D:0C:C8       clock offset: 0x354f    class: 0x5a0204

HCI sniffer - Bluetooth packet analyzer ver 1.40
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Inquiry (0x01|0x0001) plen 5
  33 8B 9E 08 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 01 04
> HCI Event: Inquiry Result with RSSI (0x22) plen 15
  01 C8 0C 9D AB 21 00 01 02 04 02 5A 4F 35 00
> HCI Event: Inquiry Complete (0x01) plen 1
  00

-----------------------------------------------------------------------------

Here is the output and hcidump of running hcitool info

Requesting information ...
        BD Address:  00:21:AB:9D:0C:C8
        LMP Version: 2.0 (0x3) LMP Subversion: 0x6cc
        Manufacturer: Cambridge Silicon Radio (10)
        Features: 0xbf 0xee 0x0f 0xc6 0x9a 0x39 0x00 0x00
                <3-slot packets> <5-slot packets> <encryption> <slot offset>
                <timing accuracy> <role switch> <sniff mode> <RSSI>
                <channel quality> <SCO link> <HV3 packets> <u-law log>
                <A-law log> <CVSD> <paging scheme> <power control>
                <transparent SCO> <EDR ACL 2 Mbps> <EDR ACL 3 Mbps>
                <inquiry with RSSI> <extended SCO> <EV5 packets>
                <AFH cap. slave> <AFH class. slave> <3-slot EDR ACL>
                <5-slot EDR ACL> <AFH cap. master> <AFH class. master>
                <EDR eSCO 2 Mbps>


HCI sniffer - Bluetooth packet analyzer ver 1.40
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Create Connection (0x01|0x0005) plen 13
  C8 0C 9D AB 21 00 18 CC 02 00 00 00 01
> HCI Event: Command Status (0x0f) plen 4
  00 01 05 04
> HCI Event: Connect Complete (0x03) plen 11
  00 00 00 C8 0C 9D AB 21 00 01 00
< HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
  00 00
> HCI Event: Command Status (0x0f) plen 4
  0C 01 1B 04
< HCI Command: Remote Name Request (0x01|0x0019) plen 10
  C8 0C 9D AB 21 00 02 00 00 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 19 04
< HCI Command: Remote Name Request (0x01|0x0019) plen 10
  C8 0C 9D AB 21 00 02 00 00 00
> HCI Event: Command Status (0x0f) plen 4
  0C 01 19 04
< HCI Command: Read Remote Version Information (0x01|0x001d) plen 2
  00 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 1D 04
> HCI Event: Max Slots Change (0x1b) plen 3
  00 00 05
< HCI Command: Disconnect (0x01|0x0006) plen 3
  00 00 13
> HCI Event: Command Status (0x0f) plen 4
  0C 01 06 04
> HCI Event: Remote Name Req Complete (0x07) plen 255
  00 C8 0C 9D AB 21 00 4D 61 72 65 74 65 35 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> HCI Event: Read Remote Ver Info Complete (0x0c) plen 8
  00 00 00 03 0A 00 CC 06
< HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
  00 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 1B 04
> HCI Event: Read Remote Supported Features (0x0b) plen 11
  00 00 00 BF EE 0F C6 9A 39 00 00
< HCI Command: Disconnect (0x01|0x0006) plen 3
  00 00 13
> HCI Event: Command Status (0x0f) plen 4
  00 01 06 04
> HCI Event: Disconn Complete (0x05) plen 4
  00 00 00 16
------------------------------------------------------------------------

Pairing from the __phone__ works, even in the kernels with the
regression. Here is the hcidump of a pairing:

HCI sniffer - Bluetooth packet analyzer ver 1.40
device: hci0 snap_len: 1028 filter: 0xffffffff
> HCI Event: Connect Request (0x04) plen 10
  C8 0C 9D AB 21 00 04 02 5A 01
< HCI Command: Accept Connection Request (0x01|0x0009) plen 7
  C8 0C 9D AB 21 00 01
> HCI Event: Command Status (0x0f) plen 4
  00 01 09 04
> HCI Event: PIN Code Request (0x16) plen 6
  C8 0C 9D AB 21 00
< HCI Command: Read Local Name (0x03|0x0014) plen 0
> HCI Event: Command Complete (0x0e) plen 252
  01 14 0C 00 6F 71 62 2D 30 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00
< HCI Command: PIN Code Request Reply (0x01|0x000d) plen 23
  C8 0C 9D AB 21 00 04 30 30 30 30 00 00 00 00 00 00 00 00 00
  00 00 00
> HCI Event: Command Complete (0x0e) plen 10
  01 0D 04 00 C8 0C 9D AB 21 00
> HCI Event: Link Key Notification (0x18) plen 23
  C8 0C 9D AB 21 00 F9 27 CF D2 05 07 0E 16 36 99 2A 18 FB 12
  13 1D 00
> HCI Event: Connect Complete (0x03) plen 11
  00 00 00 C8 0C 9D AB 21 00 01 00
< HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
  00 00
> HCI Event: Max Slots Change (0x1b) plen 3
  00 00 05
> HCI Event: Command Status (0x0f) plen 4
  00 01 1B 04
< HCI Command: Change Connection Packet Type (0x01|0x000f) plen 4
  00 00 18 CC
> HCI Event: Command Status (0x0f) plen 4
  00 01 0F 04
> HCI Event: Connection Packet Type Changed (0x1d) plen 5
  00 00 00 00 80
> HCI Event: Read Remote Supported Features (0x0b) plen 11
  00 00 00 BF EE 0F C6 9A 39 00 00
< HCI Command: Remote Name Request (0x01|0x0019) plen 10
  C8 0C 9D AB 21 00 02 00 00 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 19 04
< HCI Command: Read Local Name (0x03|0x0014) plen 0
> HCI Event: Remote Name Req Complete (0x07) plen 255
  00 C8 0C 9D AB 21 00 4D 61 72 65 74 65 16 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> HCI Event: Command Complete (0x0e) plen 252
  01 14 0C 00 6F 71 62 2D 30 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00
> HCI Event: Disconn Complete (0x05) plen 4
  00 00 00 13

-------------------------------------------------------------------------

Here is the hcidump of (failed) attempt to browse the phone using obex
(By using the gnome bt applet)

HCI sniffer - Bluetooth packet analyzer ver 1.40
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Inquiry (0x01|0x0001) plen 5
  33 8B 9E 08 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 01 04
> HCI Event: Inquiry Result with RSSI (0x22) plen 15
  01 C8 0C 9D AB 21 00 01 02 04 02 5A 58 35 00
< HCI Command: Inquiry Cancel (0x01|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 4
  01 02 04 00
< HCI Command: Create Connection (0x01|0x0005) plen 13
  C8 0C 9D AB 21 00 18 CC 01 00 58 B5 01
> HCI Event: Command Status (0x0f) plen 4
  00 01 05 04
> HCI Event: Connect Complete (0x03) plen 11
  00 00 00 C8 0C 9D AB 21 00 01 00
< HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
  00 00
> HCI Event: Command Status (0x0f) plen 4
  0C 01 1B 04
< HCI Command: Remote Name Request (0x01|0x0019) plen 10
  C8 0C 9D AB 21 00 02 00 00 00
> HCI Event: Command Status (0x0f) plen 4
  00 01 19 04
> HCI Event: Max Slots Change (0x1b) plen 3
  00 00 05
< HCI Command: Disconnect (0x01|0x0006) plen 3
  00 00 13
> HCI Event: Command Status (0x0f) plen 4
  00 01 06 04
> HCI Event: Disconn Complete (0x05) plen 4
  00 00 00 16

Since you mentioned that you suspect that this is a USB problem,
attached is the usbmon capture of trying to l2ping the phone
(usbmon_l2ping_bt_dongle.txt). Also attached are the contents of
/proc/bus/usb/devices at the time of testing (devices.txt).

Finally, I note that my problem seems to be identical to the one described in:

http://bbs.archlinux.org/viewtopic.php?id=60158

The user there also notes that this is a regression introduces in
2.6.27, which is also my experience.

I hope this helps. Much obliged.

-- 
B. Gitonga Marete
Tel: +254-722-151-590

--00163646bcb2b0ee25046d09a48e
Content-Type: text/plain; charset=US-ASCII; name="usbmon_l2ping_bt_dongle.txt"
Content-Disposition: attachment; filename="usbmon_l2ping_bt_dongle.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwb1thzh0

ZjcxNjBhODAgNzM5OTQxMTE0IFMgQ286MzowMDI6MCBzIDIwIDAwIDAwMDAgMDAwMCAwMDEwIDE2
ID0gMDUwNDBkYzggMGM5ZGFiMjEgMDAxOGNjMDIgMDAwMDAwMDEKYzMwMmYyODAgNzM5OTQxMTkx
IFMgQmk6MzowMDI6MiAtMTE1IDY0IDwKYzMwMmY3MDAgNzM5OTQxMTk2IFMgQmk6MzowMDI6MiAt
MTE1IDY0IDwKYzMzMTAzMDAgNzM5OTQxMjAwIFMgQ286MzowMDI6MCBzIDAxIDBiIDAwMDAgMDAw
MSAwMDAwIDAKZjQzNmUzODAgNzM5OTQzMTY4IEMgSWk6MzowMDI6MSAwOjEgNiA9IDBmMDQwMDAx
IDA1MDQKZjQzNmUzODAgNzM5OTQzMTc2IFMgSWk6MzowMDI6MSAtMTE1OjEgMTYgPApmNzE2MGE4
MCA3Mzk5NDMxODAgQyBDbzozOjAwMjowIDAgMTYgPgpjMzMxMDMwMCA3Mzk5NDMxODQgQyBDbzoz
OjAwMjowIDAgMApmNDM2ZTM4MCA3NDM5MTMzMDcgQyBJaTozOjAwMjoxIDA6MSAxMyA9IDAzMGIw
MDAwIDAwYzgwYzlkIGFiMjEwMDAxIDAwCmY0MzZlMzgwIDc0MzkxMzMxOSBTIElpOjM6MDAyOjEg
LTExNToxIDE2IDwKZjMyNjg3MDAgNzQzOTEzMzQ2IFMgQ286MzowMDI6MCBzIDIwIDAwIDAwMDAg
MDAwMCAwMDA1IDUgPSAxYjA0MDIwMCAwMApmMzI2ODcwMCA3NDM5MTUzMDUgQyBDbzozOjAwMjow
IDAgNSA+CmY0MzZlMzgwIDc0MzkxNjMwNSBDIElpOjM6MDAyOjEgMDoxIDYgPSAwZjA0MGMwMSAx
YjA0CmY0MzZlMzgwIDc0MzkxNjMxOSBTIElpOjM6MDAyOjEgLTExNToxIDE2IDwKZjMyNjg3MDAg
NzQzOTE2MzUwIFMgQ286MzowMDI6MCBzIDIwIDAwIDAwMDAgMDAwMCAwMDBkIDEzID0gMTkwNDBh
YzggMGM5ZGFiMjEgMDAwMjAwMDAgMDAKZjMyNjg3MDAgNzQzOTE3MzExIEMgQ286MzowMDI6MCAw
IDEzID4KZjQzNmUzODAgNzQzOTE4MzA5IEMgSWk6MzowMDI6MSAwOjEgNiA9IDBmMDQwMDAxIDE5
MDQKZjQzNmUzODAgNzQzOTE4MzE5IFMgSWk6MzowMDI6MSAtMTE1OjEgMTYgPApmNDM2ZTM4MCA3
NDM5MjEzMTAgQyBJaTozOjAwMjoxIDA6MSA1ID0gMWIwMzAwMDAgMDUKZjQzNmUzODAgNzQzOTIx
MzIwIFMgSWk6MzowMDI6MSAtMTE1OjEgMTYgPApmMzI2ODcwMCA3NDM5MjcwMjEgUyBDbzozOjAw
MjowIHMgMjAgMDAgMDAwMCAwMDAwIDAwMDYgNiA9IDA2MDQwMzAwIDAwMTMKZjQzNmUzODAgNzQz
OTI4MzA3IEMgSWk6MzowMDI6MSAwOjEgMTYgPSAwN2ZmMDBjOCAwYzlkYWIyMSAwMDRkNjE3MiA2
NTc0NjUwMApmNDM2ZTM4MCA3NDM5MjgzMTQgUyBJaTozOjAwMjoxIC0xMTU6MSAxNiA8CmYzMjY4
NzAwIDc0MzkyODMxOSBDIENvOjM6MDAyOjAgMCA2ID4KZjQzNmUzODAgNzQzOTMwMzA0IEMgSWk6
MzowMDI6MSAwOjEgMTYgPSAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMApmNDM2
ZTM4MCA3NDM5MzAzMTQgUyBJaTozOjAwMjoxIC0xMTU6MSAxNiA8CmY0MzZlMzgwIDc0MzkzMjMw
NyBDIElpOjM6MDAyOjEgMDoxIDE2ID0gMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAw
MDAKZjQzNmUzODAgNzQzOTMyMzE0IFMgSWk6MzowMDI6MSAtMTE1OjEgMTYgPApmNDM2ZTM4MCA3
NDM5MzQzMTMgQyBJaTozOjAwMjoxIDA6MSAxNiA9IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwCmY0MzZlMzgwIDc0MzkzNDMyNCBTIElpOjM6MDAyOjEgLTExNToxIDE2IDwKZjQz
NmUzODAgNzQzOTM2MzA4IEMgSWk6MzowMDI6MSAwOjEgMTYgPSAwMDAwMDAwMCAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMApmNDM2ZTM4MCA3NDM5MzYzMTUgUyBJaTozOjAwMjoxIC0xMTU6MSAx
NiA8CmY0MzZlMzgwIDc0MzkzODMwOCBDIElpOjM6MDAyOjEgMDoxIDE2ID0gMDAwMDAwMDAgMDAw
MDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAKZjQzNmUzODAgNzQzOTM4MzE2IFMgSWk6MzowMDI6MSAt
MTE1OjEgMTYgPApmNDM2ZTM4MCA3NDM5NDAzMDYgQyBJaTozOjAwMjoxIDA6MSAxNiA9IDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCmY0MzZlMzgwIDc0Mzk0MDMxMyBTIElpOjM6
MDAyOjEgLTExNToxIDE2IDwKZjQzNmUzODAgNzQzOTQyMzI1IEMgSWk6MzowMDI6MSAwOjEgMTYg
PSAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMApmNDM2ZTM4MCA3NDM5NDIzMzYg
UyBJaTozOjAwMjoxIC0xMTU6MSAxNiA8CmY0MzZlMzgwIDc0Mzk0NDMxOCBDIElpOjM6MDAyOjEg
MDoxIDE2ID0gMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAKZjQzNmUzODAgNzQz
OTQ0MzIzIFMgSWk6MzowMDI6MSAtMTE1OjEgMTYgPApmNDM2ZTM4MCA3NDM5NDYzMjAgQyBJaToz
OjAwMjoxIDA6MSAxNiA9IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCmY0MzZl
MzgwIDc0Mzk0NjMyNyBTIElpOjM6MDAyOjEgLTExNToxIDE2IDwKZjQzNmUzODAgNzQzOTQ4MzA4
IEMgSWk6MzowMDI6MSAwOjEgMTYgPSAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MApmNDM2ZTM4MCA3NDM5NDgzMTYgUyBJaTozOjAwMjoxIC0xMTU6MSAxNiA8CmY0MzZlMzgwIDc0
Mzk1MDMxMSBDIElpOjM6MDAyOjEgMDoxIDE2ID0gMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAg
MDAwMDAwMDAKZjQzNmUzODAgNzQzOTUwMzMzIFMgSWk6MzowMDI6MSAtMTE1OjEgMTYgPApmNDM2
ZTM4MCA3NDM5NTIzMDggQyBJaTozOjAwMjoxIDA6MSAxNiA9IDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwCmY0MzZlMzgwIDc0Mzk1MjMyNCBTIElpOjM6MDAyOjEgLTExNToxIDE2
IDwKZjQzNmUzODAgNzQzOTU0MzEyIEMgSWk6MzowMDI6MSAwOjEgMTYgPSAwMDAwMDAwMCAwMDAw
MDAwMCAwMDAwMDAwMCAwMDAwMDAwMApmNDM2ZTM4MCA3NDM5NTQzMjAgUyBJaTozOjAwMjoxIC0x
MTU6MSAxNiA8CmY0MzZlMzgwIDc0Mzk1NjMwNiBDIElpOjM6MDAyOjEgMDoxIDE2ID0gMDAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAKZjQzNmUzODAgNzQzOTU2MzE2IFMgSWk6Mzow
MDI6MSAtMTE1OjEgMTYgPApmNDM2ZTM4MCA3NDM5NTgzMDQgQyBJaTozOjAwMjoxIDA6MSAxNiA9
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCmY0MzZlMzgwIDc0Mzk1ODMxMCBT
IElpOjM6MDAyOjEgLTExNToxIDE2IDwKZjQzNmUzODAgNzQzOTYwMzMzIEMgSWk6MzowMDI6MSAw
OjEgMSA9IDAwCmY0MzZlMzgwIDc0Mzk2MDM0MyBTIElpOjM6MDAyOjEgLTExNToxIDE2IDwKZjQz
NmUzODAgNzQzOTYyMzMyIEMgSWk6MzowMDI6MSAwOjEgNiA9IDBmMDQwMDAxIDA2MDQKZjQzNmUz
ODAgNzQzOTYyMzQxIFMgSWk6MzowMDI6MSAtMTE1OjEgMTYgPApmNDM2ZTM4MCA3NDQwMTczNTAg
QyBJaTozOjAwMjoxIDA6MSA2ID0gMDUwNDAwMDAgMDAxNgpmNDM2ZTM4MCA3NDQwMTczODcgUyBJ
aTozOjAwMjoxIC0xMTU6MSAxNiA8CmMzMDJmNzAwIDc0NDAxOTMxOCBDIEJpOjM6MDAyOjIgLTIg
MApjMzAyZjI4MCA3NDQwMjAzMTcgQyBCaTozOjAwMjoyIC0yIDAKZjMyNjg3MDAgNzQ0MDIwNTI5
IFMgQ286MzowMDI6MCBzIDAxIDBiIDAwMDAgMDAwMSAwMDAwIDAKZjMyNjg3MDAgNzQ0MDIxMzEw
IEMgQ286MzowMDI6MCAwIDAK
--00163646bcb2b0ee25046d09a48e
Content-Type: text/plain; charset=US-ASCII; name="devices.txt"
Content-Disposition: attachment; filename="devices.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwb1tvmc1

ClQ6ICBCdXM9MDcgTGV2PTAwIFBybnQ9MDAgUG9ydD0wMCBDbnQ9MDAgRGV2Iz0gIDEgU3BkPTQ4
MCBNeENoPSA2CkI6ICBBbGxvYz0gIDEvODAwIHVzICggMCUpLCAjSW50PSAgMSwgI0lzbz0gIDAK
RDogIFZlcj0gMi4wMCBDbHM9MDkoaHViICApIFN1Yj0wMCBQcm90PTAwIE14UFM9NjQgI0NmZ3M9
ICAxClA6ICBWZW5kb3I9MWQ2YiBQcm9kSUQ9MDAwMiBSZXY9IDIuMDYKUzogIE1hbnVmYWN0dXJl
cj1MaW51eCAyLjYuMjguMTAgZWhjaV9oY2QKUzogIFByb2R1Y3Q9RUhDSSBIb3N0IENvbnRyb2xs
ZXIKUzogIFNlcmlhbE51bWJlcj0wMDAwOjAwOjFkLjcKQzoqICNJZnM9IDEgQ2ZnIz0gMSBBdHI9
ZTAgTXhQd3I9ICAwbUEKSToqIElmIz0gMCBBbHQ9IDAgI0VQcz0gMSBDbHM9MDkoaHViICApIFN1
Yj0wMCBQcm90PTAwIERyaXZlcj1odWIKRTogIEFkPTgxKEkpIEF0cj0wMyhJbnQuKSBNeFBTPSAg
IDQgSXZsPTI1Nm1zCgpUOiAgQnVzPTA3IExldj0wMSBQcm50PTAxIFBvcnQ9MDMgQ250PTAxIERl
diM9ICA1IFNwZD00ODAgTXhDaD0gMApEOiAgVmVyPSAyLjAwIENscz0wMCg+aWZjICkgU3ViPTAw
IFByb3Q9MDAgTXhQUz02NCAjQ2Zncz0gIDEKUDogIFZlbmRvcj0xMmQxIFByb2RJRD0xMDAzIFJl
dj0gMC4wMApTOiAgTWFudWZhY3R1cmVyPUhVQVdFSSBUZWNobm9sb2d5ClM6ICBQcm9kdWN0PUhV
QVdFSSBNb2JpbGUKQzoqICNJZnM9IDQgQ2ZnIz0gMSBBdHI9ZTAgTXhQd3I9NTAwbUEKSToqIElm
Iz0gMCBBbHQ9IDAgI0VQcz0gMyBDbHM9ZmYodmVuZC4pIFN1Yj1mZiBQcm90PWZmIERyaXZlcj1v
cHRpb24KRTogIEFkPTgxKEkpIEF0cj0wMyhJbnQuKSBNeFBTPSAgNjQgSXZsPTJtcwpFOiAgQWQ9
ODIoSSkgQXRyPTAyKEJ1bGspIE14UFM9IDUxMiBJdmw9MG1zCkU6ICBBZD0wMShPKSBBdHI9MDIo
QnVsaykgTXhQUz0gNTEyIEl2bD00bXMKSToqIElmIz0gMSBBbHQ9IDAgI0VQcz0gMiBDbHM9ZmYo
dmVuZC4pIFN1Yj1mZiBQcm90PWZmIERyaXZlcj1vcHRpb24KRTogIEFkPTgzKEkpIEF0cj0wMihC
dWxrKSBNeFBTPSA1MTIgSXZsPTBtcwpFOiAgQWQ9MDIoTykgQXRyPTAyKEJ1bGspIE14UFM9IDUx
MiBJdmw9NG1zCkk6KiBJZiM9IDIgQWx0PSAwICNFUHM9IDIgQ2xzPTA4KHN0b3IuKSBTdWI9MDYg
UHJvdD01MCBEcml2ZXI9KG5vbmUpCkU6ICBBZD04NChJKSBBdHI9MDIoQnVsaykgTXhQUz0gNTEy
IEl2bD0wbXMKRTogIEFkPTAzKE8pIEF0cj0wMihCdWxrKSBNeFBTPSA1MTIgSXZsPTBtcwpJOiog
SWYjPSAzIEFsdD0gMCAjRVBzPSAyIENscz0wOChzdG9yLikgU3ViPTA2IFByb3Q9NTAgRHJpdmVy
PShub25lKQpFOiAgQWQ9MDQoTykgQXRyPTAyKEJ1bGspIE14UFM9IDUxMiBJdmw9MG1zCkU6ICBB
ZD04NShJKSBBdHI9MDIoQnVsaykgTXhQUz0gNTEyIEl2bD0wbXMKClQ6ICBCdXM9MDYgTGV2PTAw
IFBybnQ9MDAgUG9ydD0wMCBDbnQ9MDAgRGV2Iz0gIDEgU3BkPTQ4MCBNeENoPSA0CkI6ICBBbGxv
Yz0gIDAvODAwIHVzICggMCUpLCAjSW50PSAgMCwgI0lzbz0gIDAKRDogIFZlcj0gMi4wMCBDbHM9
MDkoaHViICApIFN1Yj0wMCBQcm90PTAwIE14UFM9NjQgI0NmZ3M9ICAxClA6ICBWZW5kb3I9MWQ2
YiBQcm9kSUQ9MDAwMiBSZXY9IDIuMDYKUzogIE1hbnVmYWN0dXJlcj1MaW51eCAyLjYuMjguMTAg
ZWhjaV9oY2QKUzogIFByb2R1Y3Q9RUhDSSBIb3N0IENvbnRyb2xsZXIKUzogIFNlcmlhbE51bWJl
cj0wMDAwOjAwOjFhLjcKQzoqICNJZnM9IDEgQ2ZnIz0gMSBBdHI9ZTAgTXhQd3I9ICAwbUEKSToq
IElmIz0gMCBBbHQ9IDAgI0VQcz0gMSBDbHM9MDkoaHViICApIFN1Yj0wMCBQcm90PTAwIERyaXZl
cj1odWIKRTogIEFkPTgxKEkpIEF0cj0wMyhJbnQuKSBNeFBTPSAgIDQgSXZsPTI1Nm1zCgpUOiAg
QnVzPTA1IExldj0wMCBQcm50PTAwIFBvcnQ9MDAgQ250PTAwIERldiM9ICAxIFNwZD0xMiAgTXhD
aD0gMgpCOiAgQWxsb2M9ICAwLzkwMCB1cyAoIDAlKSwgI0ludD0gIDAsICNJc289ICAwCkQ6ICBW
ZXI9IDEuMTAgQ2xzPTA5KGh1YiAgKSBTdWI9MDAgUHJvdD0wMCBNeFBTPTY0ICNDZmdzPSAgMQpQ
OiAgVmVuZG9yPTFkNmIgUHJvZElEPTAwMDEgUmV2PSAyLjA2ClM6ICBNYW51ZmFjdHVyZXI9TGlu
dXggMi42LjI4LjEwIHVoY2lfaGNkClM6ICBQcm9kdWN0PVVIQ0kgSG9zdCBDb250cm9sbGVyClM6
ICBTZXJpYWxOdW1iZXI9MDAwMDowMDoxZC4yCkM6KiAjSWZzPSAxIENmZyM9IDEgQXRyPWUwIE14
UHdyPSAgMG1BCkk6KiBJZiM9IDAgQWx0PSAwICNFUHM9IDEgQ2xzPTA5KGh1YiAgKSBTdWI9MDAg
UHJvdD0wMCBEcml2ZXI9aHViCkU6ICBBZD04MShJKSBBdHI9MDMoSW50LikgTXhQUz0gICAyIEl2
bD0yNTVtcwoKVDogIEJ1cz0wNCBMZXY9MDAgUHJudD0wMCBQb3J0PTAwIENudD0wMCBEZXYjPSAg
MSBTcGQ9MTIgIE14Q2g9IDIKQjogIEFsbG9jPSAgMC85MDAgdXMgKCAwJSksICNJbnQ9ICAwLCAj
SXNvPSAgMApEOiAgVmVyPSAxLjEwIENscz0wOShodWIgICkgU3ViPTAwIFByb3Q9MDAgTXhQUz02
NCAjQ2Zncz0gIDEKUDogIFZlbmRvcj0xZDZiIFByb2RJRD0wMDAxIFJldj0gMi4wNgpTOiAgTWFu
dWZhY3R1cmVyPUxpbnV4IDIuNi4yOC4xMCB1aGNpX2hjZApTOiAgUHJvZHVjdD1VSENJIEhvc3Qg
Q29udHJvbGxlcgpTOiAgU2VyaWFsTnVtYmVyPTAwMDA6MDA6MWQuMQpDOiogI0lmcz0gMSBDZmcj
PSAxIEF0cj1lMCBNeFB3cj0gIDBtQQpJOiogSWYjPSAwIEFsdD0gMCAjRVBzPSAxIENscz0wOSho
dWIgICkgU3ViPTAwIFByb3Q9MDAgRHJpdmVyPWh1YgpFOiAgQWQ9ODEoSSkgQXRyPTAzKEludC4p
IE14UFM9ICAgMiBJdmw9MjU1bXMKClQ6ICBCdXM9MDMgTGV2PTAwIFBybnQ9MDAgUG9ydD0wMCBD
bnQ9MDAgRGV2Iz0gIDEgU3BkPTEyICBNeENoPSAyCkI6ICBBbGxvYz0gMjMvOTAwIHVzICggMyUp
LCAjSW50PSAgMSwgI0lzbz0gIDAKRDogIFZlcj0gMS4xMCBDbHM9MDkoaHViICApIFN1Yj0wMCBQ
cm90PTAwIE14UFM9NjQgI0NmZ3M9ICAxClA6ICBWZW5kb3I9MWQ2YiBQcm9kSUQ9MDAwMSBSZXY9
IDIuMDYKUzogIE1hbnVmYWN0dXJlcj1MaW51eCAyLjYuMjguMTAgdWhjaV9oY2QKUzogIFByb2R1
Y3Q9VUhDSSBIb3N0IENvbnRyb2xsZXIKUzogIFNlcmlhbE51bWJlcj0wMDAwOjAwOjFkLjAKQzoq
ICNJZnM9IDEgQ2ZnIz0gMSBBdHI9ZTAgTXhQd3I9ICAwbUEKSToqIElmIz0gMCBBbHQ9IDAgI0VQ
cz0gMSBDbHM9MDkoaHViICApIFN1Yj0wMCBQcm90PTAwIERyaXZlcj1odWIKRTogIEFkPTgxKEkp
IEF0cj0wMyhJbnQuKSBNeFBTPSAgIDIgSXZsPTI1NW1zCgpUOiAgQnVzPTAzIExldj0wMSBQcm50
PTAxIFBvcnQ9MDEgQ250PTAxIERldiM9ICAyIFNwZD0xMiAgTXhDaD0gMApEOiAgVmVyPSAyLjAw
IENscz1lMCh1bmsuICkgU3ViPTAxIFByb3Q9MDEgTXhQUz02NCAjQ2Zncz0gIDEKUDogIFZlbmRv
cj0wYTEyIFByb2RJRD0wMDAxIFJldj0xOS4xNQpDOiogI0lmcz0gMyBDZmcjPSAxIEF0cj1jMCBN
eFB3cj0gIDBtQQpJOiogSWYjPSAwIEFsdD0gMCAjRVBzPSAzIENscz1lMCh1bmsuICkgU3ViPTAx
IFByb3Q9MDEgRHJpdmVyPWJ0dXNiCkU6ICBBZD04MShJKSBBdHI9MDMoSW50LikgTXhQUz0gIDE2
IEl2bD0xbXMKRTogIEFkPTgyKEkpIEF0cj0wMihCdWxrKSBNeFBTPSAgNjQgSXZsPTBtcwpFOiAg
QWQ9MDIoTykgQXRyPTAyKEJ1bGspIE14UFM9ICA2NCBJdmw9MG1zCkk6KiBJZiM9IDEgQWx0PSAw
ICNFUHM9IDIgQ2xzPWUwKHVuay4gKSBTdWI9MDEgUHJvdD0wMSBEcml2ZXI9YnR1c2IKRTogIEFk
PTgzKEkpIEF0cj0wMShJc29jKSBNeFBTPSAgMzIgSXZsPTFtcwpFOiAgQWQ9MDMoTykgQXRyPTAx
KElzb2MpIE14UFM9ICAzMiBJdmw9MW1zCkk6ICBJZiM9IDEgQWx0PSAxICNFUHM9IDIgQ2xzPWUw
KHVuay4gKSBTdWI9MDEgUHJvdD0wMSBEcml2ZXI9YnR1c2IKRTogIEFkPTgzKEkpIEF0cj0wMShJ
c29jKSBNeFBTPSAgIDkgSXZsPTFtcwpFOiAgQWQ9MDMoTykgQXRyPTAxKElzb2MpIE14UFM9ICAg
OSBJdmw9MW1zCkk6ICBJZiM9IDEgQWx0PSAyICNFUHM9IDIgQ2xzPWUwKHVuay4gKSBTdWI9MDEg
UHJvdD0wMSBEcml2ZXI9YnR1c2IKRTogIEFkPTgzKEkpIEF0cj0wMShJc29jKSBNeFBTPSAgMTcg
SXZsPTFtcwpFOiAgQWQ9MDMoTykgQXRyPTAxKElzb2MpIE14UFM9ICAxNyBJdmw9MW1zCkk6ICBJ
ZiM9IDEgQWx0PSAzICNFUHM9IDIgQ2xzPWUwKHVuay4gKSBTdWI9MDEgUHJvdD0wMSBEcml2ZXI9
YnR1c2IKRTogIEFkPTgzKEkpIEF0cj0wMShJc29jKSBNeFBTPSAgMjUgSXZsPTFtcwpFOiAgQWQ9
MDMoTykgQXRyPTAxKElzb2MpIE14UFM9ICAyNSBJdmw9MW1zCkk6ICBJZiM9IDEgQWx0PSA0ICNF
UHM9IDIgQ2xzPWUwKHVuay4gKSBTdWI9MDEgUHJvdD0wMSBEcml2ZXI9YnR1c2IKRTogIEFkPTgz
KEkpIEF0cj0wMShJc29jKSBNeFBTPSAgMzMgSXZsPTFtcwpFOiAgQWQ9MDMoTykgQXRyPTAxKElz
b2MpIE14UFM9ICAzMyBJdmw9MW1zCkk6ICBJZiM9IDEgQWx0PSA1ICNFUHM9IDIgQ2xzPWUwKHVu
ay4gKSBTdWI9MDEgUHJvdD0wMSBEcml2ZXI9YnR1c2IKRTogIEFkPTgzKEkpIEF0cj0wMShJc29j
KSBNeFBTPSAgNDkgSXZsPTFtcwpFOiAgQWQ9MDMoTykgQXRyPTAxKElzb2MpIE14UFM9ICA0OSBJ
dmw9MW1zCkk6KiBJZiM9IDIgQWx0PSAwICNFUHM9IDAgQ2xzPWZlKGFwcC4gKSBTdWI9MDEgUHJv
dD0wMCBEcml2ZXI9KG5vbmUpCgpUOiAgQnVzPTAyIExldj0wMCBQcm50PTAwIFBvcnQ9MDAgQ250
PTAwIERldiM9ICAxIFNwZD0xMiAgTXhDaD0gMgpCOiAgQWxsb2M9ICAwLzkwMCB1cyAoIDAlKSwg
I0ludD0gIDAsICNJc289ICAwCkQ6ICBWZXI9IDEuMTAgQ2xzPTA5KGh1YiAgKSBTdWI9MDAgUHJv
dD0wMCBNeFBTPTY0ICNDZmdzPSAgMQpQOiAgVmVuZG9yPTFkNmIgUHJvZElEPTAwMDEgUmV2PSAy
LjA2ClM6ICBNYW51ZmFjdHVyZXI9TGludXggMi42LjI4LjEwIHVoY2lfaGNkClM6ICBQcm9kdWN0
PVVIQ0kgSG9zdCBDb250cm9sbGVyClM6ICBTZXJpYWxOdW1iZXI9MDAwMDowMDoxYS4xCkM6KiAj
SWZzPSAxIENmZyM9IDEgQXRyPWUwIE14UHdyPSAgMG1BCkk6KiBJZiM9IDAgQWx0PSAwICNFUHM9
IDEgQ2xzPTA5KGh1YiAgKSBTdWI9MDAgUHJvdD0wMCBEcml2ZXI9aHViCkU6ICBBZD04MShJKSBB
dHI9MDMoSW50LikgTXhQUz0gICAyIEl2bD0yNTVtcwoKVDogIEJ1cz0wMSBMZXY9MDAgUHJudD0w
MCBQb3J0PTAwIENudD0wMCBEZXYjPSAgMSBTcGQ9MTIgIE14Q2g9IDIKQjogIEFsbG9jPSAgMC85
MDAgdXMgKCAwJSksICNJbnQ9ICAwLCAjSXNvPSAgMApEOiAgVmVyPSAxLjEwIENscz0wOShodWIg
ICkgU3ViPTAwIFByb3Q9MDAgTXhQUz02NCAjQ2Zncz0gIDEKUDogIFZlbmRvcj0xZDZiIFByb2RJ
RD0wMDAxIFJldj0gMi4wNgpTOiAgTWFudWZhY3R1cmVyPUxpbnV4IDIuNi4yOC4xMCB1aGNpX2hj
ZApTOiAgUHJvZHVjdD1VSENJIEhvc3QgQ29udHJvbGxlcgpTOiAgU2VyaWFsTnVtYmVyPTAwMDA6
MDA6MWEuMApDOiogI0lmcz0gMSBDZmcjPSAxIEF0cj1lMCBNeFB3cj0gIDBtQQpJOiogSWYjPSAw
IEFsdD0gMCAjRVBzPSAxIENscz0wOShodWIgICkgU3ViPTAwIFByb3Q9MDAgRHJpdmVyPWh1YgpF
OiAgQWQ9ODEoSSkgQXRyPTAzKEludC4pIE14UFM9ICAgMiBJdmw9MjU1bXMK
--00163646bcb2b0ee25046d09a48e--
