Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZJIFFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZJIFFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbZJIFFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:05:35 -0400
Received: from [93.93.128.226] ([93.93.128.226]:54078 "EHLO
	bhuna.collabora.co.uk" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZJIFFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:05:34 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Oct 2009 01:05:34 EDT
Date: Fri, 9 Oct 2009 00:53:18 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: wuzhangjin@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       loongson-dev@googlegroups.com
Subject: Re: [PATCH] CS5535: Remove the X86 platform dependence of
 SND_CS5535AUDIO
Message-ID: <20091009005318.7174938c@mycelium.queued.net>
In-Reply-To: <1255060287.16819.1.camel@falcon>
References: <1255059842-12160-1-git-send-email-wuzhangjin@gmail.com>
	<1255060287.16819.1.camel@falcon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Oct 2009 11:51:27 +0800
Wu Zhangjin <wuzhangjin@gmail.com> wrote:

> On Fri, 2009-10-09 at 11:44 +0800, Wu Zhangjin wrote:
> > There is no platform dependence of SND_CS5535AUDIO before 2.6.31,
> > Not sure who have touched this part, but SND_CS5535AUDIO is at least
> > available on Loongson family machines, so, Remove the platform
> > dependence directly.
> > 
> > Reported-by: rixed@happyleptic.org
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > ---
> >  sound/pci/Kconfig |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> > index fb5ee3c..75c602b 100644
> > --- a/sound/pci/Kconfig
> > +++ b/sound/pci/Kconfig
> > @@ -259,7 +259,6 @@ config SND_CS5530
> >  
> >  config SND_CS5535AUDIO
> >  	tristate "CS5535/CS5536 Audio"
> > -	depends on X86 && !X86_64
> 
> or use this?
> 
> 	depends on (X86 && !X86_64) || MIPS
> 
> Regards,
> 	Wu Zhangjin
> 


I'd say just remove the arch dependency (and make sure it builds and
doesn't obviously explode w/ x86-64). There's no need for it, afaict.
It's been there since at least 2005 (git commit 230b5c1a).


