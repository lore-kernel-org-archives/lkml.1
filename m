Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbXITAJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbXITAJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXITAI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:08:57 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:46798 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbXITAI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:08:57 -0400
Date: Wed, 19 Sep 2007 17:08:55 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Andres Salomon <dilinger@queued.net>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       akpm@linux-foundation.org, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] cafe_ccic: default to allocating
 DMA buffers at probe time
In-Reply-To: <20070919184338.64fc6e89.dilinger@queued.net>
Message-ID: <Pine.LNX.4.58.0709191703300.27377@shell4.speakeasy.net>
References: <11514.1190230317@lwn.net> <Pine.LNX.4.58.0709191527120.27377@shell4.speakeasy.net>
 <20070919184338.64fc6e89.dilinger@queued.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Andres Salomon wrote:
> On Wed, 19 Sep 2007 15:34:42 -0700 (PDT)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
> > On Wed, 19 Sep 2007, Jonathan Corbet wrote:
> > > Andres Salomon <dilinger@queued.net> wrote:
> > > > This patch makes DMA buffer allocation happen during device probe by
> > > > default, and changes the parameter to 'alloc_bufs_at_read'.  The
> > > > camera hardware is there, if the cafe_ccic driver is enabled/loaded it
> > > > should do its best to ensure that the camera is actually usable;
> > > > delaying DMA buffer allocation saves an insignicant amount of memory,
> > > > and causes the driver to be much less useful.
> > >
> > Changing the parameter name will break the configuration of anyone who was
> > using the existing parameter.  It also means everyone who has multiple
>
> We (OLPC) are the only ones using this driver, as we are the only ones with
> this hardware.  Marvell designed the cafe for us, and it is not available
> on the market yet.  Backwards compatibility at this point is not a concern.
>
> > kernels installed and uses this parameter will need to have one
> > configuration for old kernels and a different configuration for new
> > kernels.
> >
> > In the default really needs to be changed (what's so hard about setting
> > alloc_bufs_at_load in /etc/modprobe{.d,.config}?) then just change the
> > default of the existing parameter.  That avoids the whole problem with
> > different configration files for different module versions.
>
> We're building the driver in statically; there's no point for us to make
> it a module.  We could add a kernel argument, yes, but that quickly
> becomes unwieldy as we require more and more.  We've actually been trying
> to cut down the number of kernel args we use.

Ok, that seems like a good reason to change the default.
>
>
> That said, I'm not opposed to keeping the parameter name the same while
> making the default 1; I just thought that the name 'alloc_bufs_at_read' was
> clearer.  Another option is to change it to 'no_alloc_bufs_at_load'.  Jon,
> any preference there?

It seems like the name 'alloc_bufs_at_read' isn't quite right, since the
buffers will be allocated when the format is set, from
cafe_vidioc_s_fmt_cap().
