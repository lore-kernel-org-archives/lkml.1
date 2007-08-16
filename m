Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXHPJ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXHPJ3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbXHPJ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:29:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbXHPJ3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ttE8XtxR0gtvd88Cn/KVKTzYY9Q+upkekpJkJl9kj5wyxnhDCRLEVBvMHu5zoJ4TzU6FROX5z2ZWDuEe/1hd6c2iEnDiRyn91r8yPVnrLvfe1T9TVdvDCNG2MvCKZL9m+xqNYIukFZHAQdoFVGUNrXlPTxdHM3X3cItIuN95DTc=
Subject: Re: [PATCH] pxa2xx PCMCIA timing issue on iPAQ H5550
From: Milan Plzik <milan.plzik@gmail.com>
To: Steven Newbury <s_j_newbury@yahoo.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
In-Reply-To: <817976.91299.qm@web25012.mail.ukl.yahoo.com>
References: <817976.91299.qm@web25012.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 16 Aug 2007 11:28:17 +0200
Message-Id: <1187256497.16454.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Št, 2007-08-09 at 16:06 +0100, Steven Newbury wrote:
> --- Milan Plzik <milan.plzik@gmail.com> wrote:
> 
> >   Good day,
> > 
> >   recently I've been trying to get working PCMCIA interface on H5000
> > ipaq series, using dual PCMCIA sleeve. So far things work correctly, but
> > I had to do one modification to drivers/pcmcia/pxa2xx_base.c to get the
> > interface working with orinoco gold PCMCIA card (wired pcnet_cs ethernet
> > card worked even without this modification). Patch attached.
> > 
> >   The issue has something to do with assert time on PCMCIA bus, but I'm
> > not really sure what -- I found the working value just by trial&error
> > approach. I'm not sure how is the assert value in pxa2xx_mcxx_asst
> > calculated (I know, simple formula, but the reason why is it calculated
> > that way is not obvious for me), neither that my modification is
> > correct. It just works with iPAQ. 
> > 
> I posted a patch to linux-arm-kernel which reworked the timing code.  The
> existing is/was IMHO wrong and this showed up for me with frequency scaling
> where the code would not keep the PCMCIA timings constant with changes to the
> core frequency.  Here it is:
> http://marc.info/?l=linux-arm-kernel&m=116861295404294&w=2

  I found out that drivers/pcmcia/pxa2xx_base.c from handhelds.org tree
was a bit modified. I tried both vanilla kernel tree and vanilla+this
patch -- both worked with pcnet_cs, and neither one with orinoco card.
As far as I understand, handhelds.org modification makes use of memory
clock instead of cpu clock for calculations. But even when using old
handhelds.org driver with modified formulas, orinoco card won't
initialize.

  I'm not really sure how things should be calculated, I'll try ask
folks who modified the hh.org driverto see what could cause the
problems.

> 
> 
> Steve
> 

	Milan

> 
>       ___________________________________________________________
> For email that puts you in control, choose Yahoo! Mail.
> http://uk.docs.yahoo.com/mail/addressguard2.html

