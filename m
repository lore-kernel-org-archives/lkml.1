Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYHST2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYHST2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYHST2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:28:11 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:50563 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYHST2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:28:09 -0400
X-IronPort-AV: E=Sophos;i="4.32,236,1217808000"; 
   d="scan'208";a="67351733"
From: Roland Dreier <rdreier@cisco.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Input: evdev - Fix printk() format warning
X-Message-Flag: Warning: May contain useful information
Date: Tue, 19 Aug 2008 12:27:14 -0700
Message-ID: <aday72srejx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Aug 2008 19:27:15.0695 (UTC) FILETIME=[9669F7F0:01C90231]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    drivers/input/evdev.c: In function 'handle_eviocgbit':
    drivers/input/evdev.c:684: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/input/evdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index a92d815..70854db 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -678,7 +678,7 @@ static int handle_eviocgbit(struct input_dev *dev, unsigned int cmd, void __user
 		if (printk_timed_ratelimit(&keymax_warn_time, 10 * 1000))
 			printk(KERN_WARNING
 				"evdev.c(EVIOCGBIT): Suspicious buffer size %d, "
-				"limiting output to %d bytes. See "
+				"limiting output to %ld bytes. See "
 				"http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",
 				OLD_KEY_MAX,
 				BITS_TO_LONGS(OLD_KEY_MAX) * sizeof(long));
