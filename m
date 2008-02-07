Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYBGTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYBGTgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbYBGTgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:36:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:45307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087AbYBGTgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:36:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,317,1199692800"; 
   d="scan'208";a="514962220"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: out-of-bounds array index
Date: Thu, 7 Feb 2008 11:28:55 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
References: <20080207185642.GN15220@kernel.dk> <Pine.LNX.4.64.0802072019570.25157@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802072019570.25157@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071128.55935.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2008 11:21 am Jan Engelhardt wrote:
> On Feb 7 2008 19:56, Jens Axboe wrote:
> >Just saw this from gcc:
> >
> >drivers/char/drm/i915_drv.c: In function ?i915_suspend?:
> >drivers/char/drm/i915_drv.c:173: warning: array subscript is above array
> >bounds
> >  CC [M]  drivers/char/drm/i915_dma.o
> >drivers/char/drm/i915_drv.c: In function ?i915_resume?:
> >drivers/char/drm/i915_drv.c:220: warning: array subscript is above array
> >bounds
> >
> >It's this code:
> >
> >        dev_priv->saveGR[0x18] =
> >                i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18);
> >
> >which looks legit, since saveGR is
>
> It is not legit at all. 0x18 is the 25th position in the array,
> but it is only 24 big. (Excluding play-hide-and-seek games like
> allocating more in case of malloc or char *foo[0].)

I think he was saying that the warning was legit.  Anyway, my gcc isn't smart 
enough to emit warnings like this, maybe it's time to ugprade...

Jesse
