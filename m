Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbYBGTVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbYBGTVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbYBGTVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:21:09 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50634 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYBGTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:21:08 -0500
Date: Thu, 7 Feb 2008 20:21:06 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: Re: out-of-bounds array index
In-Reply-To: <20080207185642.GN15220@kernel.dk>
Message-ID: <Pine.LNX.4.64.0802072019570.25157@fbirervta.pbzchgretzou.qr>
References: <20080207185642.GN15220@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 7 2008 19:56, Jens Axboe wrote:
>
>Just saw this from gcc:
>
>drivers/char/drm/i915_drv.c: In function ?i915_suspend?:
>drivers/char/drm/i915_drv.c:173: warning: array subscript is above array
>bounds
>  CC [M]  drivers/char/drm/i915_dma.o
>drivers/char/drm/i915_drv.c: In function ?i915_resume?:
>drivers/char/drm/i915_drv.c:220: warning: array subscript is above array
>bounds
>
>It's this code:
>
>        dev_priv->saveGR[0x18] =
>                i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18);
>
>which looks legit, since saveGR is

It is not legit at all. 0x18 is the 25th position in the array,
but it is only 24 big. (Excluding play-hide-and-seek games like
allocating more in case of malloc or char *foo[0].)

