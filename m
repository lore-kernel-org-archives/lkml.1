Return-Path: <linux-kernel-owner+w=401wt.eu-S1760431AbXJFDXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431AbXJFDXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 23:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXJFDW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 23:22:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:16317 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXJFDW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 23:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=XDUTkGUVn/meyfA+hf4bfcqt324LqjAyLZtF5mnecnUb0alF64cEPHKd7uLSo0X1TK1fpH5ROdY6WqRGsRSPBlfW8s+qi1ihBfddEmZlGjMcvkXY0j+p3c+bqLLaQ0aadNQlbJ8gM0jgTu1Eu+5YcNCekkXi/fq5wNwZSJCK1PA=
Date: Sat, 6 Oct 2007 11:17:13 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Andrew Morton <akpm@osdl.org>
Subject: [Patch]Documentation/watchdog/src/watchdog-simple.c: improve this
	code
Message-ID: <20071006031713.GE2436@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make some improvements for Documentation/watchdog/src/watchdog-simple.c.

CC: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 Documentation/watchdog/src/watchdog-simple.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6.23-rc9/Documentation/watchdog/src/watchdog-simple.c
===================================================================
--- linux-2.6.23-rc9.orig/Documentation/watchdog/src/watchdog-simple.c
+++ linux-2.6.23-rc9/Documentation/watchdog/src/watchdog-simple.c
@@ -3,15 +3,24 @@
 #include <unistd.h>
 #include <fcntl.h>
 
-int main(int argc, const char *argv[]) {
+int main(void) {
 	int fd = open("/dev/watchdog", O_WRONLY);
+	int ret = 0;
 	if (fd == -1) {
 		perror("watchdog");
-		exit(1);
+		exit(EXIT_FAILURE);
 	}
 	while (1) {
-		write(fd, "\0", 1);
-		fsync(fd);
+		ret = write(fd, "\0", 1);
+		if (ret != 1) {
+			ret = -1;
+			break;
+		}
+		ret = fsync(fd);
+		if (ret)
+			break;
 		sleep(10);
 	}
+	close(fd);
+	return ret;
 }
