Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbYCUXFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbYCUXFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763245AbYCUWvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:15 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59390 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763788AbYCUWvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:08 -0400
Message-Id: <20080321224427.916908907@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:41 -0700
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
       Dan Williams <dan.j.williams@intel.com>,
       Shannon Nelson <shannon.nelson@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 51/76] ioat: fix ack handling, driver must ensure that ack is zero
Content-Disposition: inline; filename=ioat-fix-ack-handling-driver-must-ensure-that-ack-is-zero.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dan.j.williams@intel.com>

Initialize 'ack' to zero in case the descriptor has been recycled.

Prevents "kernel BUG at crypto/async_tx/async_xor.c:185!"

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Shannon Nelson <shannon.nelson@intel.com>
[chrisw@sous-sol.org: backport to 2.6.24.3]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/dma/ioat_dma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -726,6 +726,7 @@ static struct dma_async_tx_descriptor *i
 
 	if (new) {
 		new->len = len;
+		new->async_tx.ack = 0;
 		return &new->async_tx;
 	} else
 		return NULL;
@@ -749,6 +750,7 @@ static struct dma_async_tx_descriptor *i
 
 	if (new) {
 		new->len = len;
+		new->async_tx.ack = 0;
 		return &new->async_tx;
 	} else
 		return NULL;

-- 
