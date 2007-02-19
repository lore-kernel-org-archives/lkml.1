Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbXBSUSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbXBSUSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbXBSUSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:18:40 -0500
Received: from outmx008.isp.belgacom.be ([195.238.5.235]:56081 "EHLO
	outmx008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbXBSUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:18:39 -0500
Date: Mon, 19 Feb 2007 21:19:00 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [WATCHDOG] machzwd-warning-fix
Message-ID: <20070219201900.GA2512@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/char/watchdog/machzwd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Sat Feb 17 03:13:07 2007 -0800

    [WATCHDOG] machzwd warning fix
    From: Andrew Morton <akpm@linux-foundation.org>
    
    drivers/char/watchdog/machzwd.c: In function 'zf_ioctl':
    drivers/char/watchdog/machzwd.c:327: warning: passing argument 1 of 'zf_ping' makes integer from pointer without a cast
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index 81fb3de..4a328ba 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -324,7 +324,7 @@ static int zf_ioctl(struct inode *inode,
 			return put_user(0, p);
 
 		case WDIOC_KEEPALIVE:
-			zf_ping(NULL);
+			zf_ping(0);
 			break;
 
 		default:
