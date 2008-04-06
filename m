Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYDFTVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYDFTVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 15:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYDFTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 15:21:26 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:61933 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbYDFTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 15:21:26 -0400
X-Belgacom-Dynamic: yes
Date: Sun, 6 Apr 2008 21:21:21 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.25 watchdog fix
Message-ID: <20080406192121.GA2663@infomag.infomag.iguana.be>
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

 drivers/watchdog/it8712f_wdt.c |    2 ++
 1 file changed, 2 insertions(+)

with these Changes:

Author: Andrew Paprocki <andrew@ishiboo.com>
Date:   Wed Apr 2 02:43:19 2008 -0400

    [WATCHDOG] it8712f_wdt Zero MSB timeout byte when disabling watchdog
    
    I noticed this while testing the latest code. I'm not sure if it is required,
    but the normal (or LSB) timeout value is set to zero, so the MSB should
    be as well to stay consistent.
    
    If the chip revision is >= 8, set MSB of the 16-bit timeout value to zero
    when disabling the watchdog in it8712f_wdt_disable().
    
    Signed-off-by: Andrew Paprocki <andrew@ishiboo.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index ca90c51..445b7e8 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -200,6 +200,8 @@ it8712f_wdt_disable(void)
 
 	superio_outb(0, WDT_CONFIG);
 	superio_outb(0, WDT_CONTROL);
+	if (revision >= 0x08)
+		superio_outb(0, WDT_TIMEOUT + 1);
 	superio_outb(0, WDT_TIMEOUT);
 
 	superio_exit();
