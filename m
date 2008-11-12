Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYKLSY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYKLSY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYKLSYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:24:48 -0500
Received: from outbound-mail-157.bluehost.com ([67.222.39.37]:56648 "HELO
	outbound-mail-157.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751859AbYKLSYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:24:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=fUCfOoKt94E7Ju39CDaY4LLc6SbzCKeYt/iepByOf9GkwI6RKBCcBejjBu/AqkQ7JJETrpRivhpbIFMvb9VKplMz6e8P+8eC/F3brBkdLT/UIetdoT9VvjcZfDY2rVqu;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Nico -telmich- Schottelius" <nico-linux-next@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current suspend issues on Lenovo X200
Date: Wed, 12 Nov 2008 10:24:44 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Andres Freund <andres@anarazel.de>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810241123.17883.jbarnes@virtuousgeek.org> <20081025145329.GB4273@denkbrett.schottelius.org>
In-Reply-To: <20081025145329.GB4273@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121024.44502.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 25, 2008 7:53 am Nico -telmich- Schottelius wrote:
> Jesse Barnes [Fri, Oct 24, 2008 at 11:23:17AM -0700]:
> > On Friday, October 24, 2008 7:28 am Andres Freund wrote:
> > > Hi Nico,
> > >
> > > On Thursday 23 October 2008 22:43:26 Nico -telmich- Schottelius wrote:
> > > >  - 2.6.27-next-20081023:
> > > >    -> no X running (because xorg does not work with that kernel)
> > >
> > > I think what you need is one rather short fix for the intel xorg
> > > driver:
> > >
> > > diff --git a/src/i830_driver.c b/src/i830_driver.c
> > > index c1d61f4..eaf5d27 100644
> > > --- a/src/i830_driver.c
> > > +++ b/src/i830_driver.c
> > > @@ -502,8 +502,8 @@ I830DetectMemory(ScrnInfoPtr pScrn)
> > >     range = gtt_size + 4;
> > >
> > >     /* new 4 series hardware has seperate GTT stolen with GFX stolen */
> > > - if (IS_G4X(pI830))
> > > - range = 0;
> > > + if (IS_G4X(pI830) || IS_GM45(pI830))
> > > + range = 4;
> > >
> > >     if (IS_I85X(pI830) || IS_I865G(pI830) || IS_I9XX(pI830)) {
> > >        switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
> > >
> > > (Out of the "[git pull] agp patches for 2.6.28-rc1" thread)
> >
> > Something like this might also help.
> >
> > G4x chips do their own memory arbitration management, so we shouldn't
> > trying to save/restore the DSPARB reg.
>
> I'm a bit confused. Which of both patches against 2.6.28-rc1 should I try?

Have you tried recent (last few days) git bits of the kernel and xf86-video-
intel?

Jesse
