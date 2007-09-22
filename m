Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbXIVWQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbXIVWQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXIVWQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:16:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:38450 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbXIVWQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:16:10 -0400
To: adaplas@gmail.com, sylvain.meyer@worldonline.fr, akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Intel FB: cleanup and misc interlaced mode support
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 23 Sep 2007 00:16:05 +0200
Message-ID: <m33ax65ot6.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'll attach 4 patches for Intel FB (i830+) here:

1/4 - whitespace, bracket and other clean-ups (rather long)
      working with kernel-style brackets instead of:
----------------
void
function_name (int arg) {
----------------
      is a bit easier. I think it would be best to apply it in the
      beginning of the "patch period" to avoid potential conflicts.

2/4 - obvious changes and corrections

3/4 - the chip adds two halflines automatically in interlaced mode,
      we have to force the number of lines to be even

4/4 - allow odd- and even-field-first in interlaced modes, and
      proper sync to vertical retrace. It enables video players
      (got it working with MPlayer currently) to play perfect
      field-synced stream to RGB-connected (VGA output) TV set.

      This patch adds #define FB_VMODE_ODD_FLD_FIRST 4 in
      include/linux/fb.h, to be able to force odd field first (analog
      broadcast PAL and some PAL DVD discs use it) instead of even
      field (bottom) first, as used by NTSC, DV PAL, some PAL
      DVDs etc. Interlaced-only thing.

      This change need a coresponding change in fbset and probably in
      media players which want to set video mode themselves, I will
      do the fbset part and maybe MPlayer's if the fb.h patch is ok.

All four patches change only files in drivers/video/intelfb/, except
patch 4/4 which also adds FB_VMODE_ODD_FLD_FIRST in include/linux/fb.h.

Tested on i915G in 1440x576 50 Hz (I) with PAL TV.
-- 
Krzysztof Halasa
