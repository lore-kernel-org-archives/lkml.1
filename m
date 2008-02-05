Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYBEGOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYBEGOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYBEGN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:13:57 -0500
Received: from mail.kapp-coburg.de ([217.24.55.52]:51175 "EHLO
	mail.kapp-coburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbYBEGN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:13:56 -0500
X-Greylist: delayed 1657 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 01:13:56 EST
Message-ID: <47A7F828.1010303@niles.de>
Date: Tue, 05 Feb 2008 06:46:16 +0100
From: "Mader, Alexander (N-MSR)" <Alexander.Mader@niles.de>
Organization: NILES Werkzeugmaschinen GmbH
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Unable to access PCMCIA with O2 Micro OZ711MP1/MS1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after contacting linux-pcmcia and some search I am approaching lkml.

There seems to be a problem accessing PCMCIA cards with O2 Micro 
OZ711MP1/MS1 Controller.

On a Fujitsu Siemens Celsius H240 a 2.6.22-3-amd64 kernel from Debian 
testing is in use. PCMCIA utilities for Linux 2.6 version 014-4 are 
installed. I could supply the output of lspci and lshal.

When I insert a CardBus adapter, for instance a CNET CNF401 fast 
ethernet, everything works fine and the adapter becomes available to the 
system -- in this example the NIC with working LAN access. The lspci and 
lshal output then reflects the new hardware.

When I insert a PCMCIA adapter, for instance a 3com 3CCE589EC, a 3com 
3C589C or an compact flash adapter, almost nothing happens: In the case 
of the 3com I just get (dmesg):

	pccard: PCMCIA card inserted into slot 0

In the case of the compact flash adapter at the first insert dmesg gives:

pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xfffff
cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
cs: memory probe 0x88000000-0x8fffffff: excluding 0x88000000-0x8fffffff
cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
cs: memory probe 0xf0300000-0xf03fffff: excluding 0xf0300000-0xf03fffff

Later on dmesg just issues "pccard: PCMCIA card inserted into slot 0" 
when the same card is inserted no matter how often.

In the PCMCIA cases the lshal output doesn't change, but in the lspci 
output the original line changes from:

	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+
	PostWrite+                                  ^^^^^^

to:

	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+
	PostWrite+                                  ^^^^^^

In the case of the compact flash adapters neither "modprobe ide_cs" nor 
"modprobe pata_pcmcia" yield anything -- not even in dmesg.

As I do not want to access a SmartCard I did not try the o2scr driver 
from gna.org/projects/o2scr.

If I could supply more data I would like to do so on your request.

Best regards, Alexander.

