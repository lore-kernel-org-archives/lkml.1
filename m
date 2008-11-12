Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYKLAnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYKLAnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYKLA1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:27:05 -0500
Received: from kroah.org ([198.145.64.141]:42654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753545AbYKLA1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:27:01 -0500
Date: Tue, 11 Nov 2008 16:24:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 45/49] mmc: increase SD write timeout for crappy cards
Message-ID: <20081112002429.GT10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mmc-increase-sd-write-timeout-for-crappy-cards.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pierre Ossman <drzeus@drzeus.cx>

commit 493890e75d98810a3470b4aae23be628ee5e9667 upstream.

It seems that some cards are slightly out of spec and occasionally
will not be able to complete a write in the alloted 250 ms [1].
Incease the timeout slightly to allow even these cards to function
properly.

[1] http://lkml.org/lkml/2008/9/23/390

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -280,7 +280,11 @@ void mmc_set_data_timeout(struct mmc_dat
 			(card->host->ios.clock / 1000);
 
 		if (data->flags & MMC_DATA_WRITE)
-			limit_us = 250000;
+			/*
+			 * The limit is really 250 ms, but that is
+			 * insufficient for some crappy cards.
+			 */
+			limit_us = 300000;
 		else
 			limit_us = 100000;
 

-- 
