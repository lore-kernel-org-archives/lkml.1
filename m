Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYGKUdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYGKUdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbYGKUct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:32:49 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:40303 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759874AbYGKUcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:32:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIGAC9fd0hQyAvq/2dsb2JhbACBWqkh
Date: Fri, 11 Jul 2008 22:32:43 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] IPMI: return correct value from ipmi_write
Message-ID: <20080711203243.GA2687@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/char/ipmi/ipmi_watchdog.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

with these Changes:

Author: Mark Rustad <Rustad@gmail.com>
Date:   Thu Jul 10 14:27:11 2008 -0500

    [PATCH] IPMI: return correct value from ipmi_write
    
    This patch corrects the handling of write operations to the IPMI watchdog
    to work as intended by returning the number of characters actually
    processed. Without this patch, an "echo V >/dev/watchdog" enables the
    watchdog if IPMI is providing the watchdog function.
    
    Signed-off-by: Mark Rustad <MRustad@gmail.com>
    Signed-off-by: Corey Minyard <cminyard@mvista.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 1b9a870..0e6df28 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -755,9 +755,8 @@ static ssize_t ipmi_write(struct file *file,
 		rv = ipmi_heartbeat();
 		if (rv)
 			return rv;
-		return 1;
 	}
-	return 0;
+	return len;
 }
 
 static ssize_t ipmi_read(struct file *file,
