Return-Path: <linux-kernel-owner+w=401wt.eu-S1161318AbXCNPC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161318AbXCNPC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXCNPC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:02:59 -0400
Received: from web36714.mail.mud.yahoo.com ([209.191.85.48]:40280 "HELO
	web36714.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161318AbXCNPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:02:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rq5FkRrOkGlA7CuuWtyLbQdfGbcTNKYUYFmZ6jxwkm/E/ISxbYoOnZfeKSJmAUWlAOijfAegLsP7TekOTBjd8Wt+p7ALuw3lEmDnlmt997ZYWskyyEq742AKDZA7i0I84zd1uGTSLcOdbRpvK0/wm+xg2skrK7rIUAoWrTjPeKA=  ;
Message-ID: <20070314150254.22941.qmail@web36714.mail.mud.yahoo.com>
X-YMail-OSG: HqrhVlIVM1kJo._0eZp0KYbkTOAhDn.AWFJOy8xBn3mzSNJZ221l9cOFbkYehtumuHh1SZTLcxvbhmR3Ow6WxePJgAlyQO74.ut63mAVabRNlojNqQ.7GHzeVa0ZXZso1qAggkqsm3mi2PCzoWpATRujog--
Date: Wed, 14 Mar 2007 08:02:54 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Weird MMC errors: 2 of 2 - inconsistent state after data crc error
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Problem 2: After a data crc error all subsequent commands fail. May it be caused by stop command
leaving card in some bad state (something clearable by SEND_STATUS)? On the other hand, is there a
real need to issue a stop command in case main command failed?

---- Example: ----
Mar 14 09:25:13 Tirion kernel:  mmcblk0:<7>mmc0: starting CMD18 arg 00000000 flags 00000035
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: setting dma for 8 blocks
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x12, arg: 0x0, mask: 0xb100
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 1, flags 0
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 40, flags 1
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0xc, arg: 0x0, mask: 0x2900
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 80, flags 9
Mar 14 09:25:13 Tirion kernel: mmc0: req done (CMD18): 0/2/1: 00000900 00000000 00000000 00000000
Mar 14 09:25:13 Tirion kernel: mmcblk0: error 2 transferring data
Mar 14 09:25:13 Tirion kernel: end_request: I/O error, dev mmcblk0, sector 0
Mar 14 09:25:13 Tirion kernel: printk: 342 messages suppressed.
Mar 14 09:25:13 Tirion kernel: Buffer I/O error on device mmcblk0, logical block 0
Mar 14 09:25:13 Tirion kernel: mmc0: starting CMD18 arg 00000000 flags 00000035
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: setting dma for 8 blocks
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x12, arg: 0x0, mask: 0xb100
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 80, flags 0
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0xc, arg: 0x0, mask: 0x2900
Mar 14 09:25:13 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 80, flags 8
Mar 14 09:25:13 Tirion kernel: mmc0: req done (CMD18): 1/0/1: 00000000 00000000 00000000 00000000



 
____________________________________________________________________________________
Sucker-punch spam with award-winning protection. 
Try the free Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/features_spam.html
