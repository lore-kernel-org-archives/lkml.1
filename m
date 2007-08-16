Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbXHPMMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbXHPMMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXHPMMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:12:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbXHPMME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:12:04 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Bad CD disk disables IDE DMA
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Zoltan Boszormenyi <zboszor@dunaweb.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 16 Aug 2007 14:11:53 +0200
References: <8Squ5-2cU-19@gated-at.bofh.it> <8SIKl-5IK-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1ILeCg-0000iH-2W@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+hzA6MPTkzfFc8cxqLLDH6axgYqqwN83rr/Z+
 JyHW6gUU4jdzzJLAEa17CyE5FrAza19bppfGUy5e02Jt1Ep5M+
 xmdqSv1aRHsyyWmkyNzPQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> On 15/08/07, Zoltan Boszormenyi <zboszor@dunaweb.hu> wrote:

>> I noticed that a bad CD of mine makes DMA disabled:

[...]
>> hda: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
>> ide: failed opcode was: unknown
>> hda: DMA disabled
>> hda: ide_intr: huh? expected NULL handler on exit
>> hda: ATAPI reset complete
>>
>> Every time I put the said CD into to drive and DMA is on, I get the
>> above messages.
> 
> This might be intended.

Maybe, and maybe only a certain effect might be intended. And maybe I can
help by asking these questions:

1) Does disabling DMA fix the seek errors, or does it hide them by the PIO
   interfce not printing them?

2) If it does hide them, would filtering for seek errors be a sane thing to
   do, or does the DMA engine (or HDD) behave badly on these errors, or
   do bad-DMA devices report seek errors, too?

3) If it does not hide them, would re-enabling DMA on disk change be a
   feasable workaround?
   (proposed interface: use hdparm -d $num where $num =
     0, 1: as before
     3: DMA on, if switched off automatically, will be set to 2
     2: DMA off, will be turned on (set to 3) on disk change)

4) Does libata work well enough for making all effort put into that old
   IDE layer be a waste of time?
-- 
Fun things to slip into your budget
True: NASA couldn't get money approved for hangars for Space Shuttle so they
put in request for 'Space Vehicle Refurbishment and Storage Facilities'
       - and got the money to build hangars
