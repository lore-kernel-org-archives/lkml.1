Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZAVPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZAVPB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZAVPBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:01:45 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:41767 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZAVPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=v2pQlALERm6d6LiO7ISe1UWl4LTtXXArlnWn4wuKIdUup7ac25D0rUnWXx+UdjM/6p
         CuGadImcMnuLnAX2rK6y0Zb8czEp8/1QlYeEvoUhzchttQS6YqUH/3uN1xnIBILagSYV
         VV+UZRydheVgQS2LUr8vgF/Cbyfug/x7epano=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dmitry Gryazin <gdu@mns.spb.ru>
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
Date: Thu, 22 Jan 2009 16:01:38 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090121; KDE/4.1.3; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Kirill Smelkov <kirr@mns.spb.ru>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, navy-patches@mns.spb.ru
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <49707F20.4030600@ru.mvista.com> <200901221543.03763.gdu@mns.spb.ru>
In-Reply-To: <200901221543.03763.gdu@mns.spb.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901221601.38362.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, Dmitry Gryazin wrote:
> On Friday 16 January 2009 03:35:44 pm Sergei Shtylyov wrote:
> > Hello.
> >
> > Dmitry Gryazin wrote:
> > >>>> True.  However it should be possible to handle it correctly by adding
> > >>>> the
> > >>>> DMA quirk to the respective host drivers (seems to be via82cxxx.c in
> > >>>> case of
> > >>>> IEI PCISA-C3/EDEN).
> > >>>
> > >>>   Yeah, this seems a viable approach...
> > >>>
> > >>>> Kirill, could you please look into adding such quirk to via82cxxx
> > >>>> instead?
> > >>>>
> > >>>> [ It seems the best place to add it would be via_init_one() as we
> > >>>> could just
> > >>>
> > >>>   No, not really -- the issue is not at all as simple as this patch
> > >>> tried to present it. Looking at its "Quick Startup Reference"
> > >>> (http://f.ipc2u.ru/files/add/doc/496/M_PCISA-C800EV_ENG.pdf), the EPIC
> > >>> board has *two* normal IDE connectors in addition to the CF slot
> > >>> (connected to the secondary port -- and it seems possible that a hard
> > >>> drive can be connected to the same port as CF), so the right place
> > >>> seems to rather be in [mu]dma_filter() methods -- and the decision
> > >>> should be strictly based on the drive type indicating CF, i.e. by
> > >>> calling ata_id_is_cfa().
> 
> I have tried my old Trancend 64Mb, RamStar 521Mb and NCP 64Mb cards. My old 
> cards returned right id[ATA_ID_CONFIG] = 0x848A.
> 
> But I have to use Kingston CF Card 1Gb 2008.
> ata_id_is_cfa() returns 0 for it and
> id[ATA_ID_MAJOR_VER]	= 0
> id[ATA_ID_CONFIG]		= 0x044A
> 
> I have only CF+ specification revision 2.0, but I've found in wiki:
> (http://en.wikipedia.org/wiki/CompactFlash#CF.2B_specification_revisions)
> "... While the current revision 4.1 from 2004 works only in ATA mode, ..."
> 
> So I have reached an impasse. How to identify modern CF cards?

Sorry that I missed it before but if indeed normal IDE devices/connectors can
be used with IDE2 then I see no sane/reliable way to detect CF devices using
buggy on-board slot... unless this slot is hardwired to be master (or slave)?

Thanks,
Bart
