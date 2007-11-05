Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXKERYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXKERYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760369AbXKERS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:18:28 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:36805 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433AbXKERSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:18:25 -0500
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071105162633.09e54290@poseidon.drzeus.cx>
References: <1193918202.8439.7.camel@rukbat>
	 <20071102182833.2c055446@poseidon.drzeus.cx>
	 <1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com>
	 <1194259886.6927.9.camel@localhost>
	 <20071105132218.495f244e@poseidon.drzeus.cx>
	 <1194270393.27789.2.camel@localhost>
	 <20071105162633.09e54290@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 05 Nov 2007 18:18:22 +0100
Message-Id: <1194283102.15031.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-05 at 16:26 +0100, Pierre Ossman wrote:
> On Mon, 05 Nov 2007 14:46:33 +0100
> Romano Giannetti <romanol@upcomillas.es> wrote:
> 
> > 
> > On Mon, 2007-11-05 at 13:22 +0100, Pierre Ossman wrote:
> > > Did you partition and format this card in the camera or in Linux?
> > 
> > In the camera. It happened both with a Kodak and a Panasonic Lumix. 
> > 
> 
> Does it work if you partition and format it in Linux?

Well. Now I am quite surprised. I did the following... obtained an image
of the same chip, formatted by the camera, both under 2.6.23 and
2.6.24-rc1 [1], after umounting the volume, and:

(130)pern:~/software/toshiba/lk2624-rc1-mmc2% od -h image_camera_23.img | head
0000000 befa 7c00 00bf b97a 0100 0efc 0e1f f307
0000020 eaa5 7a16 0000 bebb 337b 80c9 803f 0675
0000040 c5fe f38b 07eb 3f80 7500 fe02 83c1 10c3
0000060 fb81 7bfe e572 f983 7404 810b 03f9 7401
0000100 bb0a 7aa5 2ceb 87bb eb7a 8b27 024c 148b
0000120 01b8 bb02 7c00 13cd 0573 bcbb eb7a 2e13
0000140 fea1 3d7d aa55 0574 bcbb eb7a ea05 7c00
0000160 0000 8a2e 3c07 7400 530c 07bb b400 cd0e
0000200 5b10 eb43 ebed 00fe 0000 0000 0000 0000
0000220 0000 0000 0000 0000 0000 0000 0000 0000
(0)pern:~/software/toshiba/lk2624-rc1-mmc2% od -h image_camera_24.img | head
0000000 7000 010a 004a 0000 2303 0eb8 0015 002a
0000020 7000 010d 1fdd 0000 2303 0ebc 0015 0008
0000040 7000 011c 002d 0000 2303 0ef4 8e15 0007
0000060 7000 011f 1d47 0000 2303 0f80 1315 0045
0000100 7000 013a 1fed 0000 2303 0f80 4015 0028
0000120 7000 013b 004a 0000 2303 0f84 d815 001d
0000140 7000 013c 004a 0000 2303 0f88 7015 003f
0000160 7000 0141 20c0 0000 2303 0f8c 1415 0029
0000200 7000 0143 004a 0000 2303 0f90 6315 0000
0000220 7000 014f 004a 0000 2303 0f94 7115 002d

Uf. So I reformatted (under 2.6.23) the partition p1, and now the card
works both under 2.6.23 and 2.6.24 (although now it's not detected as a
photo card, but I suppose that's normal). But again...

(0)pern:~/software/toshiba/lk2624-rc1-mmc2% od -h image_linux_23.img | head
0000000 befa 7c00 00bf b97a 0100 0efc 0e1f f307
0000020 eaa5 7a16 0000 bebb 337b 80c9 803f 0675
0000040 c5fe f38b 07eb 3f80 7500 fe02 83c1 10c3
0000060 fb81 7bfe e572 f983 7404 810b 03f9 7401
0000100 bb0a 7aa5 2ceb 87bb eb7a 8b27 024c 148b
0000120 01b8 bb02 7c00 13cd 0573 bcbb eb7a 2e13
0000140 fea1 3d7d aa55 0574 bcbb eb7a ea05 7c00
0000160 0000 8a2e 3c07 7400 530c 07bb b400 cd0e
0000200 5b10 eb43 ebed 00fe 0000 0000 0000 0000
0000220 0000 0000 0000 0000 0000 0000 0000 0000
(0)pern:~/software/toshiba/lk2624-rc1-mmc2% od -h image_linux_24.img | head
0000000 dd65 6ffc 0000 dffd ebf3 382d 0040 fbbe
0000020 472b e3d7 0000 5acb 7fd9 ef5f 0000 7fd7
0000040 b7ed aff9 0000 af67 594e ffbb 0100 7a7f
0000060 546a 03d5 0800 6fd5 f9ef 1f3e 0000 ffdf
0000100 85bd 8c8d 617d c01b cd88 1901 1f5e 09b0
0000120 06c9 f7e3 0c6d d827 a376 0b6d 1b5c 7f42
0000140 8df0 3918 4a53 9923 5305 6f5f 2101 4043
0000160 f052 9dc9 8005 102e faf1 0e0e 377d 8b8f
0000200 bb19 dacf 0000 3d7f 6ffb f0ff 0040 cdb3
0000220 cd4b b346 4000 e9f7 ee6d eade 4000 e6ff

Shouldn't they be equal? I have no camera handy now, I will try again.
If it's of some interested, I've put the images on line on 

http://www.dea.icai.upcomillas.es/romano/linux/info/lk2624-rc1-mmc2/


I tried to loop mount them, but I forgot how can I mount a partition of
a loop device... I have loop0 but not loop0p1... there where a "seek"
magic but I cannot find it now.

	Romano 


[1] dd if=/dev/mmcblk0 of=file bs=1M count=128



-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
