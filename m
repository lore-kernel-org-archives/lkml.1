Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYLOWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYLOWa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYLOWav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:30:51 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19930 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYLOWau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:30:50 -0500
From: "Chen, Justin" <justin.chen@hp.com>
To: "Chen, Justin" <justin.chen@hp.com>, "Chiang, Alexander" <achiang@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2008 22:29:42 +0000
Subject: RE: PCI BAR mem resource allocation "regression"
Thread-Topic: PCI BAR mem resource allocation "regression"
Thread-Index: AcldiBIvrPJaSDwaTJmS3YaE44GTEgBWKzBAAAikeaA=
Message-ID: <B57D568CB82B0C4B897F9CD9862DE8B733BD4296E3@GVW1097EXB.americas.hpqcorp.net>
References: <20081213000538.GC9947@ldl.fc.hp.com>
 <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain>
 <20081214010534.GB22302@ldl.fc.hp.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>-----Original Message-----
>>From: Chiang, Alexander
>>
>>> Also, is it just the error message, or does it actually affect
>>> functionality?
>>
>>Hm, that is a good question. ;) The particular device I was testing
>>with was an infiniband device, and I have never actually pushed any
>>traffic over it; just used it to reproduce the error.
>>
>>I can try and hook the card up to something and push traffic over it,
>>but that will have to wait until Monday. Maybe Justin (cc'ed) knows,
>>since he was the one who first reported this to me.
>

More information of the error:

I tried it on a LAN and infiniband cards.  After the hotplug, the device is not registered anymore.  Below is an example on the lan card (eth4, 002b:01:00.0, slot 1306):

# ls /sys/class/net
eth0   eth10  eth12  eth3   eth5   eth7   eth9   ib1    ib3
eth1   eth11  eth2   eth4   eth6   eth8   ib0    ib2    lo
# cat /sys/class/net/eth4/device/uevent
DRIVER=e1000
PCI_CLASS=20000
PCI_ID=8086:105F
PCI_SUBSYS_ID=103C:704F
PCI_SLOT_NAME=002b:01:00.0
MODALIAS=pci:v00008086d0000105Fsv0000103Csd0000704Fbc02sc00i00
# cat /sys/bus/pci/slots/1306/address
002b:01:00
# echo 0 > /sys/bus/pci/slots/1306/power
# ls /sys/class/net
eth0   eth10  eth12  eth3   eth7   eth9   ib1    ib3
eth1   eth11  eth2   eth6   eth8   ib0    ib2    lo
# echo 1 > /sys/bus/pci/slots/1306/power
PCI: Failed to allocate mem resource #0:20000@f727ee00000 for 002b:01:00.0
PCI: Failed to allocate mem resource #1:20000@f727ee00000 for 002b:01:00.0
PCI: Failed to allocate mem resource #6:20000@f727ee00000 for 002b:01:00.0
PCI: Failed to allocate mem resource #0:20000@f727ee00000 for 002b:01:00.1
PCI: Failed to allocate mem resource #1:20000@f727ee00000 for 002b:01:00.1
PCI: Failed to allocate mem resource #6:20000@f727ee00000 for 002b:01:00.1
PCI: Failed to allocate I/O resource #2:20@10000 for 002b:01:00.0
PCI: Failed to allocate I/O resource #2:20@10000 for 002b:01:00.1
e1000: 002b:01:00.0: e1000_probe: The EEPROM Checksum Is Not Valid
e1000: 002b:01:00.1: e1000_probe: The EEPROM Checksum Is Not Valid
# ls /sys/class/net
eth0   eth10  eth12  eth3   eth7   eth9   ib1    ib3
eth1   eth11  eth2   eth6   eth8   ib0    ib2    lo
#

Justin
