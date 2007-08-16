Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXHPXtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXHPXtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbXHPXsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:48:55 -0400
Received: from web25003.mail.ukl.yahoo.com ([217.146.183.106]:24099 "HELO
	web25003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762739AbXHPXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:48:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=GKk6XgIwC0pOeytCPmpFerbBvvoIDEgZvFjEhX8274/JKCE9JsCaM/EZIRNatzjOOSLrw5IzWfEkn6GJYwp72VTIKWFGTJflUkpERdhUdb6qcbgFpRJNBwAgIe9Iu7sef25YxcB0ISYRkHeT5AEULvSPsRyqYgpRCCennbH/MWM=;
X-YMail-OSG: 2QQcMq8VM1kKbBcet_A1H9ZjHFju7c7nNI6i8CFNYiz8iNTVrwdpAKOjPhK3noERxZKaKmVyjbmMNNTRm5tLN8FyYAma2oDdc6mIAbN751k2u.x3KvohF7bN_vE-
Date: Fri, 17 Aug 2007 00:48:39 +0100 (BST)
From: Steven Newbury <s_j_newbury@yahoo.co.uk>
Subject: Re: [PATCH] pxa2xx PCMCIA timing issue on iPAQ H5550
To: Milan Plzik <milan.plzik@gmail.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1187256497.16454.41.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <167613.90719.qm@web25003.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Milan Plzik <milan.plzik@gmail.com> wrote:

> On Å t, 2007-08-09 at 16:06 +0100, Steven Newbury wrote:
> > --- Milan Plzik <milan.plzik@gmail.com> wrote:
> > 
> > >   Good day,
> > > 
> > >   recently I've been trying to get working PCMCIA interface on H5000
> > > ipaq series, using dual PCMCIA sleeve. So far things work correctly, but
> > > I had to do one modification to drivers/pcmcia/pxa2xx_base.c to get the
> > > interface working with orinoco gold PCMCIA card (wired pcnet_cs ethernet
> > > card worked even without this modification). Patch attached.
> > > 
> > >   The issue has something to do with assert time on PCMCIA bus, but I'm
> > > not really sure what -- I found the working value just by trial&error
> > > approach. I'm not sure how is the assert value in pxa2xx_mcxx_asst
> > > calculated (I know, simple formula, but the reason why is it calculated
> > > that way is not obvious for me), neither that my modification is
> > > correct. It just works with iPAQ. 
> > > 
> > I posted a patch to linux-arm-kernel which reworked the timing code.  The
> > existing is/was IMHO wrong and this showed up for me with frequency scaling
> > where the code would not keep the PCMCIA timings constant with changes to
> the
> > core frequency.  Here it is:
> > http://marc.info/?l=linux-arm-kernel&m=116861295404294&w=2
> 
>   I found out that drivers/pcmcia/pxa2xx_base.c from handhelds.org tree
> was a bit modified. I tried both vanilla kernel tree and vanilla+this
> patch -- both worked with pcnet_cs, and neither one with orinoco card.
> As far as I understand, handhelds.org modification makes use of memory
> clock instead of cpu clock for calculations. But even when using old
> handhelds.org driver with modified formulas, orinoco card won't
> initialize.
> 
What actually happens?  I'm using a spectrum24 and it works fine on my Zaurus
SL-C3100.  Is it trying to load the firmware?  I'm still using 2.6.20, so if
something has broken since I don't know about it.

>   I'm not really sure how things should be calculated, I'll try ask
> folks who modified the hh.org driverto see what could cause the
> problems.
> 
It is all detailed in the PXA2xx manuals.  I did try to enough details in my
comments to make sense of the calculation.  As was commented on when I posted
it, it isn't ideal since it uses divides which are relatively slow on ARMs.


Steve


      ___________________________________________________________ 
Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html
