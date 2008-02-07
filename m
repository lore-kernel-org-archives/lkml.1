Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbYBGS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbYBGS45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYBGS4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:56:48 -0500
Received: from brick.kernel.dk ([87.55.233.238]:4295 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbYBGS4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:56:47 -0500
Date: Thu, 7 Feb 2008 19:56:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: out-of-bounds array index
Message-ID: <20080207185642.GN15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just saw this from gcc:

drivers/char/drm/i915_drv.c: In function ?i915_suspend?:
drivers/char/drm/i915_drv.c:173: warning: array subscript is above array
bounds
  CC [M]  drivers/char/drm/i915_dma.o
drivers/char/drm/i915_drv.c: In function ?i915_resume?:
drivers/char/drm/i915_drv.c:220: warning: array subscript is above array
bounds

It's this code:

        dev_priv->saveGR[0x18] =
                i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18);

which looks legit, since saveGR is

        u8 saveGR[24];

It has been introduced by commit
ba8bbcf6ff4650712f64c0ef61139c73898e2165, which seems to be you Jesse.

-- 
Jens Axboe

