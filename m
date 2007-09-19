Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXISWlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXISWlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXISWlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:41:24 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:46361 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbXISWlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:41:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 18:41:23 EDT
Date: Wed, 19 Sep 2007 15:34:42 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Jonathan Corbet <corbet@lwn.net>
cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       akpm@linux-foundation.org, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] cafe_ccic: default to allocating
 DMA buffers at probe time
In-Reply-To: <11514.1190230317@lwn.net>
Message-ID: <Pine.LNX.4.58.0709191527120.27377@shell4.speakeasy.net>
References: <11514.1190230317@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Jonathan Corbet wrote:
> Andres Salomon <dilinger@queued.net> wrote:
> > This patch makes DMA buffer allocation happen during device probe by
> > default, and changes the parameter to 'alloc_bufs_at_read'.  The
> > camera hardware is there, if the cafe_ccic driver is enabled/loaded it
> > should do its best to ensure that the camera is actually usable;
> > delaying DMA buffer allocation saves an insignicant amount of memory,
> > and causes the driver to be much less useful.
>
> The amount of memory isn't quite "insignificant" (three 640x480x2
> buffers), but the OLPC people clearly need things to work this way.
> There are, as far as I know, no other systems out there using the CAFE
> controller.  Making things work by default for the one user (with a fair
> number of deployed systems!) makes sense to me.  So...
>
>   Acked-by: Jonathan Corbet <corbet@lwn.net>
>
> That said, I do prefer the original name for the parameter.

Changing the parameter name will break the configuration of anyone who was
using the existing parameter.  It also means everyone who has multiple
kernels installed and uses this parameter will need to have one
configuration for old kernels and a different configuration for new
kernels.

In the default really needs to be changed (what's so hard about setting
alloc_bufs_at_load in /etc/modprobe{.d,.config}?) then just change the
default of the existing parameter.  That avoids the whole problem with
different configration files for different module versions.
