Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbXKFK2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbXKFK2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXKFK2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:28:18 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:45625 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbXKFK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:28:17 -0500
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <1194343121.6953.6.camel@rukbat>
References: <1193918202.8439.7.camel@rukbat>
	 <20071102182833.2c055446@poseidon.drzeus.cx>
	 <1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com>
	 <1194259886.6927.9.camel@localhost>
	 <20071105132218.495f244e@poseidon.drzeus.cx>
	 <1194270393.27789.2.camel@localhost>
	 <20071105162633.09e54290@poseidon.drzeus.cx>
	 <1194343121.6953.6.camel@rukbat>
Content-Type: text/plain; charset=ISO-8859-15
Date: Tue, 06 Nov 2007 11:28:15 +0100
Message-Id: <1194344895.20469.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(Nick re-added to the Cc: list; sorry, I dropped you without noticing) 

On Tue, 2007-11-06 at 10:58 +0100, Romano Giannetti wrote:
> Hi, 
> 
> I have some more data. I really start to think that the mmc layer is
> busted. I repeated a dd of the device, unmounted, five or six times in a
> row, and look:

[ dd if=/dev/mmcblk0  bs=1c count=128 | od -h output differs from time to time ]

> I really do not think this is normal. I will try to reboot to 2.6.23
> and to see what's happening... 
> 

Tried it. The card is corrupted now, the vfat filesystem panics and a
directory is changed into a file; but the dd results are everytime the
same... the vfat error is:

SYS: Nov  6 11:04:10 rukbat hald: mounted /dev/mmcblk0p1 on behalf of uid 1153
SYS: Nov  6 11:04:10 rukbat kernel: [  126.597563] FAT: Filesystem panic (dev mmcblk0p1)
SYS: Nov  6 11:04:10 rukbat kernel: [  126.597572]     fat_get_cluster: invalid cluster chain (i_pos 0)
SYS: Nov  6 11:04:10 rukbat kernel: [  126.597577]     File system has been set read-only
SYS: Nov  6 11:04:11 rukbat kernel: [  127.705440] FAT: Filesystem panic (dev mmcblk0p1)
SYS: Nov  6 11:04:11 rukbat kernel: [  127.705448]     fat_get_cluster: invalid cluster chain (i_pos 0)

The first difference between the good and bad data is here: 

--- good.txt    2007-11-06 11:20:59.000000000 +0100
+++ bad.txt     2007-11-06 11:20:49.000000000 +0100
@@ -48,7 +48,7 @@
 0141720 6120 796e 6b20 7965 7720 6568 206e 6572
 0141740 6461 0d79 000a 4f49 2020 2020 2020 5953
 0141760 4d53 4453 534f 2020 5320 5359 0000 aa55
-0142000 fff8 ffff ffff ffff 0005 0006 0007 0008
+0142000 fff8 ffff 0000 ffff 0005 0006 0007 0008
 0142020 0009 000a 000b 000c 000d 000e 000f 0010
 0142040 0011 0012 0013 0014 0015 0016 0017 0018
 0142060 0019 001a 001b 001c 001d 001e 001f 0020
@@ -64,7 +64,7 @@
 0142320 0069 006a 006b ffff 0000 0000 0000 0000
 0142340 0000 0000 0000 0000 0000 0000 0000 0000
 *
-0201000 fff8 ffff ffff ffff 0005 0006 0007 0008
+0201000 fff8 ffff 0000 ffff 0005 0006 0007 0008
 0201020 0009 000a 000b 000c 000d 000e 000f 0010
 0201040 0011 0012 0013 0014 0015 0016 0017 0018
 0201060 0019 001a 001b 001c 001d 001e 001f 0020


Well... what now? 

	Romano 




-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
