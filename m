Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYFBSew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYFBSew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYFBSeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:34:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYFBSen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:34:43 -0400
Date: Mon, 2 Jun 2008 15:34:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <bphilips@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
Message-ID: <20080602153420.2452889b@gaivota>
In-Reply-To: <20080602181035.GA440@plankton.ifup.org>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
	<1212421611.16924.246.camel@pmac.infradead.org>
	<20080602165649.01c2c680@core>
	<20080602181035.GA440@plankton.ifup.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 11:10:35 -0700
Brandon Philips <bphilips@suse.de> wrote:

> On 16:56 Mon 02 Jun 2008, Alan Cox wrote:
> > > Please can we revert the addition of _DEPRECATED to these ioctl
> > > definitions. Perhaps we can add a runtime warning if they actually get
> > > used? Or a compile-time warning if we can manage that?

A runtime warning won't probably work, since the control doesn't appear at the
ioctls that enumerates the supported controls, since no kernel driver uses
those controls.

> > Can you clarify the problem here ? Is this compile breakage as it appears
> > (See 'do not include kernel headers in user space apps') or runtime ?

The breakage appears only if you compile an userspace driver that uses those
defined symbols. No in-kernel driver uses such controls. I'm not sure if there
is any closed source or out-of-tree driver using they.

> It is compile breakage and was also discussed on
> fedora-devel-list@redhat.com with Mauro and myself CC'd.  The control
> number will be reserved forever to avoid binary breakage.
> 
> However, as Mauro noted in that conversation: "Those controls haven't
> been used by any Kernel drivers for a long time (I suspect that they
> were never used)."  Since no driver had ever implemented the control I
> figured user space application wouldn't be using it either.
> 
> If David wants to revert the _DEPRECATED tags that is fine; we can add a
> feature removal for a year from now if it gets merged.

I'm also ok on reverting the _DEPRECATED tags, but I would schedule its removal
at Documentation/feature-removal-schedule.txt to a shorter time. It doesn't
make much sense on keeping those unused controls for more than one kernel
version. So, I think we may schedule such removal for October/2008.

I'll apply your patch on my tree and send Linus on my next pull request.

Cheers,
Mauro
