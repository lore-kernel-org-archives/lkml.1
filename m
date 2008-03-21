Return-Path: <linux-kernel-owner+w=401wt.eu-S1765615AbYCUXJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765615AbYCUXJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbYCUWwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:13 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41290 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbYCUWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:09 -0400
Message-Id: <20080321224430.459425233@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 53/76] VT notifier fix for VT switch
Content-Disposition: inline; filename=vt-notifier-fix-for-vt-switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

VT notifier callbacks need to be aware of console switches.  This is already
partially done from console_callback(), but at that time fg_console, cursor
positions, etc.  are not yet updated and hence screen readers fetch the old
values.

This adds an update notify after all of the values are updated in
redraw_screen(vc, 1).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -702,6 +702,7 @@ void redraw_screen(struct vc_data *vc, i
 	if (is_switch) {
 		set_leds();
 		compute_shiftstate();
+		notify_update(vc);
 	}
 }
 

-- 
