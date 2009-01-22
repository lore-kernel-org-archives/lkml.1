Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZAVPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZAVPxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAVPw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:52:59 -0500
Received: from h155.mvista.com ([63.81.120.155]:29607 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750785AbZAVPw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:52:58 -0500
Message-ID: <49789679.5040800@ru.mvista.com>
Date: Thu, 22 Jan 2009 18:53:29 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Dmitry Gryazin <gdu@mns.spb.ru>, Kirill Smelkov <kirr@mns.spb.ru>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       navy-patches@mns.spb.ru
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <49707F20.4030600@ru.mvista.com> <200901221543.03763.gdu@mns.spb.ru> <200901221601.38362.bzolnier@gmail.com>
In-Reply-To: <200901221601.38362.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>>>>>>True.  However it should be possible to handle it correctly by adding
>>>>>>>the
>>>>>>>DMA quirk to the respective host drivers (seems to be via82cxxx.c in
>>>>>>>case of
>>>>>>>IEI PCISA-C3/EDEN).

>>>>>>  Yeah, this seems a viable approach...

>>>>>>>Kirill, could you please look into adding such quirk to via82cxxx
>>>>>>>instead?

>>>>>>>[ It seems the best place to add it would be via_init_one() as we
>>>>>>>could just

>>>>>>  No, not really -- the issue is not at all as simple as this patch
>>>>>>tried to present it. Looking at its "Quick Startup Reference"
>>>>>>(http://f.ipc2u.ru/files/add/doc/496/M_PCISA-C800EV_ENG.pdf), the EPIC
>>>>>>board has *two* normal IDE connectors in addition to the CF slot
>>>>>>(connected to the secondary port -- and it seems possible that a hard
>>>>>>drive can be connected to the same port as CF), so the right place
>>>>>>seems to rather be in [mu]dma_filter() methods -- and the decision
>>>>>>should be strictly based on the drive type indicating CF, i.e. by
>>>>>>calling ata_id_is_cfa().

>>I have tried my old Trancend 64Mb, RamStar 521Mb and NCP 64Mb cards. My old 
>>cards returned right id[ATA_ID_CONFIG] = 0x848A.

>>But I have to use Kingston CF Card 1Gb 2008.
>>ata_id_is_cfa() returns 0 for it and
>>id[ATA_ID_MAJOR_VER]	= 0
>>id[ATA_ID_CONFIG]		= 0x044A

>>I have only CF+ specification revision 2.0, but I've found in wiki:
>>(http://en.wikipedia.org/wiki/CompactFlash#CF.2B_specification_revisions)
>>"... While the current revision 4.1 from 2004 works only in ATA mode, ..."

>>So I have reached an impasse. How to identify modern CF cards?

> Sorry that I missed it before but if indeed normal IDE devices/connectors can
> be used with IDE2 then I see no sane/reliable way to detect CF devices using
> buggy on-board slot... unless this slot is hardwired to be master (or slave)?

    Selectable via switch. However, it's not very probable that user will plug 
in CF adapter into the secondary channel (and it will have the option of using 
on on the primary anyway).

> Thanks,
> Bart

MBR, Sergei
