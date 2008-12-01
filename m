Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYLAPHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYLAPHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 10:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYLAPHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 10:07:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYLAPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 10:07:03 -0500
Date: Mon, 1 Dec 2008 13:06:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Message-ID: <20081201130643.661f5743@pedra.chehab.org>
In-Reply-To: <200812011524.43499.laurent.pinchart@skynet.be>
References: <200812011246.08885.hverkuil@xs4all.nl>
	<200812011429.54019.laurent.pinchart@skynet.be>
	<200812011445.50115.hverkuil@xs4all.nl>
	<200812011524.43499.laurent.pinchart@skynet.be>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Mon, 1 Dec 2008 15:24:43 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> > > I am all for pushing the changes to the v4l-dvb repository so they
> > > can get broader testing. I am, however, a bit more concerned about
> > > pushing the changes to Linus yet.
> >
> > They will of course go to linux-next and end up in 2.6.29 when the merge
> > window opens. It's obviously not for 2.6.28.
> 
> I would say 2.6.29 is a bit early, but I can live with that.

It also seems a bit early to me, but it may work. I'll try to schedule some
time this week for a deep review.

> > In addition, these changes make it easier as well to use the new i2c API
> > in bridge drivers (in 2.6.29 the old-style I2C probing will be
> > deprecated, so we need to convert). So we get many benefits with just
> > these changes.

IMO, this is one of the top priorities: the old-style i2c used on some bridge
drivers like saa7134 and cx88 are causing malfunctions that can't be easily
solved. I would like to see a fix for this for 2.6.29.

> > Of course, I want to add more v4l2 framework support to these new
> > structures, but I don't have any code yet for that anyway, just lots of
> > ideas. Start simple, then expand.
> >
> > > I don't know if that's possible at all, or if all changes in v4l-dvb
> > > are automatically selected for a push to the git repository whenever
> > > Mauro triggers the hg->git process.
> >
> > Well, they go to linux-next, but is that a problem?

I only send Linus the patches that are already ok, but I generally prefer to
postpone a merge for the end of a merge window, when the patch is not meant to
be at the next version.

> In a few months time (probably even earlier) the v4l2_device structure will be 
> reworked (and possible renamed). 

Hmm... why? it would be better to try to have the KABI changes for it at the
same kernel release if possible.

> I'm fine with it going to linux-next now if 
> we agree on the following.

> - We should only advocate v4l2_device usage for subdevices-aware video 
> devices. Porting all drivers to v4l2_device is currently pointless and will 
> only make future transitions more difficult.

This makes sense to me.

> - v4l2_device should be marked as experimental. I don't want to hear any 
> API/ABI breakage argument in a few months time when the framework will 
> evolve.

Are you meaning marking this as experimental at Kconfig? This seems too
complex, since we'll need to test for some var on every driver that were
converted, providing two KABI options for each converted driver (the legacy and
the v4l2_device way). This doesn't seem to be a good idea, since will add a lot
of extra complexity to debug bugs.

Cheers,
Mauro
