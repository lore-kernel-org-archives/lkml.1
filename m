Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZKUPR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZKUPR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZKUPRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:17:24 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39186 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbZKUPRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:17:23 -0500
Message-ID: <4B08013B.90403@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:03:23 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/8] cxacru: return an empty value for modulation if there
 is no connection
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there is no connection, return an empty string
instead of "0" for the connection modulation.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 Documentation/networking/cxacru.txt |    1 +
 drivers/usb/atm/cxacru.c            |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/cxacru.txt b/Documentation/networking/cxacru.txt
index b074681..3532cee 100644
--- a/Documentation/networking/cxacru.txt
+++ b/Documentation/networking/cxacru.txt
@@ -61,6 +61,7 @@ several sysfs attribute files for retrieving device statistics:
 * mac_address
 
 * modulation
+	"" (when not connected)
 	"ANSI T1.413"
 	"ITU-T G.992.1 (G.DMT)"
 	"ITU-T G.992.2 (G.LITE)"
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 56802d2..4a26a6c 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -267,12 +267,12 @@ static ssize_t cxacru_sysfs_showattr_LINE(u32 value, char *buf)
 static ssize_t cxacru_sysfs_showattr_MODU(u32 value, char *buf)
 {
 	static char *str[] = {
-			NULL,
+			"",
 			"ANSI T1.413",
 			"ITU-T G.992.1 (G.DMT)",
 			"ITU-T G.992.2 (G.LITE)"
 	};
-	if (unlikely(value >= ARRAY_SIZE(str) || str[value] == NULL))
+	if (unlikely(value >= ARRAY_SIZE(str)))
 		return snprintf(buf, PAGE_SIZE, "%u\n", value);
 	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);
 }
-- 
1.6.3.3

-- 
Simon Arlott

