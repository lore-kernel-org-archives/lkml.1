Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYFIUIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYFIUIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYFIUHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:07:34 -0400
Received: from mail.leadpile.com ([209.234.164.13]:43440 "EHLO
	mail.leadpile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYFIUHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:07:24 -0400
Message-ID: <484D8CCC.1070701@embedromix.ro>
Date: Mon, 09 Jun 2008 23:04:28 +0300
From: "Catalin(ux) M BOIE" <catab@embedromix.ro>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, akpm@linux-foundation.org,
       pazke@pazke.donpac.ru
Subject: Re: [PATCH] Add support for a no-name 4 ports multiserial card
References: <1212736393-6837-1-git-send-email-catab@embedromix.ro> <20080606111400.1eefc4fd@core> <20080606194036.GB18231@flint.arm.linux.org.uk>
In-Reply-To: <20080606194036.GB18231@flint.arm.linux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------060903000008090702050909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060903000008090702050909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Russell King wrote:
> On Fri, Jun 06, 2008 at 11:14:00AM +0100, Alan Cox wrote:
>> On Fri,  6 Jun 2008 10:13:13 +0300
>> "Catalin(ux) M BOIE" <catab@embedromix.ro> wrote:
>>
>>> It is a no-name PCI card. I found no reference to a producer so I
>>> used the fake name "PDR".
>> We don't really want to get fake names into pci_ids. I'd rather
>>
>>
>>>  		.vendor		= PCI_VENDOR_ID_PLX,
>>> +		.device		= PCI_DEVICE_ID_PLX_9050,
>>> +		.subvendor	= PCI_VENDOR_ID_PLX,
>>> +		.subdevice	= PCI_SUBDEVICE_ID_PDR,
>> Either the hex or a local and obviously unknown name like ID_UNKNOWN_1
>>
>>
>>> +	pbn_plx_pdr,
>> _unknown1
>>
>>>  	pbn_oxsemi,
>>>  	pbn_intel_i960,
>>>  	pbn_sgi_ioc3,
>>> @@ -1186,6 +1196,13 @@ static struct pciserial_board pci_boards[] __devinitdata = {
>>>  		.base_baud	= 115200,
>>>  		.uart_offset	= 8,
>>>  	},
>>> +	/* PDR */
>>> +	[pbn_plx_pdr] = {
>> Ditto
>>
>>> +	/* PDR */
>> Ditto
>>
>>> +	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
>>> +		PCI_VENDOR_ID_PLX,
>>> +		PCI_SUBDEVICE_ID_PDR, 0, 0,
>> Ditto
>>
>>
>>> +#define PCI_SUBDEVICE_ID_PDR		0x1584
>>> +
>> And not in here at all.
> 
> And there's no need for half the patch either - which I tried to explain
> in a previous reply to Catalin but I just got repeated "My email address
> has changed to ..." responses... so I gave up.

Rusell, I am very sorry about: sending e-mail without patch,
sending from an old mail address and calling you "Rusty".

The last version of the patch is attached. Please Ack it if it is OK
for you. If not, please let me know.

Andrew, please hold on a little bit to get the Ack from Russel.

Thank you all for your support and patience!

-- 
Catalin(ux) M BOIE
http://kernel.embedromix.ro/

--------------060903000008090702050909
Content-Type: text/plain;
 name="0001-Add-support-for-a-no-name-4-ports-multiserial-card.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Add-support-for-a-no-name-4-ports-multiserial-card.patc";
 filename*1="h"

>From fa0fceda773f553c2691f69ad989e81a3c5cc031 Mon Sep 17 00:00:00 2001
From: Catalin(ux) M BOIE <catab@embedromix.ro>
Date: Tue, 8 Apr 2008 00:59:20 +0300
Subject: [PATCH] Add support for a no-name 4 ports multiserial card

It is a no-name PCI card. I found no reference to a producer so I
used "UNKNOWN_0x1584" as the name.

Full lspci:
01:07.0 0780: 10b5:9050 (rev 01)
        Subsystem: 10b5:1584
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- \
                ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- \
                DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 1: I/O ports at ec00 [size=128]
        Region 2: I/O ports at e480 [size=32]
        Region 3: I/O ports at e400 [size=8]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA \
                        PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] #06 [0080]
        Capabilities: [4c] Vital Product Data

After:
0000:01:07.0: ttyS4 at I/O 0xe480 (irq = 10) is a 16550A
0000:01:07.0: ttyS5 at I/O 0xe488 (irq = 10) is a 16550A
0000:01:07.0: ttyS6 at I/O 0xe490 (irq = 10) is a 16550A
0000:01:07.0: ttyS7 at I/O 0xe498 (irq = 10) is a 16550A

Signed-off-by: Catalin(ux) M BOIE <catab@embedromix.ro>
---
 drivers/serial/8250_pci.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 788c355..b64a17c 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -769,6 +769,9 @@ pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
 #define PCI_SUBDEVICE_ID_POCTAL232	0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
 
+/* Unknown vendors/cards - this should not be in linux/pci_ids.h */
+#define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
+
 /*
  * Master list of serial port init/setup/exit quirks.
  * This does not describe the general nature of the port.
@@ -884,6 +887,15 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 	},
 	{
 		.vendor		= PCI_VENDOR_ID_PLX,
+		.device		= PCI_DEVICE_ID_PLX_9050,
+		.subvendor	= PCI_VENDOR_ID_PLX,
+		.subdevice	= PCI_SUBDEVICE_ID_UNKNOWN_0x1584,
+		.init		= pci_plx9050_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_plx9050_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_PLX,
 		.device		= PCI_DEVICE_ID_PLX_ROMULUS,
 		.subvendor	= PCI_VENDOR_ID_PLX,
 		.subdevice	= PCI_DEVICE_ID_PLX_ROMULUS,
@@ -2199,6 +2211,11 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_1077,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_4_921600 },
+	/* Unknown card - subdevice 0x1584 */
+	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
+		PCI_VENDOR_ID_PLX,
+		PCI_SUBDEVICE_ID_UNKNOWN_0x1584, 0, 0,
+		pbn_b0_4_115200 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_KEYSPAN,
 		PCI_SUBDEVICE_ID_KEYSPAN_SX2, 0, 0,
-- 
1.5.5.1


--------------060903000008090702050909--
