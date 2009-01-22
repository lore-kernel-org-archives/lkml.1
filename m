Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZAVMs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZAVMs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZAVMrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:47:53 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:43088 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbZAVMrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:47:51 -0500
From: Dmitry Gryazin <gdu@mns.spb.ru>
Organization: MNS
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
Date: Thu, 22 Jan 2009 15:43:03 +0300
User-Agent: KMail/1.9.9
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Kirill Smelkov <kirr@mns.spb.ru>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, navy-patches@mns.spb.ru
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <200901151448.52900.gdu@mns.spb.ru> <49707F20.4030600@ru.mvista.com>
In-Reply-To: <49707F20.4030600@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901221543.03763.gdu@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 03:35:44 pm Sergei Shtylyov wrote:
> Hello.
>
> Dmitry Gryazin wrote:
> >>>> True.  However it should be possible to handle it correctly by adding
> >>>> the
> >>>> DMA quirk to the respective host drivers (seems to be via82cxxx.c in
> >>>> case of
> >>>> IEI PCISA-C3/EDEN).
> >>>
> >>>   Yeah, this seems a viable approach...
> >>>
> >>>> Kirill, could you please look into adding such quirk to via82cxxx
> >>>> instead?
> >>>>
> >>>> [ It seems the best place to add it would be via_init_one() as we
> >>>> could just
> >>>
> >>>   No, not really -- the issue is not at all as simple as this patch
> >>> tried to present it. Looking at its "Quick Startup Reference"
> >>> (http://f.ipc2u.ru/files/add/doc/496/M_PCISA-C800EV_ENG.pdf), the EPIC
> >>> board has *two* normal IDE connectors in addition to the CF slot
> >>> (connected to the secondary port -- and it seems possible that a hard
> >>> drive can be connected to the same port as CF), so the right place
> >>> seems to rather be in [mu]dma_filter() methods -- and the decision
> >>> should be strictly based on the drive type indicating CF, i.e. by
> >>> calling ata_id_is_cfa().

I have tried my old Trancend 64Mb, RamStar 521Mb and NCP 64Mb cards. My old 
cards returned right id[ATA_ID_CONFIG] = 0x848A.

But I have to use Kingston CF Card 1Gb 2008.
ata_id_is_cfa() returns 0 for it and
id[ATA_ID_MAJOR_VER]	= 0
id[ATA_ID_CONFIG]		= 0x044A

I have only CF+ specification revision 2.0, but I've found in wiki:
(http://en.wikipedia.org/wiki/CompactFlash#CF.2B_specification_revisions)
"... While the current revision 4.1 from 2004 works only in ATA mode, ..."

So I have reached an impasse. How to identify modern CF cards?
