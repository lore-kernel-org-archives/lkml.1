Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbXIXQbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbXIXQbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760569AbXIXQZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47363 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760387AbXIXQZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:51 -0400
Date: Mon, 24 Sep 2007 09:20:53 -0700
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
       Jean Delvare <khali@linux-fr.org>
Subject: [17/50] Fix debug regression in video/pwc
Message-ID: <20070924162053.GR13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-debug-regression-in-video-pwc.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

Commit 85237f202d46d55c1bffe0c5b1aa3ddc0f1dce4d introduced the
following warning:
drivers/media/video/pwc/pwc-if.c: In function "pwc_video_close":
drivers/media/video/pwc/pwc-if.c:1211: warning: "i" may be used uninitialized in this function

This is true, and can cause a broken debug message to be logged.
Here's a fix.

Fix is already in Linus' tree for 2.6.23:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7b9fbc3e30f785412a26819aa4daf0b6c27f6c53

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pwc/pwc-if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1243,7 +1243,7 @@ static int pwc_video_close(struct inode 
 				PWC_ERROR("Failed to power down camera (%d)\n", i);
 		}
 		pdev->vopen--;
-		PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", i);
+		PWC_DEBUG_OPEN("<< video_close() vopen=%d\n", pdev->vopen);
 	} else {
 		pwc_cleanup(pdev);
 		/* Free memory (don't set pdev to 0 just yet) */

-- 
