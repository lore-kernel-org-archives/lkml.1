Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZBPVyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZBPVyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZBPVyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:54:00 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:46110 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZBPVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=F90EtmqvxoWGJs5Uq+/dlPZF2Y/cYbv9iBxYsobP+IIgDByG+Bh8Bn/SZDGSBRUd/S
         x/Rot2X5JA7r021djoOm5WxqXfowZb/KWSrGRVtKQTgNf0bT478ytsAU3d3SLBqzh8bb
         FyOr6BBBTX7Qx9j91pRjOdpQLXRKZNAg8Ys8s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 01/10] ide: add flags query macros
Date: Mon, 16 Feb 2009 22:07:08 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-next-20090213; KDE/4.2.0; i686; ; )
Cc: petkovbb@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <20090215180141.GB5156@gollum.tnic> <20090215205141.GA5901@uranus.ravnborg.org>
In-Reply-To: <20090215205141.GA5901@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162207.08535.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Sam Ravnborg wrote:
> On Sun, Feb 15, 2009 at 07:01:41PM +0100, Borislav Petkov wrote:
> > Hi,
> > 
> > > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > > ---
> > > >  include/linux/ide.h |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 files changed, 166 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/include/linux/ide.h b/include/linux/ide.h
> > > > index c75631c..f133062 100644
> > > > --- a/include/linux/ide.h
> > > > +++ b/include/linux/ide.h
> > > > @@ -497,6 +497,82 @@ enum {
> > > >  	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 24),
> > > >  };
> > > >  
> > > > +#define ide_drv_drq_int(drive) \
> > > > +	((drive)->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)
> > > 
> > > Why not use a static inline here so we get proper typecheck.
> > > And then convert the return result to a bool (0/1) so you
> > > do not have to do this at the call site.
> > > 
> > > I counted at least three places in ide-cd that does a local
> > > transformation to a bool and I saw nowhere the actual bit value
> > > was used.
> > 
> > I'm assuming you're talking about those places (and similar):
> > 
> > drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
> 
> And in other places we do:
> 
> ide_drv_drq_int(drive) ? 1 : 0
> 
> > Well, actually we almost never use the 0/1 bool value and this one
> > case is more of an exception. If you take a closer look, we don't have
> > setters/getters ...,
> I scanned all your patches and I did not find a single place where
> the macros was not used as a bool value.
> Mostly in if (ide_drv_drq_int(drive)) .. and ide_drv_drq_int(drive) &&
> statements.
> 
> > So the macros as such are
> > simply to save some stack and improve readability and since the whole
> > thing keeps changing we might just as well turn them into static inlines
> > one fine day :).
> 
> gcc will optmize the static inline functions so there is no drawbacks only
> better type checking.

Lets do it "today" then. :)

Thanks,
Bart
