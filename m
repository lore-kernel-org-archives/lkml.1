Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbZITVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbZITVGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZITVGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:06:36 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:51235 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZITVGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=s193K5l0AZxqvkIj0b4ZZYbQy1DfaRJli5LiAtB1uBLUy8uhFWwER2XjfSmgAnBqpv
         0UKiL4VCXWqLpPZFegajnDn4gWVum/Xql1KswT5Ma5N3VxK8kg+WVOwm7OqB3txUhFds
         6zUBkuJxIHyvU8Fdo8NjOrik1TiWocagik/n8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] libata:ide: Fix udma timings of pdc202xx_old controllers
Date: Sun, 20 Sep 2009 21:48:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-04082-g1824090-dirty; KDE/4.3.1; i686; ; )
Cc: "Jung-Ik (John) Lee" <jilee@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8b5805ff0909171602v3dc10db9i5920be3a2abf2e04@mail.gmail.com> <8b5805ff0909171654i515c832bm570db9bd5936b11a@mail.gmail.com> <4AB37492.90407@ru.mvista.com>
In-Reply-To: <4AB37492.90407@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <200909202148.36109.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 September 2009 13:52:50 Sergei Shtylyov wrote:
> Hello.
> 
> Jung-Ik (John) Lee wrote:
> 
> >>>From: John(Jung-Ik) Lee <jilee@google.com>
> 
> >>>Fix udma timings of pdc202xx_old controllers.
> >>>MB=1, MC=1 (0x20, 0x01) for all UDMA modes of pdc2026{57}.
> 
>     The patch should be broken in two as it's for 2 different subsystems.
> 
> >>On what documentation is this based ?
> 
> > I have two documents, 20265, and 20267, and both need to set to the
> > same single value for all UDMA modes.
> 
> > Doc 1:
> >   PDC20265 Bus Mastering Ultra DMA PCI –ATA/ATAPI Controller
> > Specification Rev 2.0
> >   #7.17.2, Ultra DMA Data Transfer Speed list
> >     For all Ultra DMA mode, MB, MC = 01h, 01h
> 
> > Doc 2:
> >   PDC20267 Bus Mastering Ultra DMA PCI –ATA/ATAPI Controller
> > Specification Rev 2.0
> >   #7.17.2, Ultra DMA Data Transfer Speed list
> >     For all Ultra DMA mode, MB, MC = 01h, 01h

I think that this patch is going in the right direction but it needs to also
take care of 66MHz internal clock setting:

* Please note that the same docs say that "For all Ultra DMA modes, 66MHz
  internal clock will be used instead of 33MHz internal clock." and that this
  is not true in case of Linux drivers.

* PDC20246 has no 66MHz internal clock AFAIK so those changes should not be
  applied for this controller.

> > Are there other pdc202xx old controllers that are different?
> 
>     There are PDC20262 and PDC20246. We should ask Bart -- he probably has 
> the documatation for them...

He doesn't, unfortunately..
