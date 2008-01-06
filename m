Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYAFS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYAFS6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYAFS6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:58:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:31950 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYAFS6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=M3I3un1gF7vraoKlHflRh23H0EsWvjyaHD/MNBr5BzuHykB92FF8yRB/1jHwkPqf1itong8hburOmgs+OnVCihvjYCKVhWxkvUHzMyah8hXXk2Q7Wts8o5w19h4AzxPmsWYKWk/LwgJMr8Wob4QhvhSFs6fMa3LPOQ5cVZ9j5FQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: FD Cami <francois.cami@free.fr>
Subject: Re: [PATCH] Re: Forcing modes in libata (was: SATA buffered read VERY slow)
Date: Sun, 6 Jan 2008 20:09:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Boldi <a1426z@gawab.com>, Jeff Garzik <jeff@garzik.org>,
       Zoltan Boszormenyi <zboszor@dunaweb.hu>
References: <200801051641.03927.a1426z@gawab.com> <200801061727.38206.bzolnier@gmail.com> <20080106190856.510ab90e@dimension.stilgar.hd.free.fr>
In-Reply-To: <20080106190856.510ab90e@dimension.stilgar.hd.free.fr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801062009.39162.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2008, FD Cami wrote:
> On Sun, 6 Jan 2008 17:27:38 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Sunday 06 January 2008, FD Cami wrote:
> > > On Sun, 6 Jan 2008 13:36:09 +0000
> > > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > 
> > > > On Sun, 6 Jan 2008 08:03:31 +0300
> > > > > > For now you can boot with libata.dma=1 to select DMA on disks
> > > > > > but not CD
> > > > > 
> > > > > Great, but why isn't this in the documentation?
> > > > 
> > > > Send patches
> > > 
> > > patch attached.
> > > 
> > > Description : Add libata.dma= to Documentation/kernel-parameters.txt
> > > 
> > > Found documentation in :
> > > http://www.mail-archive.com/linux-ide%40vger.kernel.org/msg09849.html
> > > http://www.redhat.com/archives/fedora-extras-commits/2007-October/msg04568.html
> > > 
> > > Signed-off-by: François Cami <francois.cami@free.fr>
> > 
> > diff -rU2 linux-2.6.24-rc6/Documentation/kernel-parameters.txt 
> > linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt
> > ---
> > linux-2.6.24-rc6/Documentation/kernel-parameters.txt        2008-01-06
> > 15:58:54.000000000 +0100 +++
> > linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt   2008-01-06
> > 16:11:20.000000000 +0100 @@ -883,4 +883,11 @@ C2 power state. 
> > +       libata.dma=     [LIBATA] DMA control
> > +                       libata.dma=0      Disable all PATA DMA like
> > old IDE
> > 
> > this doesn't seem entirely correct:
> > 
> > * IDE has "hdx=nodma" so you can disable DMA on per-device basis
> 
> I think that libata.dma=1 is designed to behave like 
> CONFIG_IDEDMA_ONLYDISK used to. "hdx=nodma" is more fine-grained than
> this.

Seems so but CONFIG_IDEDMA_ONLYDISK was removed on the same day
that "hdx=nodma" was introduced (Oct 16 2007)...

> > * is this really limited to PATA?
> 
> Alan's original patch took care of PATA. SATA support was added
> later by Jeff Garzik. Corrected documentation patch attached.
> 
> > +                       libata.dma=1      Disk DMA only
> > +                       libata.dma=2      ATAPI DMA only
> > +                       libata.dma=3      CF DMA only 
> 
> This is also wrong, it should be "libata.dma=4      CF DMA only"
> Thanks to Zoltan Boszormenyi <zboszor@dunaweb.hu> for catching this
> mistake.
> 
> Revised patch attached.

Thanks, looks good to me.

Bart
