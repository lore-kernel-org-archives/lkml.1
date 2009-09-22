Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZIVKbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZIVKbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZIVKbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:31:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42334 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbZIVKbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:31:32 -0400
Date: Tue, 22 Sep 2009 11:31:38 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Ingo Molnar <mingo@elte.hu>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [origin tree build failure] [PATCH] Re: [git pull] drm tree.
In-Reply-To: <20090922102726.GA31054@elte.hu>
Message-ID: <alpine.DEB.2.00.0909221130460.27951@skynet.skynet.ie>
References: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie> <20090921161207.GA9741@elte.hu> <alpine.DEB.2.00.0909220450440.7648@skynet.skynet.ie> <20090922102726.GA31054@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Subject: [PATCH] vgaarb: wrap the client register API so we can disable VGA ARB.
> > 
> > This provides an dummy register function so everything builds
> > if VGA arb is turned off.
> > 
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > ---
> >  include/linux/vgaarb.h |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> btw., i hope you have not commited this yet, there's a trivial problem 
> with this patch:

oops, i was going to push it to jbarnes after I had a chance to play with
it.

I'll clean it up and send it to jbarnes tomorrow.

Dave.

> 
> > diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
> > index e81c64a..b0feb79 100644
> > --- a/include/linux/vgaarb.h
> > +++ b/include/linux/vgaarb.h
> > @@ -41,7 +41,7 @@
> >   *     interrupts at any time.
> >   */
> >  extern void vga_set_legacy_decoding(struct pci_dev *pdev,
> > -									unsigned int decodes);
> > +				    unsigned int decodes);
> >  
> >  /**
> >   *     vga_get         - acquire & locks VGA resources
> > @@ -193,8 +193,17 @@ static inline int vga_conflicts(struct pci_dev *p1, struct pci_dev *p2)
> >   * They driver will get a callback when VGA arbitration is first used
> >   * by userspace since we some older X servers have issues.
> >   */
> > +#if defined(CONFIG_VGA_ARB)
> >  int vga_client_register(struct pci_dev *pdev, void *cookie,
> >  			void (*irq_set_state)(void *cookie, bool state),
> >  			unsigned int (*set_vga_decode)(void *cookie, bool state));
> > +#else
> > +static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
> > +				      void (*irq_set_state)(void *cookie, bool state),
> > +				      unsigned int (*set_vga_decode)(void *cookie, bool state));
> > +{
> > +	return 0;
> > +}
> > +#endif
> 
> that ';' in the inline prototype is bogus, this wont build.
> 
> 	Ingo
> 
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry&reg; Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay 
> ahead of the curve. Join us from November 9&#45;12, 2009. Register now&#33;
> http://p.sf.net/sfu/devconf
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 
