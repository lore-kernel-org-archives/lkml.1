Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbXCAOJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbXCAOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXCAOJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:09:58 -0500
Received: from 85-18-76-201.ip.fastwebnet.it ([85.18.76.201]:53957 "EHLO
	85-18-76-201.ip.fastwebnet.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbXCAOJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:09:57 -0500
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 09:09:57 EST
Message-ID: <45E6D7EB.5080501@robox.it>
Date: Thu, 01 Mar 2007 14:40:59 +0100
From: Marco Lazzarotto <m.lazzarotto@robox.it>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20070113)
X-Accept-Language: it, it-it, en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Trouble using some (fast) compact flash as ide device on an embedded
 system
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As I reported in bug 8036 in bugzilla.kernel.org,

Hardware Environment:

 - Use a compact flash SanDisk SDCFB-128 Firmware revision HDX 2.15
   (we used other compact flashes with the same hw ad sw for years
    with  no trouble)

It happens on both etx boards:
 - VIA SOM-ETX (4475)
 - Gene-4312

Doing the command
sfdisk -R /dev/hdc

gives:

 * * *
ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hdc: drive not ready for command
ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
hdc: do_special: 0x02
hdc: do_special: recalibrate
ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
hdc: reading: block=0 sectors=8, buffer = 0xc6cd40000
ide1: end_request: current=0xc6ebe754
 * * *

the 'bad bit' in status error is DataRequest



doing
sfdisk -l /dev/hdc

gives:

 * * *
ide1: start_request: current=0xc6ebecd4 (rq->sect=0,block 0)
hdc: reading: block=0, sectors=32, buffer=0xc6f37000
hdc: lost interrupt
hdc: lost interrupt [and so on several times]
 * * *

I have no knowledge of the internals of the linux kernel, but I'm a
programmer and have both hardware and time to spend on solving this issue.

Thanks for suggestions...

	Marco Lazzarotto
	Robox s.p.a.

-- 
 *------------------------------------------------------------------*
 | Vi preghiamo, se questo messaggio fosse ricevuto per errore,     |
 | di avvisare il mittente e, tenuto conto delle responsabilita'    |
 | connesse all'indebito utilizzo e/o divulgazione del messaggio    |
 | e/o delle informazioni in esso contenute, di cancellare          |
 | l'originale e distruggere le varie copie o stampe. Grazie        |
 *------------------------------------------------------------------*
 | The information in this e-mail is solely for the addressee.      |
 | Please delete this e-mail if you are not the intended recipient. |
 | Do not disclose or distribute the communication in any form.     |
 *------------------------------------------------------------------*
