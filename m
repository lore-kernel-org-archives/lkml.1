Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXCTTq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXCTTq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXCTTq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:46:26 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:40655 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753182AbXCTTqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:46:25 -0400
Message-ID: <46003AAF.70707@interia.pl>
Date: Tue, 20 Mar 2007 20:49:03 +0100
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070308)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: EXT3 problem in 2.6.21-rc4
References: <46002EB0.6070400@interia.pl>
In-Reply-To: <46002EB0.6070400@interia.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-EMID: 6decaacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


OK. After reboot some files and dirs are missing (backup was this morning :-), 
but I found source of the problem in log. Old VIA bug hit me at first and 
5 min later filesystem errors started to show (due to northbridge overheating 
- 65 deg C ?).

Mar 20 15:27:33 elke hda: dma_timer_expiry: dma status == 0x61
Mar 20 15:27:44 elke hda: DMA timeout error
Mar 20 15:27:44 elke hda: dma timeout error: status=0xd0 { Busy }
Mar 20 15:27:44 elke ide: failed opcode was: unknown
Mar 20 15:27:44 elke hda: DMA disabled
Mar 20 15:27:44 elke hdb: DMA disabled
Mar 20 15:27:44 elke ide0: reset: success
Mar 20 15:33:21 elke attempt to access beyond end of device
Mar 20 15:33:21 elke hda1: rw=0, want=31679512592, limit=39070017
Mar 20 15:33:21 elke attempt to access beyond end of device
Mar 20 15:33:21 elke hda1: rw=0, want=16143191048, limit=39070017
[...] And many more
Mar 20 15:33:22 elke Buffer I/O error on device hda1, logical block 3959939073
Mar 20 15:33:22 elke lost page write due to I/O error on hda1
Mar 20 15:33:22 elke attempt to access beyond end of device
Mar 20 15:33:22 elke hda1: rw=1, want=16143191048, limit=39070017
Mar 20 15:33:22 elke Buffer I/O error on device hda1, logical block 2017898880
Mar 20 15:33:22 elke lost page write due to I/O error on hda1
Mar 20 15:33:22 elke attempt to access beyond end of device
Mar 20 15:33:22 elke hda1: rw=1, want=32581919992, limit=39070017
[...]
Mar 20 15:43:47 elke EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3120627712, count = 1
Mar 20 15:43:47 elke EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1486196549, count = 1
Mar 20 15:43:47 elke EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2298578845, count = 1
[...]
Mar 20 19:54:11 elke init_special_inode: bogus i_mode (136654)
Mar 20 19:55:06 elke attempt to access beyond end of device
Mar 20 19:55:06 elke hda1: rw=0, want=5561616200, limit=39070017
Mar 20 19:55:06 elke attempt to access beyond end of device
Mar 20 19:55:06 elke hda1: rw=0, want=5561616200, limit=39070017
Mar 20 19:55:06 elke init_special_inode: bogus i_mode (171034)
Mar 20 19:56:05 elke EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 1572901, length 1

Reboot anf fsck.


----------------------------------------------------------------------
Jestes kierowca? To poczytaj! >>> http://link.interia.pl/f199e

