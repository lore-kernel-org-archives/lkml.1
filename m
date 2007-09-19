Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbXISWnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbXISWnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbXISWnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:43:35 -0400
Received: from mail.queued.net ([207.210.101.209]:1304 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbXISWnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:43:35 -0400
Date: Wed, 19 Sep 2007 18:43:38 -0400
From: Andres Salomon <dilinger@queued.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       akpm@linux-foundation.org, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] cafe_ccic: default to allocating
 DMA buffers at probe time
Message-Id: <20070919184338.64fc6e89.dilinger@queued.net>
In-Reply-To: <Pine.LNX.4.58.0709191527120.27377@shell4.speakeasy.net>
References: <11514.1190230317@lwn.net>
	<Pine.LNX.4.58.0709191527120.27377@shell4.speakeasy.net>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 15:34:42 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Wed, 19 Sep 2007, Jonathan Corbet wrote:
> > Andres Salomon <dilinger@queued.net> wrote:
> > > This patch makes DMA buffer allocation happen during device probe by
> > > default, and changes the parameter to 'alloc_bufs_at_read'.  The
> > > camera hardware is there, if the cafe_ccic driver is enabled/loaded it
> > > should do its best to ensure that the camera is actually usable;
> > > delaying DMA buffer allocation saves an insignicant amount of memory,
> > > and causes the driver to be much less useful.
> >
> > The amount of memory isn't quite "insignificant" (three 640x480x2
> > buffers), but the OLPC people clearly need things to work this way.
> > There are, as far as I know, no other systems out there using the CAFE
> > controller.  Making things work by default for the one user (with a fair
> > number of deployed systems!) makes sense to me.  So...
> >
> >   Acked-by: Jonathan Corbet <corbet@lwn.net>
> >
> > That said, I do prefer the original name for the parameter.
> 
> Changing the parameter name will break the configuration of anyone who was
> using the existing parameter.  It also means everyone who has multiple

We (OLPC) are the only ones using this driver, as we are the only ones with
this hardware.  Marvell designed the cafe for us, and it is not available
on the market yet.  Backwards compatibility at this point is not a concern.

> kernels installed and uses this parameter will need to have one
> configuration for old kernels and a different configuration for new
> kernels.
> 
> In the default really needs to be changed (what's so hard about setting
> alloc_bufs_at_load in /etc/modprobe{.d,.config}?) then just change the
> default of the existing parameter.  That avoids the whole problem with
> different configration files for different module versions.

We're building the driver in statically; there's no point for us to make
it a module.  We could add a kernel argument, yes, but that quickly
becomes unwieldy as we require more and more.  We've actually been trying
to cut down the number of kernel args we use.


That said, I'm not opposed to keeping the parameter name the same while
making the default 1; I just thought that the name 'alloc_bufs_at_read' was
clearer.  Another option is to change it to 'no_alloc_bufs_at_load'.  Jon,
any preference there?


-- 
Andres Salomon <dilinger@queued.net>
