Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbZJLOdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbZJLOdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932301AbZJLOdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:33:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:46892 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314AbZJLOdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:33:02 -0400
Date: Mon, 12 Oct 2009 07:29:40 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree build failure] [PATCH] Revert "USB: musb: make
 HAVE_CLK support optional"
Message-ID: <20091012142940.GB1114@suse.de>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
 <20091012074221.GA19198@elte.hu>
 <8bd0f97a0910120605q17a586dag29cf4ab6d89dd29d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0910120605q17a586dag29cf4ab6d89dd29d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 09:05:57AM -0400, Mike Frysinger wrote:
> On Mon, Oct 12, 2009 at 03:42, Ingo Molnar wrote:
> >
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >> As usual, please test this for regressions, both new and old.
> >
> >>       USB: musb: make HAVE_CLK support optional
> >
> > This USB/Blackfin commit broke the x86 build with these config options:
> >
> >  CONFIG_USB_MUSB_HDRC=y
> >  CONFIG_USB_MUSB_HOST=y
> >  # CONFIG_USB_MUSB_PERIPHERAL is not set
> >  # CONFIG_USB_MUSB_OTG is not set
> >  # CONFIG_USB_GADGET_MUSB_HDRC is not set
> >  CONFIG_USB_MUSB_HDRC_HCD=y
> >  CONFIG_MUSB_PIO_ONLY=y
> >  CONFIG_USB_MUSB_DEBUG=y
> >
> > Because a side-effect of the patch was that it enabled the driver on x86
> > too which doesnt have HAVE_CLK. So this formerly embedded-only driver
> > got exposed on the more widely tested x86 platform.
> 
> this is dumb.  you're addressing unrealistic scenarios (randconfig) by
> reverting code for realistic scenarios.  how about updating the
> already present arch depend string instead.

We want 'randconfig' to work, so this is not unrealistic.  Have you not
seen Randy Dunlap's zillion patches to get this to all work properly
over the past months?

thanks,

greg k-h
