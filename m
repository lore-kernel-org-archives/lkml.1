Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZKJPKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZKJPKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbZKJPKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:10:43 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:22423 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707AbZKJPKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:10:42 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJ8Q+UpR9dTd/2dsb2JhbADeWAqENASBaA
Date: Tue, 10 Nov 2009 16:10:41 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Denis Turischev <denis@compulab.co.il>
Subject: [WATCHDOG] v2.6.32-rc6 fix
Message-ID: <20091110151041.GW19336@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/sbc_fitpc2_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Denis Turischev <denis@compulab.co.il>
Date:   Thu Nov 5 13:32:40 2009 +0200

    [WATCHDOG] SBC-FITPC2 watchdog driver registration fix
    
    This patch fixes device registration process.
    
    Signed-off-by: Denis Turischev <denis@compulab.co.il>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 852ca19..91430a8 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -227,7 +227,7 @@ static int __init fitpc2_wdt_init(void)
 	}
 
 	err = misc_register(&fitpc2_wdt_miscdev);
-	if (!err) {
+	if (err) {
 		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, err);
 		goto err_margin;
