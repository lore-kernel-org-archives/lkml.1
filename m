Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZBVLSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZBVLSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZBVLSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:18:13 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:51702 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZBVLSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:18:10 -0500
Date: Sun, 22 Feb 2009 11:18:07 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090222111807.GB5538@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing a linux-tip from yesterday, a
BUG kmalloc-4096: Poison overwritten
warning appeared inside dmesg. I'm not aware of what I was doing other
that browsing a few web pages and using ssh in the lead up to it. Output
is attached below:

[ 3666.410818] ath5k phy0: unsupported jumbo
[ 4432.305651] ath5k phy0: unsupported jumbo
[ 4466.022644] totem[4664]: segfault at 5bf7b980 ip b5b39cbb sp b0d5f130 error 6 in libpulse.so.0.4.1[b5afb000+4d000]
[ 4617.353923] totem[5189]: segfault at 4c7a2ee0 ip b59bfdca sp b1c12ec0 error 6 in libpulse.so.0.4.1[b5981000+4d000]
[ 7412.846146] =============================================================================
[ 7412.846159] BUG kmalloc-4096: Poison overwritten
[ 7412.846163] -----------------------------------------------------------------------------
[ 7412.846166] 
[ 7412.846172] INFO: 0xf6438010-0xf6438053. First byte 0x80 instead of 0x6b
[ 7412.846188] INFO: Allocated in dev_alloc_skb+0x21/0x40 age=629 cpu=0 pid=0
[ 7412.846197] INFO: Freed in skb_release_data+0x5e/0x90 age=21 cpu=0 pid=0
[ 7412.846204] INFO: Slab 0xc17a27e0 objects=7 used=5 fp=0xf6438000 flags=0x400020c3
[ 7412.846210] INFO: Object 0xf6438000 @offset=0 fp=0xf643a060
[ 7412.846212] 
[ 7412.846216]   Object 0xf6438000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846245]   Object 0xf6438010:  80 00 00 00 ff ff ff ff ff ff 00 30 ab 1a 32 3f ....ÿÿÿÿÿÿ.0«.2?
[ 7412.846273]   Object 0xf6438020:  00 30 ab 1a 32 3f e0 24 59 62 25 b5 01 00 00 00 .0«.2?à$Yb%µ....
[ 7412.846301]   Object 0xf6438030:  64 00 31 00 00 08 57 69 72 65 6c 65 73 73 01 04 d.1...Wireless..
[ 7412.846329]   Object 0xf6438040:  82 84 8b 96 03 01 06 05 04 01 02 00 00 55 fa af .............Uú¯
[ 7412.846357]   Object 0xf6438050:  5d 55 fa 5d 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ]Uú]kkkkkkkkkkkk
[ 7412.846385]   Object 0xf6438060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846412]   Object 0xf6438070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846440]   Object 0xf6438080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846468]   Object 0xf6438090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846495]   Object 0xf64380a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846523]   Object 0xf64380b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846551]   Object 0xf64380c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846578]   Object 0xf64380d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846606]   Object 0xf64380e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846633]   Object 0xf64380f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846661]   Object 0xf6438100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846689]   Object 0xf6438110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846716]   Object 0xf6438120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846744]   Object 0xf6438130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846772]   Object 0xf6438140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846799]   Object 0xf6438150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846827]   Object 0xf6438160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846855]   Object 0xf6438170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846882]   Object 0xf6438180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846910]   Object 0xf6438190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846938]   Object 0xf64381a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846965]   Object 0xf64381b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.846993]   Object 0xf64381c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847020]   Object 0xf64381d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847048]   Object 0xf64381e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847076]   Object 0xf64381f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64382a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64382b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64382c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64382d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64382e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64382f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64383a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64383b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64383c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64383d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64383e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64383f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64384a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64384b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64384c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64384d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64384e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64384f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64385a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64385b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64385c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64385d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64385e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64385f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64386a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64386b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64386c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64386d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64386e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64386f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64387a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64387b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64387c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64387d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64387e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64387f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64388a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64388b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64388c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64388d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64388e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64388f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64389a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64389b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64389c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64389d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64389e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf64389f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438a90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438aa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438af0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438b90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438bc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438bd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438cf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438da0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438db0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438dc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438dd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438de0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438df0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438e90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438eb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438fa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438fb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438fc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 7412.847091]   Object 0xf6438ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[ 7412.847091]  Redzone 0xf6439000:  bb bb bb bb                                     »»»»            
[ 7412.847091]  Padding 0xf6439028:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[ 7412.847091] Pid: 0, comm: swapper Not tainted 2.6.29-rc5-tip-01971-g83f59cb #64
[ 7412.847091] Call Trace:
[ 7412.847091]  [<c0189294>] print_trailer+0xb4/0xf0
[ 7412.847091]  [<c0189377>] check_bytes_and_report+0xa7/0xd0
[ 7412.847091]  [<c018959e>] check_object+0x1ae/0x1f0
[ 7412.847091]  [<c018b2e2>] __slab_alloc+0x4a2/0x550
[ 7412.847091]  [<c011f6f2>] ? kmemcheck_mark_uninitialized+0x12/0x20
[ 7412.847091]  [<c018c337>] __kmalloc_track_caller+0x137/0x140
[ 7412.847091]  [<c038e951>] ? dev_alloc_skb+0x21/0x40
[ 7412.847091]  [<c038e951>] ? dev_alloc_skb+0x21/0x40
[ 7412.847091]  [<c038e2ce>] __alloc_skb+0x4e/0x100
[ 7412.847091]  [<c038e951>] dev_alloc_skb+0x21/0x40
[ 7412.847091]  [<c02eb858>] ath5k_rx_skb_alloc+0x28/0x1c0
[ 7412.847091]  [<c040fbde>] ? _spin_lock+0x3e/0x50
[ 7412.847091]  [<c02ed12d>] ath5k_tasklet_rx+0x15d/0x700
[ 7412.847091]  [<c014b62b>] ? trace_hardirqs_off+0xb/0x10
[ 7412.847091]  [<c04100ac>] ? _spin_unlock_irqrestore+0x3c/0x60
[ 7412.847091]  [<c02e3edb>] ? ath5k_hw_get_isr+0x6b/0x3d0
[ 7412.847091]  [<c02e4267>] ? ath5k_hw_is_intr_pending+0x27/0x60
[ 7412.847091]  [<c02eddc3>] ? ath5k_intr+0x103/0x310
[ 7412.847091]  [<c012f984>] tasklet_action+0x44/0x90
[ 7412.847091]  [<c012fb28>] __do_softirq+0x68/0x110
[ 7412.847091]  [<c040faf2>] ? _spin_unlock+0x22/0x30
[ 7412.847091]  [<c015760d>] ? handle_fasteoi_irq+0x9d/0xe0
[ 7412.847091]  [<c012fc25>] do_softirq+0x55/0x60
[ 7412.847091]  [<c012fd4c>] irq_exit+0x6c/0x80
[ 7412.847091]  [<c04104d7>] do_IRQ+0x47/0x90
[ 7412.847091]  [<c0103875>] common_interrupt+0x35/0x3c
[ 7412.847091]  [<c028040c>] ? acpi_idle_enter_bm+0x1ec/0x21d
[ 7412.847091]  [<c035bdac>] cpuidle_idle_call+0x6c/0xc0
[ 7412.847091]  [<c0102041>] cpu_idle+0x81/0xa0
[ 7412.847091]  [<c04045bd>] rest_init+0x4d/0x60
[ 7412.847091] FIX kmalloc-4096: Restoring 0xf6438010-0xf6438053=0x6b
[ 7412.847091] 
[ 7412.847091] FIX kmalloc-4096: Marking all objects used
[ 7435.711659] ath5k phy0: unsupported jumbo
[ 8125.567136] ath5k phy0: noise floor calibration timeout (2417MHz)

-- 
Sitsofe | http://sucs.org/~sits/
