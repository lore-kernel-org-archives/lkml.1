Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZBOUt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZBOUt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZBOUtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:49:50 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:37537 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZBOUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:49:49 -0500
Date: Sun, 15 Feb 2009 21:51:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: petkovbb@gmail.com, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] ide: add flags query macros
Message-ID: <20090215205141.GA5901@uranus.ravnborg.org>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <1234699692-9452-2-git-send-email-petkovbb@gmail.com> <20090215133512.GA32621@uranus.ravnborg.org> <20090215180141.GB5156@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215180141.GB5156@gollum.tnic>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 07:01:41PM +0100, Borislav Petkov wrote:
> Hi,
> 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > ---
> > >  include/linux/ide.h |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 166 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/ide.h b/include/linux/ide.h
> > > index c75631c..f133062 100644
> > > --- a/include/linux/ide.h
> > > +++ b/include/linux/ide.h
> > > @@ -497,6 +497,82 @@ enum {
> > >  	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 24),
> > >  };
> > >  
> > > +#define ide_drv_drq_int(drive) \
> > > +	((drive)->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)
> > 
> > Why not use a static inline here so we get proper typecheck.
> > And then convert the return result to a bool (0/1) so you
> > do not have to do this at the call site.
> > 
> > I counted at least three places in ide-cd that does a local
> > transformation to a bool and I saw nowhere the actual bit value
> > was used.
> 
> I'm assuming you're talking about those places (and similar):
> 
> drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);

And in other places we do:

ide_drv_drq_int(drive) ? 1 : 0

> Well, actually we almost never use the 0/1 bool value and this one
> case is more of an exception. If you take a closer look, we don't have
> setters/getters ...,
I scanned all your patches and I did not find a single place where
the macros was not used as a bool value.
Mostly in if (ide_drv_drq_int(drive)) .. and ide_drv_drq_int(drive) &&
statements.

> So the macros as such are
> simply to save some stack and improve readability and since the whole
> thing keeps changing we might just as well turn them into static inlines
> one fine day :).
gcc will optmize the static inline functions so there is no drawbacks only
better type checking.

	Sam
