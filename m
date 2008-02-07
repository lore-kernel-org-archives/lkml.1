Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbYBGUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbYBGUBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbYBGUB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:01:28 -0500
Received: from brick.kernel.dk ([87.55.233.238]:29715 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbYBGUB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:01:27 -0500
Date: Thu, 7 Feb 2008 21:01:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: out-of-bounds array index
Message-ID: <20080207200121.GO15220@kernel.dk>
References: <20080207185642.GN15220@kernel.dk> <Pine.LNX.4.64.0802072019570.25157@fbirervta.pbzchgretzou.qr> <200802071128.55935.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802071128.55935.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Jesse Barnes wrote:
> On Thursday, February 07, 2008 11:21 am Jan Engelhardt wrote:
> > On Feb 7 2008 19:56, Jens Axboe wrote:
> > >Just saw this from gcc:
> > >
> > >drivers/char/drm/i915_drv.c: In function ?i915_suspend?:
> > >drivers/char/drm/i915_drv.c:173: warning: array subscript is above array
> > >bounds
> > >  CC [M]  drivers/char/drm/i915_dma.o
> > >drivers/char/drm/i915_drv.c: In function ?i915_resume?:
> > >drivers/char/drm/i915_drv.c:220: warning: array subscript is above array
> > >bounds
> > >
> > >It's this code:
> > >
> > >        dev_priv->saveGR[0x18] =
> > >                i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18);
> > >
> > >which looks legit, since saveGR is
> >
> > It is not legit at all. 0x18 is the 25th position in the array,
> > but it is only 24 big. (Excluding play-hide-and-seek games like
> > allocating more in case of malloc or char *foo[0].)
> 
> I think he was saying that the warning was legit.  Anyway, my gcc isn't smart 
> enough to emit warnings like this, maybe it's time to ugprade...

of course, the reference was to the warning (I do know C and array
indexing 101 :-)

-- 
Jens Axboe

