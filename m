Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYKUTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYKUTOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYKUTOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:14:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54357 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYKUTOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:14:07 -0500
Date: Fri, 21 Nov 2008 12:14:14 +0100
From: Pavel Machek <pavel@suse.cz>
To: rpurdie@rpsys.net, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: backlight: catch invalid input
Message-ID: <20081121111414.GA1455@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, echo > brightness turns brightness to zero due to
insufficient checking. Add a test to catch that.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index fab0bc8..5c2e23d 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -86,6 +86,8 @@ static ssize_t backlight_store_power(str
 	int power = simple_strtoul(buf, &endp, 0);
 	size_t size = endp - buf;
 
+	if (!size)
+		return -EINVAL;
 	if (*endp && isspace(*endp))
 		size++;
 	if (size != count)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
