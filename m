Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXKEKvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXKEKvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXKEKvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:51:31 -0500
Received: from ic0245.upco.es ([130.206.70.245]:56200 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbXKEKva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:51:30 -0500
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: Roland Dreier <rdreier@cisco.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
In-Reply-To: <ada8x5ec7oh.fsf@cisco.com>
References: <1193918202.8439.7.camel@rukbat>
	 <20071102182833.2c055446@poseidon.drzeus.cx>
	 <1194168583.10245.15.camel@rukbat>  <ada8x5ec7oh.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 05 Nov 2007 11:51:26 +0100
Message-Id: <1194259886.6927.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-11-04 at 08:11 -0800, Roland Dreier wrote:
> I had something similar recently, trying to access an SD card in the
> internal drive of my thinkpad X60.  Fortunately, the data wasn't
> actually corrupted, but when I tried to copy the picture files off the
> card, I saw garbage filenames in the picture directory, [...]

> When I put the same card back in the camera and used the camera's dock
> to access the data via USB mass storage, everything worked fine.  So
> it does seem to be at least somewhat MMC-related.

It is reproducible for me, too, with the 128Mbyte card. Full logs are
here:

http://www.dea.icai.upcomillas.es/romano/linux/info/lk2624-rc1-mmc2/

a rapid grep shows at boot: 

Nov  5 08:45:40 rukbat kernel: [   26.538165] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Nov  5 08:45:40 rukbat kernel: [   38.456554] PM: Adding info for No Bus:mmc0
Nov  5 08:45:40 rukbat kernel: [   38.456634] mmc0: SDHCI at 0xd0100800 irq 16 DMA

and when loading the card: 

Nov  5 09:21:14 rukbat kernel: [ 1632.002723] mmc0: new SD card at address e32f
Nov  5 09:21:14 rukbat kernel: [ 1632.002947] PM: Adding info for mmc:mmc0:e32f
Nov  5 09:21:14 rukbat kernel: [ 1632.024011] mmcblk0: mmc0:e32f SD128 123008KiB 
Nov  5 09:21:14 rukbat kernel: [ 1632.025327]  mmcblk0: p1
Nov  5 09:21:15 rukbat hald: mounted /dev/mmcblk0p1 on behalf of uid 1153

(I've trimmed away the spam by NetworkManager). 

and opening the folder in Nautilus:

Nov  5 09:21:43 rukbat kernel: [ 1654.235333] FAT: Filesystem panic (dev mmcblk0p1)
Nov  5 09:21:43 rukbat kernel: [ 1654.235893] FAT: Filesystem panic (dev mmcblk0p1)
Nov  5 09:21:43 rukbat kernel: [ 1654.235915] mmcblk0p1: rw=0, want=575135, limit=245919
...ad libitum.

and it's definitely a regression, the card is read under 2.6.23. I've
not a lot of time in my hands now, but maybe the next weekend I can try
a bisection...

Romano 



-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
