Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYFDWMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYFDWMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYFDWLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:11:25 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:25395 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYFDWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:11:23 -0400
Message-Id: <20080604220933.168145536@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 16:09:33 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 00/18] PNP: convert resource options to unified dynamic list, v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series converts the PNP resource option structures
to a unified linked list.  This preserves resource order, which
is important for some devices.  The bulk of the series is in
the last patch, and it has more a more detailed changelog.

Rene Herman did some testing of ISA devices and reviewed
v1 of this series.  I think I addressed all his comments.
Any comments would be welcome.

This depends on some patches that are in -mm, but not yet
upstream.  In mmotm, these would probably go after
pnp-dont-sort-by-type-in-sys-resources.patch

Note that I incorporated Rene's ioport.h comment fix
(pnpacpi-fix-irq-flag-decoding-comment-fix.patch) into
this series, so you should drop that if you pick up this
series.

Change between v1 and v2:
    - rewrote 8250_pnp modem identification (first patch in series)
    - used bitmap_copy() rather than explicit loop to copy IRQ bitmaps
    - added "(optional)" note in /sys/.../options for IORESOURCE_IRQ_OPTIONAL
    - split out ISAPNP ENDDEP bug fix into a separate patch
    - restored "clear auto resources" when auto-assignment fails
    - removed 0x100 from option priority
    - allocated 12 bits for dependent option priority, 16 bits for set number
    - restored check for invalid dependent function priority
    - fixed AD1815 quirk (set OPTIONAL flag in the correct "flags" field)
    - fixed ioport.h ISA PnP comment (replaces Rene's
      pnpacpi-fix-irq-flag-decoding-comment-fix.patch)
    - rename "pnp_dependent_option()" to "pnp_new_dependent_set()"

Bjorn
-- 
