Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYDNECe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYDNECe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYDNEC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:02:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.112.145]:8699 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYDNECZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:02:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Sun, 13 Apr 2008 21:02:21 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Mon, 14 Apr 2008 12:02:01 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B26C11B8C@hkemmail01.nvidia.com>
In-Reply-To: <480013A3.1010502@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Thread-Index: AcicPpOHIXUlF+KmQTGrFaScyq3u/QBpYjLg
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804031347.20352.volker.armin.hemmann@tu-clausthal.de> <47FEFFC6.4@gmail.com> <200804111355.55364.volker.armin.hemmann@tu-clausthal.de> <48000FF8.300@gmail.com> <480013A3.1010502@garzik.org>
From: "Peer Chen" <pchen@nvidia.com>
To: "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>
Cc: "Volker Armin Hemmann" <volker.armin.hemmann@tu-clausthal.de>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Kuan Luo" <kluo@nvidia.com>
X-OriginalArrivalTime: 14 Apr 2008 04:02:02.0090 (UTC) FILETIME=[4B43D4A0:01C89DE4]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker,
Could you add a delay between setting AHCI_EN and reading back function?

BRs
Peer Chen

-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Saturday, April 12, 2008 9:43 AM
To: Tejun Heo
Cc: Volker Armin Hemmann; linux-kernel@vger.kernel.org;
linux-ide@vger.kernel.org; Peer Chen; Kuan Luo
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3

Tejun Heo wrote:
> Volker Armin Hemmann wrote:
>> Hi,
>>
>>> Aiee.... Can you please try 2.6.25-rc8 with both configurations?
And
>>> w/o systemrescuecd?  Just seeing whether things mount properly or
not is
>>> good enough.  There isn't much risk of losing data.
>>
>> 2.6.25-rc8 is a 'no change'. AHCI+pci=nomsi boots, AHCI without
hangs.
>> with AHCI I also get this:
>>
>> [    0.363828] ------------[ cut here ]------------
>> [    0.363828] WARNING: at drivers/ata/ahci.c:645 
>> ahci_init_one+0x190/0xa3a()
>> [    0.363828] Modules linked in:
>> [    0.363828] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #2
> 
> Heh.. that's AHCI_EN not getting set.  Peer, any ideas?  The driver
set 
> AHCI_EN in the HOST_CTL register but on reading back it's still clear.

Possibly the hardware is not idle?  I wonder if the BIOS is doing 
anything with the IDE interface.  _Probably_ not, but that is certainly 
a situation where switching to AHCI can be a problem for certain AHCI
chips.

	Jeff



-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
