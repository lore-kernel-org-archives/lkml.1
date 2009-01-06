Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbZAFWc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbZAFWc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZAFWOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:17 -0500
Received: from kroah.org ([198.145.64.141]:51330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756078AbZAFWOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 53/60] avr: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:12 -0800
Message-Id: <1231279939-32728-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/avr32/mach-at32ap/clock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
index 138a00a..442f08c 100644
--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -198,7 +198,7 @@ dump_clock(struct clk *parent, struct clkinf *r)
 	unsigned	i;
 
 	/* skip clocks coupled to devices that aren't registered */
-	if (parent->dev && !parent->dev->bus_id[0] && !parent->users)
+	if (parent->dev && !dev_name(parent->dev) && !parent->users)
 		return;
 
 	/* <nest spaces> name <pad to end> */
@@ -214,7 +214,7 @@ dump_clock(struct clk *parent, struct clkinf *r)
 		parent->users ? "on" : "off",	/* NOTE: not-paranoid!! */
 		clk_get_rate(parent));
 	if (parent->dev)
-		seq_printf(r->s, ", for %s", parent->dev->bus_id);
+		seq_printf(r->s, ", for %s", dev_name(parent->dev));
 	seq_printf(r->s, "\n");
 
 	/* cost of this scan is small, but not linear... */
-- 
1.6.0.4

