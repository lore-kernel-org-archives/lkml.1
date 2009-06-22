Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZFVJIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZFVJIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZFVJIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:08:36 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:55162 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbZFVJIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:08:35 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: cleanup hpfall example code (checkpatch)
Date: Mon, 22 Jun 2009 11:08:36 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <trivial@kernel.org>, Pavel Machek <pavel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221108.37471.elendil@planet.nl>
X-OriginalArrivalTime: 22 Jun 2009 09:08:38.0217 (UTC) FILETIME=[077D8B90:01C9F319]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes hpfall.c conform to kernel coding style.

I have not fixed the C99 // comments on two lines as they
help indicate that those are not actually comments but
incomplete code.

Before:
 total: 10 errors, 6 warnings, 101 lines checked
After:
 total: 2 errors, 0 warnings, 99 lines checked

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index bbea1cc..d2f6711 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -57,45 +57,43 @@ void ignore_me(void)
 {
 	protect(0);
 	set_led(0);
-
 }
 
-int main(int argc, char* argv[])
+int main(int argc, char *argv[])
 {
-       int fd, ret;
+	int fd, ret;
 
-       fd = open("/dev/freefall", O_RDONLY);
-       if (fd < 0) {
-               perror("open");
-               return EXIT_FAILURE;
-       }
+	fd = open("/dev/freefall", O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return EXIT_FAILURE;
+	}
 
 	signal(SIGALRM, ignore_me);
 
-       for (;;) {
-	       unsigned char count;
-
-               ret = read(fd, &count, sizeof(count));
-	       alarm(0);
-	       if ((ret == -1) && (errno == EINTR)) {
-		       /* Alarm expired, time to unpark the heads */
-		       continue;
-	       }
-
-               if (ret != sizeof(count)) {
-                       perror("read");
-                       break;
-               }
-
-	       protect(21);
-	       set_led(1);
-	       if (1 || on_ac() || lid_open()) {
-		       alarm(2);
-	       } else {
-		       alarm(20);
-	       }
-       }
+	for (;;) {
+		unsigned char count;
+
+		ret = read(fd, &count, sizeof(count));
+		alarm(0);
+		if ((ret == -1) && (errno == EINTR)) {
+			/* Alarm expired, time to unpark the heads */
+			continue;
+		}
+
+		if (ret != sizeof(count)) {
+			perror("read");
+			break;
+		}
+
+		protect(21);
+		set_led(1);
+		if (1 || on_ac() || lid_open())
+			alarm(2);
+		else
+			alarm(20);
+	}
 
-       close(fd);
-       return EXIT_SUCCESS;
+	close(fd);
+	return EXIT_SUCCESS;
 }
