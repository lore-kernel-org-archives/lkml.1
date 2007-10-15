Return-Path: <linux-kernel-owner+w=401wt.eu-S1765608AbXJOSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765608AbXJOSCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbXJOSBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:01:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54294 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763771AbXJOSBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:01:31 -0400
Subject: Re: [2.6 patch] ivtv: fix NULL dereference
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Adrian Bunk <bunk@kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710142003.20323.hverkuil@xs4all.nl>
References: <20071014175137.GM4211@stusta.de>
	 <200710142003.20323.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Date: Mon, 15 Oct 2007 16:01:20 -0200
Message-Id: <1192471280.5240.121.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Dom, 2007-10-14 às 20:03 +0200, Hans Verkuil escreveu:
> On Sunday 14 October 2007 19:51:37 Adrian Bunk wrote:
> > We shouldn't dereference "itv" when we know it's NULL...
> >
> > Spotted by the Coverity checker.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > ---
> > --- linux-2.6/drivers/media/video/ivtv/ivtv-fileops.c.old	2007-10-14
> > 19:17:12.000000000 +0200 +++
> > linux-2.6/drivers/media/video/ivtv/ivtv-fileops.c	2007-10-14
> > 19:18:05.000000000 +0200 @@ -947,7 +947,7 @@ int
> > ivtv_v4l2_open(struct inode *inode,
> >  	if (itv == NULL) {
> >  		/* Couldn't find a device registered
> >  		   on that minor, shouldn't happen! */
> > -		IVTV_WARN("No ivtv device found on minor %d\n", minor);
> > +		printk(KERN_WARNING "No ivtv device found on minor %d\n", minor);
> >  		return -ENXIO;
> >  	}
> 
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Mauro, can you merge this with 2.6.24 as well? Or shall I add it to my 
> ivtv tree with my other outstanding fixes?

I'm applying it. I prefer to handle the fix changesets first, in
separate requests.

Later, I'll pull from your ivtv tree, together with the changesets
you're working for 2.6.25.

Btw, as I've received the patch via Adrian's e-mail, I've changed your
tag to "Reviewed-by".
 
Cheers,
Mauro

