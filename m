Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZGOQwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZGOQwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZGOQwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:52:30 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56261 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbZGOQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:52:28 -0400
From: Christian =?iso-8859-1?q?Borntr=E4ger?= <borntraeger@de.ibm.com>
To: Mike Snitzer <snitzer@redhat.com>
Subject: regression post 2.6.30: device mapper fails on some logical volumes
Date: Wed, 15 Jul 2009 18:52:04 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-release; KDE/4.2.4; i686; ; )
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Organization: IBM
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/kgXKRV6SspfC1c"
Message-Id: <200907151852.15121.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_/kgXKRV6SspfC1c
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Mike,

your patch
commit 754c5fc7ebb417b23601a6222a6005cc2e7f2913
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Mon Jun 22 10:12:34 2009 +0100

    dm: calculate queue limits during resume not load

causes some problems during startup (/sbin/lvm vgchange -a y) on my s390 system.
The logical volumes space-home and space-test dont come up (device-mapper: 
resume ioctl faile: Invalid argument) and dmesg has:

[    4.450974] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-
devel@redhat.com                                                                           
[    4.567024] device-mapper: table: 253:0: target device dasdf1 is misaligned                                                                                            
[    4.567031] device-mapper: table: 253:0: target device dasde1 is misaligned                                                                                            
[    4.567036] device-mapper: table: 253:0: target device dasdf1 is misaligned                                                                                            
[    4.567042] device-mapper: table: 253:0: target device dasde1 is misaligned                                                                                            
[    4.589196] device-mapper: table: 253:1: target device dasdf1 is misaligned                                                                                            
[    4.589202] device-mapper: table: 253:1: target device dasde1 is misaligned                                                                                            
[    4.589208] device-mapper: table: 253:1: target device dasdf1 is misaligned                                                                                            
[    4.589214] device-mapper: table: 253:1: target device dasde1 is misaligned                                                                                            
[    4.611440] device-mapper: table: 253:2: target device dasdf1 is misaligned                                                                                            
[    4.611446] device-mapper: table: 253:2: target device dasde1 is misaligned                                                                                            
[    4.611452] device-mapper: table: 253:2: target device dasdf1 is misaligned                                                                                            
[    4.611457] device-mapper: table: 253:2: target device dasde1 is misaligned                                                                                            
[    4.633804] device-mapper: table: 253:3: target device dasdf1 is misaligned                                                                                            
[    4.633810] device-mapper: table: 253:3: target device dasde1 is misaligned                                                                                            
[    4.633816] device-mapper: table: 253:3: target device dasdf1 is misaligned                                                                                            
[    4.633821] device-mapper: table: 253:3: target device dasde1 is misaligned                                                                                            
[    4.656035] device-mapper: table: 253:4: target device dasdf1 is misaligned                                                                                            
[    4.656040] device-mapper: table: 253:4: target device dasde1 is misaligned                                                                                            
[    4.656046] device-mapper: table: 253:4: target device dasdf1 is misaligned                                                                                            
[    4.656052] device-mapper: table: 253:4: target device dasde1 is misaligned                                                                                            
[    4.678408] device-mapper: table: 253:5: target device dasdf1 is misaligned                                                                                            
[    4.678413] device-mapper: table: 253:5: target device dasde1 is misaligned                                                                                            
[    4.678419] device-mapper: table: 253:5: target device dasdf1 is misaligned                                                                                            
[    4.678424] device-mapper: table: 253:5: target device dasde1 is misaligned                                                                                            
[    4.700951] device-mapper: table: 253:6: target device dasdf1 is misaligned                                                                                            
[    4.700957] device-mapper: table: 253:6: target device dasde1 is misaligned                                                                                            
[    4.700962] device-mapper: table: 253:6: target device dasdf1 is misaligned                                                                                            
[    4.700968] device-mapper: table: 253:6: target device dasde1 is misaligned                                                                                            
[    4.723516] device-mapper: table: 253:7: target device dasdf1 is misaligned                                                                                            
[    4.723522] device-mapper: table: 253:7: target device dasde1 is misaligned                                                                                            
[    4.723527] device-mapper: table: 253:7: target device dasdf1 is misaligned                                                                                            
[    4.723533] device-mapper: table: 253:7: target device dasde1 is misaligned                                                                                            
[    4.746748] device-mapper: table: 253:8: target device dasdf1 is misaligned                                                                                            
[    4.746754] device-mapper: table: 253:8: target device dasde1 is misaligned                                                                                            
[    4.746760] device-mapper: table: 253:8: target device dasdf1 is misaligned                                                                                            
[    4.746765] device-mapper: table: 253:8: target device dasde1 is misaligned                                                                                            
[    4.769524] device-mapper: table: 253:9: target device dasdf1 is misaligned                                                                                            
[    4.769530] device-mapper: table: 253:9: target device dasde1 is misaligned                                                                                            
[    4.769536] device-mapper: table: 253:9: target device dasdf1 is misaligned                                                                                            
[    4.769541] device-mapper: table: 253:9: target device dasde1 is misaligned                                                                                            
[    4.792364] device-mapper: table: 253:10: target device dasdf1 is misaligned                                                                                           
[    4.792370] device-mapper: table: 253:10: target device dasde1 is misaligned                                                                                           
[    4.792375] device-mapper: table: 253:10: target device dasdf1 is misaligned                                                                                           
[    4.792381] device-mapper: table: 253:10: target device dasde1 is misaligned                                                                                           
[    4.815425] device-mapper: table: 253:11: target device dasdf1 is misaligned                                                                                           
[    4.815431] device-mapper: table: 253:11: target device dasde1 is misaligned                                                                                           
[    4.815437] device-mapper: table: 253:11: target device dasdf1 is misaligned                                                                                           
[    4.815442] device-mapper: table: 253:11: target device dasde1 is misaligned                                                                                           
[    4.838585] device-mapper: table: 253:12: target device dasdf1 is misaligned                                                                                           
[    4.838591] device-mapper: table: 253:12: target device dasde1 is misaligned                                                                                           
[    4.838597] device-mapper: table: 253:12: target device dasdf1 is misaligned                                                                                           
[    4.838602] device-mapper: table: 253:12: target device dasde1 is misaligned                                                                                           
[    4.861830] device-mapper: table: 253:13: target device dasdf1 is misaligned                                                                                           
[    4.861836] device-mapper: table: 253:13: target device dasde1 is misaligned                                                                                           
[    4.861842] device-mapper: table: 253:13: target device dasdf1 is misaligned                                                                                           
[    4.861848] device-mapper: table: 253:13: target device dasde1 is misaligned                                                                                           
[    4.885126] device-mapper: table: 253:14: target device dasdf1 is misaligned                                                                                           
[    4.885132] device-mapper: table: 253:14: target device dasde1 is misaligned                                                                                           
[    4.885138] device-mapper: table: 253:14: target device dasdf1 is misaligned                                                                                           
[    4.885143] device-mapper: table: 253:14: target device dasde1 is misaligned                                                                                           
[    4.908738] device-mapper: table: 253:15: target device dasdf1 is misaligned                                                                                           
[    4.908744] device-mapper: table: 253:15: target device dasde1 is misaligned                                                                                           
[    4.908750] device-mapper: table: 253:15: target device dasdf1 is misaligned                                                                                           
[    4.908755] device-mapper: table: 253:15: target device dasde1 is misaligned                                                                                           
[    4.932243] device-mapper: table: 253:16: target device dasdf1 is misaligned                                                                                           
[    4.932249] device-mapper: table: 253:16: target device dasde1 is misaligned                                                                                           
[    4.932255] device-mapper: table: 253:16: target device dasdf1 is misaligned                                                                                           
[    4.932260] device-mapper: table: 253:16: target device dasde1 is misaligned                                                                                           
[    4.955903] device-mapper: table: 253:17: target device dasdf1 is misaligned                                                                                           
[    4.955909] device-mapper: table: 253:17: target device dasde1 is misaligned                                                                                           
[    4.955914] device-mapper: table: 253:17: target device dasdf1 is misaligned                                                                                           
[    4.955920] device-mapper: table: 253:17: target device dasde1 is misaligned                                                                                           
[    4.979580] device-mapper: table: 253:18: target device dasdf1 is misaligned                                                                                           
[    4.979586] device-mapper: table: 253:18: target device dasde1 is misaligned                                                                                           
[    4.979592] device-mapper: table: 253:18: target device dasdf1 is misaligned                                                                                           
[    4.979597] device-mapper: table: 253:18: target device dasde1 is misaligned                                                                                           
[    5.003273] device-mapper: table: 253:19: target device dasdf1 is misaligned                                                                                           
[    5.003279] device-mapper: table: 253:19: target device dasde1 is misaligned                                                                                           
[    5.003285] device-mapper: table: 253:19: target device dasdf1 is misaligned                                                                                           
[    5.003290] device-mapper: table: 253:19: target device dasde1 is misaligned                                                                                           
[    5.027017] device-mapper: table: 253:20: target device dasdf1 is misaligned                                                                                           
[    5.027023] device-mapper: table: 253:20: target device dasde1 is misaligned                                                                                           
[    5.027029] device-mapper: table: 253:20: target device dasdf1 is misaligned                                                                                           
[    5.027034] device-mapper: table: 253:20: target device dasde1 is misaligned                                                                                           
[    5.050967] device-mapper: table: 253:21: target device dasdf1 is misaligned                                                                                           
[    5.050972] device-mapper: table: 253:21: target device dasde1 is misaligned                                                                                           
[    5.050978] device-mapper: table: 253:21: target device dasdf1 is misaligned                                                                                           
[    5.050983] device-mapper: table: 253:21: target device dasde1 is misaligned                                                                                           
[    5.075008] device-mapper: table: 253:22: target device dasdf1 is misaligned                                                                                           
[    5.075014] device-mapper: table: 253:22: target device dasde1 is misaligned                                                                                           
[    5.075020] device-mapper: table: 253:22: target device dasdf1 is misaligned                                                                                           
[    5.075025] device-mapper: table: 253:22: target device dasde1 is misaligned                                                                                           
[    5.099179] device-mapper: table: 253:23: target device dasdf1 is misaligned                                                                                           
[    5.099185] device-mapper: table: 253:23: target device dasde1 is misaligned                                                                                           
[    5.099191] device-mapper: table: 253:23: target device dasdf1 is misaligned                                                                                           
[    5.099196] device-mapper: table: 253:23: target device dasde1 is misaligned                                                                                           
[    5.123406] device-mapper: table: 253:24: target device dasdf1 is misaligned                                                                                           
[    5.123412] device-mapper: table: 253:24: target device dasde1 is misaligned                                                                                           
[    5.123417] device-mapper: table: 253:24: target device dasdf1 is misaligned                                                                                           
[    5.123423] device-mapper: table: 253:24: target device dasde1 is misaligned                                                                                           
[    5.147705] device-mapper: table: 253:25: target device dasdf1 is misaligned                                                                                           
[    5.147711] device-mapper: table: 253:25: target device dasde1 is misaligned                                                                                           
[    5.147717] device-mapper: table: 253:25: target device dasdf1 is misaligned                                                                                           
[    5.147722] device-mapper: table: 253:25: target device dasde1 is misaligned                                                                                           
[    5.172251] device-mapper: table: 253:26: target device dasdf1 is misaligned                                                                                           
[    5.172257] device-mapper: table: 253:26: target device dasde1 is misaligned                                                                                           
[    5.172263] device-mapper: table: 253:26: target device dasdf1 is misaligned                                                                                           
[    5.172268] device-mapper: table: 253:26: target device dasde1 is misaligned                                                                                           
[    5.196815] device-mapper: table: 253:27: target device dasdf1 is misaligned                                                                                           
[    5.196821] device-mapper: table: 253:27: target device dasde1 is misaligned                                                                                           
[    5.196826] device-mapper: table: 253:27: target device dasdf1 is misaligned                                                                                           
[    5.196832] device-mapper: table: 253:27: target device dasde1 is misaligned                                                                                           
[    5.221607] device-mapper: table: 253:28: target device dasdf1 is misaligned                                                                                           
[    5.221613] device-mapper: table: 253:28: target device dasde1 is misaligned                                                                                           
[    5.221619] device-mapper: table: 253:28: target device dasdf1 is misaligned                                                                                           
[    5.221624] device-mapper: table: 253:28: target device dasde1 is misaligned                                                                                           
[    5.247061] device-mapper: table: 253:29: target device dasdf1 is misaligned                                                                                           
[    5.247067] device-mapper: table: 253:29: target device dasde1 is misaligned                                                                                           
[    5.247073] device-mapper: table: 253:29: target device dasdf1 is misaligned                                                                                           
[    5.247079] device-mapper: table: 253:29: target device dasde1 is misaligned                                                                                           
[    5.272408] device-mapper: table: 253:30: target device dasdf1 is misaligned                                                                                           
[    5.272414] device-mapper: table: 253:30: target device dasde1 is misaligned                                                                                           
[    5.272419] device-mapper: table: 253:30: target device dasdf1 is misaligned                                                                                           
[    5.272425] device-mapper: table: 253:30: target device dasde1 is misaligned                                                                                           
[    5.297555] device-mapper: table: 253:31: target device dasdf1 is misaligned                                                                                           
[    5.297561] device-mapper: table: 253:31: target device dasde1 is misaligned                                                                                           
[    5.297567] device-mapper: table: 253:31: target device dasdf1 is misaligned                                                                                           
[    5.297572] device-mapper: table: 253:31: target device dasde1 is misaligned                                                                                           
[    5.322750] device-mapper: table: 253:32: target device dasdf1 is misaligned                                                                                           
[    5.322756] device-mapper: table: 253:32: target device dasde1 is misaligned                                                                                           
[    5.322762] device-mapper: table: 253:32: target device dasdf1 is misaligned                                                                                           
[    5.322767] device-mapper: table: 253:32: target device dasde1 is misaligned                                                                                           
[    5.348129] device-mapper: table: 253:33: target device dasdf1 is misaligned                                                                                           
[    5.348135] device-mapper: table: 253:33: target device dasde1 is misaligned                                                                                           
[    5.348141] device-mapper: table: 253:33: target device dasdf1 is misaligned                                                                                           
[    5.348146] device-mapper: table: 253:33: target device dasde1 is misaligned                                                                                           
[    5.373557] device-mapper: table: 253:34: target device dasdf1 is misaligned                                                                                           
[    5.373563] device-mapper: table: 253:34: target device dasde1 is misaligned                                                                                           
[    5.373569] device-mapper: table: 253:34: target device dasdf1 is misaligned                                                                                           
[    5.373574] device-mapper: table: 253:34: target device dasde1 is misaligned                                                                                           
[    5.399201] device-mapper: table: 253:35: target device dasdf1 is misaligned                                                                                           
[    5.399207] device-mapper: table: 253:35: target device dasde1 is misaligned                                                                                           
[    5.399213] device-mapper: table: 253:35: target device dasdf1 is misaligned                                                                                           
[    5.399218] device-mapper: table: 253:35: target device dasde1 is misaligned                                                                                           
[    5.424923] device-mapper: table: 253:36: target device dasdf1 is misaligned                                                                                           
[    5.424929] device-mapper: table: 253:36: target device dasde1 is misaligned                                                                                           
[    5.424935] device-mapper: table: 253:36: target device dasdf1 is misaligned                                                                                           
[    5.424940] device-mapper: table: 253:36: target device dasde1 is misaligned                                                                                           
[    5.451162] device-mapper: table: 253:37: target device dasdf1 is misaligned                                                                                           
[    5.451168] device-mapper: table: 253:37: target device dasde1 is misaligned                                                                                           
[    5.451174] device-mapper: table: 253:37: target device dasdf1 is misaligned                                                                                           
[    5.451180] device-mapper: table: 253:37: target device dasde1 is misaligned                                                                                           
[    5.477232] device-mapper: table: 253:38: target device dasdf1 is misaligned                                                                                           
[    5.477238] device-mapper: table: 253:38: target device dasde1 is misaligned                                                                                           
[    5.477244] device-mapper: table: 253:38: target device dasdf1 is misaligned                                                                                           
[    5.477249] device-mapper: table: 253:38: target device dasde1 is misaligned                                                                                           
[    5.503196] device-mapper: table: 253:39: target device dasdf1 is misaligned                                                                                           
[    5.503202] device-mapper: table: 253:39: target device dasde1 is misaligned                                                                                           
[    5.503208] device-mapper: table: 253:39: target device dasdf1 is misaligned                                                                                           
[    5.503213] device-mapper: table: 253:39: target device dasde1 is misaligned                                                                                           
[    5.529146] device-mapper: table: 253:40: target device dasdf1 is misaligned                                                                                           
[    5.529152] device-mapper: table: 253:40: target device dasde1 is misaligned                                                                                           
[    5.529158] device-mapper: table: 253:40: target device dasdf1 is misaligned                                                                                           
[    5.529163] device-mapper: table: 253:40: target device dasde1 is misaligned                                                                                           
[    5.555273] device-mapper: table: 253:41: target device dasdf1 is misaligned                                                                                           
[    5.555279] device-mapper: table: 253:41: target device dasde1 is misaligned                                                                                           
[    5.555285] device-mapper: table: 253:41: target device dasdf1 is misaligned                                                                                           
[    5.555290] device-mapper: table: 253:41: target device dasde1 is misaligned                                                                                           
[    5.581672] device-mapper: table: 253:42: target device dasdf1 is misaligned                                                                                           
[    5.581678] device-mapper: table: 253:42: target device dasde1 is misaligned                                                                                           
[    5.581684] device-mapper: table: 253:42: target device dasdf1 is misaligned                                                                                           
[    5.581689] device-mapper: table: 253:42: target device dasde1 is misaligned                                                                                           
[    5.609371] device-mapper: table: 253:43: target device dasdf1 is misaligned                                                                                           
[    5.609377] device-mapper: table: 253:43: target device dasde1 is misaligned                                                                                           
[    5.609382] device-mapper: table: 253:43: target device dasdf1 is misaligned                                                                                           
[    5.609388] device-mapper: table: 253:43: target device dasde1 is misaligned                                                                                           
[    5.635806] device-mapper: table: 253:44: target device dasdf1 is misaligned                                                                                           
[    5.635812] device-mapper: table: 253:44: target device dasde1 is misaligned                                                                                           
[    5.635818] device-mapper: table: 253:44: target device dasdf1 is misaligned                                                                                           
[    5.635823] device-mapper: table: 253:44: target device dasde1 is misaligned                                                                                           
[    5.662333] device-mapper: table: 253:45: target device dasdf1 is misaligned                                                                                           
[    5.662339] device-mapper: table: 253:45: target device dasde1 is misaligned                                                                                           
[    5.662345] device-mapper: table: 253:45: target device dasdf1 is misaligned                                                                                           
[    5.662351] device-mapper: table: 253:45: target device dasde1 is misaligned                                                                                           
[    5.688979] device-mapper: table: 253:46: target device dasdf1 is misaligned                                                                                           
[    5.688985] device-mapper: table: 253:46: target device dasde1 is misaligned                                                                                           
[    5.688991] device-mapper: table: 253:46: target device dasdf1 is misaligned                                                                                           
[    5.688996] device-mapper: table: 253:46: target device dasde1 is misaligned                                                                                           
[    5.715719] device-mapper: table: 253:47: target device dasdf1 is misaligned                                                                                           
[    5.715725] device-mapper: table: 253:47: target device dasde1 is misaligned                                                                                           
[    5.715731] device-mapper: table: 253:47: target device dasdf1 is misaligned                                                                                           
[    5.715736] device-mapper: table: 253:47: target device dasde1 is misaligned                                                                                           
[    5.742624] device-mapper: table: 253:48: target device dasdf1 is misaligned                                                                                           
[    5.742630] device-mapper: table: 253:48: target device dasde1 is misaligned                                                                                           
[    5.742636] device-mapper: table: 253:48: target device dasdf1 is misaligned                                                                                           
[    5.742642] device-mapper: table: 253:48: target device dasde1 is misaligned                                                                                           
[    5.769767] device-mapper: table: 253:49: target device dasdf1 is misaligned                                                                                           
[    5.769773] device-mapper: table: 253:49: target device dasde1 is misaligned                                                                                           
[    5.769779] device-mapper: table: 253:49: target device dasdf1 is misaligned                                                                                           
[    5.769784] device-mapper: table: 253:49: target device dasde1 is misaligned                                                                                           
[    5.797018] device-mapper: table: 253:50: target device dasdf1 is misaligned                                                                                           
[    5.797024] device-mapper: table: 253:50: target device dasde1 is misaligned                                                                                           
[    5.797029] device-mapper: table: 253:50: target device dasdf1 is misaligned                                                                                           
[    5.797035] device-mapper: table: 253:50: target device dasde1 is misaligned                                                                                           
[    5.824218] device-mapper: table: 253:51: target device dasdf1 is misaligned                                                                                           
[    5.824225] device-mapper: table: 253:51: target device dasde1 is misaligned                                                                                           
[    5.824230] device-mapper: table: 253:51: dasdf1 too small for target                                                                                                  
[    5.824236] device-mapper: table: 253:51: dasde1 too small for target                                                                                                  
[    5.851638] device-mapper: table: 253:52: target device dasdd1 is misaligned                                                                                           
[    5.851644] device-mapper: table: 253:52: target device dasdf1 is misaligned
[    5.851650] device-mapper: table: 253:52: target device dasdd1 is misaligned
[    5.851655] device-mapper: table: 253:52: target device dasdf1 is misaligned
[    5.879150] device-mapper: table: 253:53: target device dasdc1 is misaligned
[    5.879156] device-mapper: table: 253:53: target device dasdd1 is misaligned
[    5.879162] device-mapper: table: 253:53: target device dasdc1 is misaligned
[    5.879167] device-mapper: table: 253:53: target device dasdd1 is misaligned
[    5.906693] device-mapper: table: 253:54: target device dasdc1 is misaligned
[    5.906699] device-mapper: table: 253:54: target device dasde1 is misaligned
[    5.906705] device-mapper: table: 253:54: target device dasdc1 is misaligned
[    5.906710] device-mapper: table: 253:54: target device dasde1 is misaligned
[    5.934859] device-mapper: table: 253:55: target device dasdc1 is misaligned
[    5.934865] device-mapper: table: 253:55: target device dasde1 is misaligned
[    5.934870] device-mapper: table: 253:55: target device dasdc1 is misaligned
[    5.934876] device-mapper: table: 253:55: target device dasde1 is misaligned
[    5.962624] device-mapper: table: 253:56: target device dasdc1 is misaligned
[    5.962630] device-mapper: table: 253:56: target device dasde1 is misaligned
[    5.962636] device-mapper: table: 253:56: target device dasdc1 is misaligned
[    5.962641] device-mapper: table: 253:56: target device dasde1 is misaligned
[    5.991056] device-mapper: table: 253:57: target device dasdc1 is misaligned
[    5.991062] device-mapper: table: 253:57: target device dasde1 is misaligned
[    5.991068] device-mapper: table: 253:57: target device dasdc1 is misaligned
[    5.991073] device-mapper: table: 253:57: target device dasde1 is misaligned
[    6.019482] device-mapper: table: 253:58: target device dasdc1 is misaligned
[    6.019488] device-mapper: table: 253:58: target device dasde1 is misaligned
[    6.019494] device-mapper: table: 253:58: target device dasdc1 is misaligned
[    6.019499] device-mapper: table: 253:58: target device dasde1 is misaligned
[    6.048163] device-mapper: table: 253:59: target device dasdc1 is misaligned
[    6.048168] device-mapper: table: 253:59: target device dasde1 is misaligned
[    6.048174] device-mapper: table: 253:59: target device dasdc1 is misaligned
[    6.048180] device-mapper: table: 253:59: target device dasde1 is misaligned
[    6.076781] device-mapper: table: 253:60: target device dasdc1 is misaligned
[    6.076787] device-mapper: table: 253:60: target device dasde1 is misaligned
[    6.076793] device-mapper: table: 253:60: target device dasdc1 is misaligned
[    6.076798] device-mapper: table: 253:60: target device dasde1 is misaligned
[    6.105621] device-mapper: table: 253:61: target device dasdc1 is misaligned
[    6.105627] device-mapper: table: 253:61: target device dasde1 is misaligned
[    6.105633] device-mapper: table: 253:61: target device dasdc1 is misaligned
[    6.105639] device-mapper: table: 253:61: target device dasde1 is misaligned
[    6.134582] device-mapper: table: 253:62: target device dasdc1 is misaligned
[    6.134588] device-mapper: table: 253:62: target device dasde1 is misaligned
[    6.134594] device-mapper: table: 253:62: target device dasdc1 is misaligned
[    6.134600] device-mapper: table: 253:62: target device dasde1 is misaligned
[    6.163671] device-mapper: table: 253:63: target device dasdc1 is misaligned
[    6.163677] device-mapper: table: 253:63: target device dasde1 is misaligned
[    6.163683] device-mapper: table: 253:63: target device dasdc1 is misaligned
[    6.163688] device-mapper: table: 253:63: target device dasde1 is misaligned
[    6.192928] device-mapper: table: 253:64: target device dasdf1 is misaligned
[    6.192934] device-mapper: table: 253:64: target device dasde1 is misaligned
[    6.192940] device-mapper: table: 253:64: target device dasdc1 is misaligned
[    6.192946] device-mapper: table: 253:64: target device dasdd1 is misaligned
[    6.192952] device-mapper: table: 253:64: dasdc1 too small for target
[    6.192958] device-mapper: table: 253:64: dasdd1 too small for target

I have taken some snapshorts of pv/vg/lvdisplay on a working kernel (see 
attachements) If you need more information, please let me know.

Christian


--Boundary-00=_/kgXKRV6SspfC1c
Content-Type: text/plain;
  charset="UTF-8";
  name="pvdisplay.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pvdisplay.txt"

  --- Physical volume ---
  PV Name               /dev/dasdf1
  VG Name               space
  PV Size               22.49 GB / not usable 2.28 MB
  Allocatable           yes 
  PE Size (KByte)       4096
  Total PE              5758
  Free PE               3
  Allocated PE          5755
  PV UUID               Uocvlz-I6wv-JtLH-8W5L-ziib-pP7h-4Qdzgz
   
  --- Physical volume ---
  PV Name               /dev/dasde1
  VG Name               space
  PV Size               22.49 GB / not usable 2.28 MB
  Allocatable           yes 
  PE Size (KByte)       4096
  Total PE              5758
  Free PE               15
  Allocated PE          5743
  PV UUID               UuM16H-GUdC-gfA3-3yvE-c5Af-UVPW-Cfe2no
   
  --- Physical volume ---
  PV Name               /dev/dasdd1
  VG Name               space
  PV Size               4.59 GB / not usable 3.38 MB
  Allocatable           yes (but full)
  PE Size (KByte)       4096
  Total PE              1173
  Free PE               0
  Allocated PE          1173
  PV UUID               800CzR-0hjD-lL6Z-yQPt-vRcl-WlYp-cUtZwJ
   
  --- Physical volume ---
  PV Name               /dev/dasdc1
  VG Name               space
  PV Size               4.59 GB / not usable 3.38 MB
  Allocatable           yes 
  PE Size (KByte)       4096
  Total PE              1173
  Free PE               12
  Allocated PE          1161
  PV UUID               hG8bJE-xYJL-eo0N-tsD5-kdcH-AONB-FGdtAK
   

--Boundary-00=_/kgXKRV6SspfC1c
Content-Type: text/plain;
  charset="UTF-8";
  name="lvdisplay.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lvdisplay.txt"

  --- Logical volume ---
  LV Name                /dev/space/space
  VG Name                space
  LV UUID                fdSSaQ-yXkL-EoK2-Ai52-Gzjw-J4jz-DWGVIu
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                10.00 GB
  Current LE             2560
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Name                /dev/space/usr
  VG Name                space
  LV UUID                m46wUu-2P22-VNgE-vHuI-GD0l-MwlD-5rvxgS
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                3.00 GB
  Current LE             768
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
   
  --- Logical volume ---
  LV Name                /dev/space/r1
  VG Name                space
  LV UUID                o3nium-c6HG-9zfQ-CKXR-jQDa-vSB1-o28prX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
   
  --- Logical volume ---
  LV Name                /dev/space/s1
  VG Name                space
  LV UUID                vGsxRn-Zeko-WpJ9-mFSv-Q0F7-3jz4-fcASPn
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3
   
  --- Logical volume ---
  LV Name                /dev/space/r2
  VG Name                space
  LV UUID                82xvhL-T117-x5X0-knbx-CDYc-VrRS-a91A9o
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:4
   
  --- Logical volume ---
  LV Name                /dev/space/s2
  VG Name                space
  LV UUID                dKgX5f-Zp7d-0EN2-sobR-ZCbA-ksZS-nhAds2
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:5
   
  --- Logical volume ---
  LV Name                /dev/space/r3
  VG Name                space
  LV UUID                U07Suj-iDZZ-vjcR-3xCa-r0EF-Oljt-Mq2LqU
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6
   
  --- Logical volume ---
  LV Name                /dev/space/s3
  VG Name                space
  LV UUID                RCPF1v-p6ab-dgAo-1mcl-evPJ-q7md-ozUSVw
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:7
   
  --- Logical volume ---
  LV Name                /dev/space/r4
  VG Name                space
  LV UUID                8pVIKo-23jG-cTLF-Pd87-zD4T-kCRd-Txnq9L
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:8
   
  --- Logical volume ---
  LV Name                /dev/space/s4
  VG Name                space
  LV UUID                KtdttC-9LVf-eyna-mGDm-W3qe-4eC7-Iu2CSE
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:9
   
  --- Logical volume ---
  LV Name                /dev/space/r5
  VG Name                space
  LV UUID                fenrJT-jooG-HK90-IDVT-3tqg-neTn-CecfGY
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:10
   
  --- Logical volume ---
  LV Name                /dev/space/s5
  VG Name                space
  LV UUID                CCqiL9-u5G6-DbKi-9Bc5-p6M2-n1jb-vcfjuW
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:11
   
  --- Logical volume ---
  LV Name                /dev/space/r6
  VG Name                space
  LV UUID                gqC4u6-a7v8-8bXW-Kpx0-OS9y-Ewpg-JHjUGP
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:12
   
  --- Logical volume ---
  LV Name                /dev/space/s6
  VG Name                space
  LV UUID                82lRZ1-zcJk-VZi8-ieEt-r9di-tIc0-UDhLbX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:13
   
  --- Logical volume ---
  LV Name                /dev/space/r7
  VG Name                space
  LV UUID                uGqt2G-H2So-qd9J-Iy7x-To0d-rZ10-MhrVnu
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:14
   
  --- Logical volume ---
  LV Name                /dev/space/s7
  VG Name                space
  LV UUID                OK1kke-R0O3-T5Yk-2ZWR-g8P2-HWch-5ZJY9J
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:15
   
  --- Logical volume ---
  LV Name                /dev/space/r8
  VG Name                space
  LV UUID                NnzKJe-AELf-tOjG-exG2-AHal-PIY3-5tGMuB
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:16
   
  --- Logical volume ---
  LV Name                /dev/space/s8
  VG Name                space
  LV UUID                SfJPIf-tkBA-YFYC-H1YI-9Rn4-Zr6t-L4oMo8
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:17
   
  --- Logical volume ---
  LV Name                /dev/space/r9
  VG Name                space
  LV UUID                gpU8VX-DmtK-R0cI-elfq-8qce-SxsI-BVdEn3
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:18
   
  --- Logical volume ---
  LV Name                /dev/space/s9
  VG Name                space
  LV UUID                8L28qG-rro7-3Y1b-dSTf-pAL2-38eG-6KQhG8
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:19
   
  --- Logical volume ---
  LV Name                /dev/space/r10
  VG Name                space
  LV UUID                acfVZU-NRig-d8dY-7L7X-A44b-8TOM-3J4SCj
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:20
   
  --- Logical volume ---
  LV Name                /dev/space/s10
  VG Name                space
  LV UUID                f8CLD0-Gza6-aZ7t-7KIO-rm3G-vioT-Cb716z
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:21
   
  --- Logical volume ---
  LV Name                /dev/space/r11
  VG Name                space
  LV UUID                aisdqd-jf74-nse1-VxNL-Jri9-VIPd-1GuRln
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:22
   
  --- Logical volume ---
  LV Name                /dev/space/s11
  VG Name                space
  LV UUID                M9GbxM-MTyu-FaBj-l0Cl-y9h8-QkUF-bPiiks
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:23
   
  --- Logical volume ---
  LV Name                /dev/space/r12
  VG Name                space
  LV UUID                46DYju-U0V1-W7aJ-aa5B-JLuZ-EJgc-esbBlS
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:24
   
  --- Logical volume ---
  LV Name                /dev/space/s12
  VG Name                space
  LV UUID                4bwv3V-URGq-xvuc-sEce-Xjet-vBoL-0u1Aak
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:25
   
  --- Logical volume ---
  LV Name                /dev/space/r13
  VG Name                space
  LV UUID                1Tho0H-d9S3-HzFR-bexS-dxt9-EyXI-qBVYub
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:26
   
  --- Logical volume ---
  LV Name                /dev/space/s13
  VG Name                space
  LV UUID                RVynkA-84fe-JhZv-EO1I-7gtq-m2C0-y83V5j
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:27
   
  --- Logical volume ---
  LV Name                /dev/space/r14
  VG Name                space
  LV UUID                xMTHOQ-n4sI-QBIC-PMEq-Brl3-kQ0f-Qbyr1R
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:28
   
  --- Logical volume ---
  LV Name                /dev/space/s14
  VG Name                space
  LV UUID                s1Qaz1-2YZw-EEjZ-KpTi-GzRg-uXt4-Bbux2O
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:29
   
  --- Logical volume ---
  LV Name                /dev/space/r15
  VG Name                space
  LV UUID                8QDZ1W-dcPh-tJ2f-zYnn-8PG8-qf9Z-jsat6A
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:30
   
  --- Logical volume ---
  LV Name                /dev/space/s15
  VG Name                space
  LV UUID                VHNDmh-zq4w-zbBz-APRX-dkdx-d1KK-OY01bX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:31
   
  --- Logical volume ---
  LV Name                /dev/space/r16
  VG Name                space
  LV UUID                H44ecz-206z-1H2S-13q7-rvSR-gYkP-ceZ70x
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:32
   
  --- Logical volume ---
  LV Name                /dev/space/s16
  VG Name                space
  LV UUID                Y0IOTb-e1mj-5dUv-kufE-1hju-mg50-TBqzzI
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:33
   
  --- Logical volume ---
  LV Name                /dev/space/r17
  VG Name                space
  LV UUID                JITLuv-AWLR-72Hy-V5pz-W9pJ-yYUE-tpb4yn
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:34
   
  --- Logical volume ---
  LV Name                /dev/space/s17
  VG Name                space
  LV UUID                8DQw1j-nHpr-gHqV-9JZj-uybI-vwbm-gKVGfg
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:35
   
  --- Logical volume ---
  LV Name                /dev/space/r18
  VG Name                space
  LV UUID                GTKsW2-BPzX-HuT3-gYBz-MoVV-H2PL-83td7w
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:36
   
  --- Logical volume ---
  LV Name                /dev/space/s18
  VG Name                space
  LV UUID                yE3meh-7kaZ-wlu2-miwc-V0gb-Qbuv-V2f8eW
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:37
   
  --- Logical volume ---
  LV Name                /dev/space/r19
  VG Name                space
  LV UUID                M0GVJd-yycc-D2K9-pfDM-DV3w-bQUU-nRCuw6
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:38
   
  --- Logical volume ---
  LV Name                /dev/space/s19
  VG Name                space
  LV UUID                wZ052N-kYxj-ZDiL-RFwe-jAS8-3iXO-WQOooP
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:39
   
  --- Logical volume ---
  LV Name                /dev/space/r20
  VG Name                space
  LV UUID                9cgPqm-DfnZ-AjDe-d5uy-JeUf-PqEh-7AX65L
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:40
   
  --- Logical volume ---
  LV Name                /dev/space/s20
  VG Name                space
  LV UUID                avxJgg-vsfb-izSX-9myu-BsoE-KKo0-YRflc7
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:41
   
  --- Logical volume ---
  LV Name                /dev/space/r21
  VG Name                space
  LV UUID                030nCm-YOdA-wI2w-2vJ2-c935-C79p-DgLqEs
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:42
   
  --- Logical volume ---
  LV Name                /dev/space/s21
  VG Name                space
  LV UUID                HnDXYc-TSf8-1647-dvJN-N1kz-Ng9h-IAvX01
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:43
   
  --- Logical volume ---
  LV Name                /dev/space/r22
  VG Name                space
  LV UUID                nyZwn2-JjVl-bZFf-CpA5-iUJ8-a3rE-nbWPKU
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:44
   
  --- Logical volume ---
  LV Name                /dev/space/s22
  VG Name                space
  LV UUID                e9zlAg-YWug-0liK-1xUj-sdbF-Nayk-YKb0xN
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:45
   
  --- Logical volume ---
  LV Name                /dev/space/r23
  VG Name                space
  LV UUID                m6k1my-ZIj3-LLOy-3lWg-jFO7-QdZF-8G2dHJ
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:46
   
  --- Logical volume ---
  LV Name                /dev/space/s23
  VG Name                space
  LV UUID                oqR9qP-nl12-dxL7-2eFx-F7Eb-sbFH-lt9YbF
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:47
   
  --- Logical volume ---
  LV Name                /dev/space/r24
  VG Name                space
  LV UUID                vjlw4o-kJYy-33n0-GdjJ-tXO4-EuBC-uFcspf
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:48
   
  --- Logical volume ---
  LV Name                /dev/space/s24
  VG Name                space
  LV UUID                BMO9eP-XCUF-jYT0-3jji-3H0Q-Ameh-2cHmra
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:49
   
  --- Logical volume ---
  LV Name                /dev/space/root
  VG Name                space
  LV UUID                0jL8uk-9ttB-vUUU-iAHw-aZUT-VjL6-omcLHp
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                512.00 MB
  Current LE             128
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:50
   
  --- Logical volume ---
  LV Name                /dev/space/home
  VG Name                space
  LV UUID                zqzWBR-orl5-c4N0-XNcP-hqtr-e3qa-TCwNLe
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                5.00 GB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:51
   
  --- Logical volume ---
  LV Name                /dev/space/ccache
  VG Name                space
  LV UUID                JUYgLy-ua53-N45B-6NEw-FHI5-33d0-76nLkE
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                4.00 GB
  Current LE             1024
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:52
   
  --- Logical volume ---
  LV Name                /dev/space/base
  VG Name                space
  LV UUID                FPhFLU-1xTK-XtG4-STmI-u3D5-KhCR-FmlcCO
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                4.00 GB
  Current LE             1024
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:53
   
  --- Logical volume ---
  LV Name                /dev/space/r25
  VG Name                space
  LV UUID                YkxecI-bINo-6xdh-bA2C-vDwX-ml07-TXlUBH
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:54
   
  --- Logical volume ---
  LV Name                /dev/space/s25
  VG Name                space
  LV UUID                GHY2yh-a5ST-cyow-1Fzi-F570-OWYW-ilVJeg
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:55
   
  --- Logical volume ---
  LV Name                /dev/space/r26
  VG Name                space
  LV UUID                W0hbZp-boum-J0GD-ENK2-ew6M-mW05-LQ9ZEj
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:56
   
  --- Logical volume ---
  LV Name                /dev/space/s26
  VG Name                space
  LV UUID                TIiZGG-4taN-jLyb-9pb1-aib2-slE6-TlqG3x
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:57
   
  --- Logical volume ---
  LV Name                /dev/space/r27
  VG Name                space
  LV UUID                NZjmkE-AT6H-974g-nGvw-epxD-nKJJ-4r1ks5
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:58
   
  --- Logical volume ---
  LV Name                /dev/space/s27
  VG Name                space
  LV UUID                l7KiyI-HJ7X-TaSr-nBYW-tYCU-EF0f-dwEHe0
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:59
   
  --- Logical volume ---
  LV Name                /dev/space/r28
  VG Name                space
  LV UUID                emN7S1-eBtk-mUxQ-itc5-ZrvH-Tacx-VHzytU
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:60
   
  --- Logical volume ---
  LV Name                /dev/space/s28
  VG Name                space
  LV UUID                74cqP9-PDi5-CVq1-LAV9-Er0r-HeB9-5TeTIz
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:61
   
  --- Logical volume ---
  LV Name                /dev/space/r29
  VG Name                space
  LV UUID                EdZKbD-HXu4-ac6K-b6co-9zTC-dd4Z-Zuwy6W
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:62
   
  --- Logical volume ---
  LV Name                /dev/space/s29
  VG Name                space
  LV UUID                p1NTvB-Y41N-YM1q-odyn-GiLD-bcsc-Tx9LwN
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:63
   
  --- Logical volume ---
  LV Name                /dev/space/test
  VG Name                space
  LV UUID                IwGDO2-j2cx-whbr-mcLQ-7MPi-FIWJ-lPw0LX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                4.88 GB
  Current LE             1248
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:64
   

--Boundary-00=_/kgXKRV6SspfC1c
Content-Type: text/plain;
  charset="UTF-8";
  name="vgdisplay.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="vgdisplay.txt"

  --- Volume group ---
  VG Name               space
  System ID             
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  96
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                65
  Open LV               4
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               54.15 GB
  PE Size               4.00 MB
  Total PE              13862
  Alloc PE / Size       13832 / 54.03 GB
  Free  PE / Size       30 / 120.00 MB
  VG UUID               AcRPg8-6DaJ-ND6i-s3H7-Sh5V-8KWa-KtKRmv
   

--Boundary-00=_/kgXKRV6SspfC1c--
