Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbXFWWSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbXFWWSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXFWWSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:18:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52754 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXFWWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:18:04 -0400
Subject: Re: [PATCH] saa7134: fix thread shutdown handling
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-kernel@vger.kernel.org,
       kraxel@bytesex.org, stable@kernel.org
In-Reply-To: <20070623095426.6049f883.akpm@linux-foundation.org>
References: <467AC742.7070007@suse.com>
	 <20070623095426.6049f883.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Sat, 23 Jun 2007 15:47:01 -0300
Message-Id: <1182624421.10174.30.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sáb, 2007-06-23 às 09:54 -0700, Andrew Morton escreveu:
> > On Thu, 21 Jun 2007 14:45:22 -0400 Jeff Mahoney <jeffm@suse.com> wrote:
> >  This patch changes the test for the thread pid from >= 0 to > 0.
> > 
> >  When the saa8134 driver initialization fails after a certain point,
> >  it goes through the complete shutdown process for the driver. Part
> >  of shutting it down includes tearing down the thread for tv audio.
> > 
> >  The test for tearing down the thread tests for >= 0. Since the dev
> >  structure is kzalloc'd, the test will always be true if we haven't
> >  tried to start the thread yet. We end up waiting on pid 0 to complete,
> >  which will never happen, so we lock up.
> > 
> >  This bug was observed in Novell Bugzilla 284718, when request_irq()
> >  failed.
> > 
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > 
> > ---
> > 
> >  drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-06-12 15:45:16.000000000 -0400
> > +++ b/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-06-15 14:16:14.000000000 -0400
> > @@ -1005,7 +1005,7 @@
> >  int saa7134_tvaudio_fini(struct saa7134_dev *dev)
> >  {
> >  	/* shutdown tvaudio thread */
> > -	if (dev->thread.pid >= 0) {
> > +	if (dev->thread.pid > 0) {
> >  		dev->thread.shutdown = 1;
> >  		wake_up_interruptible(&dev->thread.wq);
> >  		wait_for_completion(&dev->thread.exit);
> > 
> 
> This is no longer applicable to the dvb devel tree, because this code has
> been converted to the kthread API.
> 
> However I guess we do want this in 2.6.22 and in 2.6.21.x.  Mauro, if
> that's OK, do you want me to do the merges?

Yes, please, Andrew. I'm OK on merging this for the -stable trees.
> 
-- 
Cheers,
Mauro

