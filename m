Return-Path: <linux-kernel-owner+w=401wt.eu-S1751238AbZFINrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbZFINrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZFINqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:54 -0400
Received: from mx1.emlix.com ([193.175.82.87]:45764 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZFINqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:53 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oskar Schirmer <os@emlix.com>
Subject: [PATCH 2/8] imx: serial: fix one bit field type
Date: Tue,  9 Jun 2009 15:46:45 +0200
Message-Id: <1244555211-15618-3-git-send-email-os@emlix.com>
In-Reply-To: <1244555211-15618-2-git-send-email-os@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
 <1244555211-15618-2-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Glöckner <dg@emlix.com>

"have_rtscts" is assigned 1, while it is declared
int:1, two's complement, which can hold 0 and -1
only. The code works, as the upper bits are cut
off, and tests are done against 0 only.

Nonetheless, correctly declaring the bit field
as unsigned int:1 renders the code more robust.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/serial/imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 424f679..5ee325f 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -211,7 +211,7 @@ struct imx_port {
 	struct timer_list	timer;
 	unsigned int		old_status;
 	int			txirq,rxirq,rtsirq;
-	int			have_rtscts:1;
+	unsigned int		have_rtscts:1;
 	struct clk		*clk;
 };
 
-- 
1.5.3.7

