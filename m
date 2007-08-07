Return-Path: <linux-kernel-owner+w=401wt.eu-S936429AbXHGVLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936429AbXHGVLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935750AbXHGUxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:53:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59534 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935821AbXHGUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:53:52 -0400
Date: Tue, 7 Aug 2007 13:47:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kristian H?gsberg <krh@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [2.6.22.2 review 47/84] fw-ohci: fix "scheduling while atomic"
Message-ID: <20070807204715.GW23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fw-ohci-fix-scheduling-while-atomic.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stefan Richter <stefanr@s5r6.in-berlin.de>

context_stop is called by bus_reset_tasklet, among else.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=8735.
Same as commit b980f5a224f3df6c884dbf5ae48797ce352ba139.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-ohci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -586,7 +586,7 @@ static void context_stop(struct context 
 			break;
 
 		fw_notify("context_stop: still active (0x%08x)\n", reg);
-		msleep(1);
+		mdelay(1);
 	}
 }
 

-- 
