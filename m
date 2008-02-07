Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbYBGTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbYBGTIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbYBGTIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:08:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:64622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761285AbYBGTIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:08:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,317,1199692800"; 
   d="scan'208";a="376383582"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: out-of-bounds array index
Date: Thu, 7 Feb 2008 11:03:18 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
References: <20080207185642.GN15220@kernel.dk>
In-Reply-To: <20080207185642.GN15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071103.18483.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2008 10:56 am Jens Axboe wrote:
> Hi,
>
> Just saw this from gcc:
>
> drivers/char/drm/i915_drv.c: In function ?i915_suspend?:
> drivers/char/drm/i915_drv.c:173: warning: array subscript is above array
> bounds
>   CC [M]  drivers/char/drm/i915_dma.o
> drivers/char/drm/i915_drv.c: In function ?i915_resume?:
> drivers/char/drm/i915_drv.c:220: warning: array subscript is above array
> bounds
>
> It's this code:
>
>         dev_priv->saveGR[0x18] =
>                 i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18);
>
> which looks legit, since saveGR is
>
>         u8 saveGR[24];
>
> It has been introduced by commit
> ba8bbcf6ff4650712f64c0ef61139c73898e2165, which seems to be you Jesse.

I'll take a look, thanks.

Jesse
