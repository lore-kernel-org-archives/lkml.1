Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbXKFJ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbXKFJ6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXKFJ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:58:45 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:44973 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXKFJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:58:44 -0500
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
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 06 Nov 2007 10:58:41 +0100
Message-Id: <1194343121.6953.6.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

I have some more data. I really start to think that the mmc layer is
busted. I repeated a dd of the device, unmounted, five or six times in a
row, and look:

(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.0112835 seconds, 11.3 kB/s
0000000 0000 0000 31e4 c363 d908 cb2e 0000 0000
0000020 9550 c217 2a10 c012 0100 0010 0200 0020
0000040 25a8 cb45 af00 cb2a 0000 0000 9550 c217
0000060 2a10 c012 0100 0010 0200 0020 02e0 cb45
0000100 6db8 cb2d 0000 0000 9550 c217 2a10 c012
0000120 0100 0010 0200 0020 ed00 cb4a 70b0 cba5
0000140 0000 0000 9550 c217 2a10 c012 0100 0010
0000160 0200 0020 3058 cb7e 7730 cb28 0000 0000
0000200
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% uname -a
Linux rukbat 2.6.24-rc1 #7 SMP Sun Oct 28 23:51:49 CET 2007 i686 GNU/Linux
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
0000000 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.0114972 seconds, 11.1 kB/s
*
0000200
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.0112756 seconds, 11.4 kB/s
0000000 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b
*
0000200
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
0000000 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b
*
0000200
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.0121104 seconds, 10.6 kB/s
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.0112943 seconds, 11.3 kB/s
0000000 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b 6b6b
*
0000200
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.0112721 seconds, 11.4 kB/s
0000000 0000 0000 71e4 c36f d908 cb2e 0000 0000
0000020 9550 c217 2a10 c012 0100 0010 0200 0020
0000040 25a8 cb45 af00 cb2a 0000 0000 9550 c217
0000060 2a10 c012 0100 0010 0200 0020 02e0 cb45
0000100 6db8 cb2d 0000 0000 9550 c217 2a10 c012
0000120 0100 0010 0200 0020 ed00 cb4a 70b0 cba5
0000140 0000 0000 9550 c217 2a10 c012 0100 0010
0000160 0200 0020 3058 cb7e 7730 cb28 0000 0000
0000200
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.0112219 seconds, 11.4 kB/s
0000000 0000 0000 f1e4 c37b d908 cb2e 0000 0000
0000020 9550 c217 2a10 c012 0100 0010 0200 0020
0000040 25a8 cb45 af00 cb2a 0000 0000 9550 c217
0000060 2a10 c012 0100 0010 0200 0020 02e0 cb45
0000100 6db8 cb2d 0000 0000 9550 c217 2a10 c012
0000120 0100 0010 0200 0020 ed00 cb4a 70b0 cba5
0000140 0000 0000 9550 c217 2a10 c012 0100 0010
0000160 0200 0020 3058 cb7e 7730 cb28 0000 0000
0000200
(0)rukbat:~/software/toshiba/lk2624-rc1-mmc2% sudo dd if=/dev/mmcblk0  bs=1c count=128 | od -h
128+0 records in
128+0 records out
128 bytes (128 B) copied, 0.011198 seconds, 11.4 kB/s
0000000 3038 3030 3030 000a 0000 0000 0000 0000
0000020 0000 0000 0000 0000 0000 0000 0000 0000
*
0000200

I really do not think this is normal. I will try to reboot to 2.6.23 and to see what's happening... 

I saw in the changelog that there were changes w/ respect to DMA; maybe
these changes are the most probable culprit. 


Romano 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
