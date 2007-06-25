Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXFYXqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXFYXqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFYXqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:46:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33299 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbXFYXqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:46:06 -0400
Date: Mon, 25 Jun 2007 16:47:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, perex@suse.cz,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ALSA: fix ice1712 section mismatch
Message-Id: <20070625164743.3ad70def.randy.dunlap@oracle.com>
In-Reply-To: <20070625164110.94ecade1.akpm@linux-foundation.org>
References: <20070625161739.8115c40c.randy.dunlap@oracle.com>
	<20070625164110.94ecade1.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 16:41:10 -0700 Andrew Morton wrote:

> On Mon, 25 Jun 2007 16:17:39 -0700 Randy Dunlap <randy.dunlap@oracle.com>
> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Cannot mix const and __initdata:
> > sound/pci/ice1712/prodigy192.c:708: error: ak4114_controls causes a section type conflict
> > 
> 
> This is a fatal compilation error, isn't it?

Yes.

> > ---
> >  sound/pci/ice1712/prodigy192.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-2.6.22-rc6.orig/sound/pci/ice1712/prodigy192.c
> > +++ linux-2.6.22-rc6/sound/pci/ice1712/prodigy192.c
> > @@ -705,7 +705,7 @@ static int ak4114_input_sw_put(struct sn
> >  }
> >  
> >  
> > -static const struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
> > +static struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
> >  	{
> >  		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
> >  		.name = "MIODIO IEC958 Capture Input",
> 
> That patch is already in the alsa git tree (has been there for five days),
> so I would of course prefer that the alsa guys merge it into 2.6.22.

OK, I admit that I never look there.

> However alsa merges are a bit spotty, so I'll queue this up anyway and will
> merge it in a day or three if nothing else happens, OK?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
