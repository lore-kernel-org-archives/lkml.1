Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYIBUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYIBUGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYIBUGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:06:09 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:35322 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYIBUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:06:08 -0400
Message-ID: <48BD9CA4.7080805@euromail.se>
Date: Tue, 02 Sep 2008 22:05:56 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: akpm@osdl.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] bcm5974-0.62: Compatibility mode reverted, BTN_TOUCH event
 added
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1Kac8c-0001ld-9I.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Kac8c-0001ld-9I 3170ceadc4f061098db891c448c15a21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mousedev driver requires the use of BTN_TOUCH events to process
ABS_X and ABS_Y events properly, which is what is needed for the
bcm5974-based apple computers to have a functional pointer out-of-the-box.
This patch adds the BTN_TOUCH events to bcm5974.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ae78bb8..cafbb71 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -248,6 +248,7 @@ static void setup_events_to_report(struct input_dev *input_dev,
 				0, cfg->y.dim, cfg->y.fuzz, 0);

 	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(BTN_TOUCH, input_dev->keybit);
 	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
 	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
@@ -296,6 +297,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)

 	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));

+	input_report_key(input, BTN_TOUCH, p > 0);
 	input_report_key(input, BTN_TOOL_FINGER, n == 1);
 	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
 	input_report_key(input, BTN_TOOL_TRIPLETAP, n > 2);
-- 
1.5.4.3

