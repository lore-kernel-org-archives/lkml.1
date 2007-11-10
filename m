Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbXKJOcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbXKJOcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 09:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXKJOce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 09:32:34 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:2193 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXKJOcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 09:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uSFBAxd3AXSTW2e8pR9TE3DHfF+gAYOsA8TMS3yGTkeloDuKNsFklkbseJoUkbM3WRfAOEu5lUvNzEqDNwM060YMDZPisPEIacu87R/13TQ6eqXsLJ5DrqzL0z8E2vsz+fqOqP8VZLPUHeuifMX0DSgd7bFdqSOHaJ3IIQ2DTRw=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch] fixup genksyms usage/getopt
Date: Sat, 10 Nov 2007 09:32:20 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711100932.21024.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The usage does not mention the "-a,--arch" or "-T,--dump-types" options, so
add them.  The calls to getopt() seem to mention options that no longer exist
(some "k" and "p" thingy) but omits the "h" option which means using '-h'
actually triggers the error code path, so update those as well.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 511023b..dca5e0d 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -440,17 +440,21 @@ void error_with_pos(const char *fmt, ...)
 
 static void genksyms_usage(void)
 {
-	fputs("Usage:\n" "genksyms [-dDwqhV] > /path/to/.tmp_obj.ver\n" "\n"
+	fputs("Usage:\n" "genksyms [-adDTwqhV] > /path/to/.tmp_obj.ver\n" "\n"
 #ifdef __GNU_LIBRARY__
+	      "  -a, --arch            Select architecture\n"
 	      "  -d, --debug           Increment the debug level (repeatable)\n"
 	      "  -D, --dump            Dump expanded symbol defs (for debugging only)\n"
+	      "  -T, --dump-types file Dump expanded types into file (for debugging only)\n"
 	      "  -w, --warnings        Enable warnings\n"
 	      "  -q, --quiet           Disable warnings (default)\n"
 	      "  -h, --help            Print this message\n"
 	      "  -V, --version         Print the release version\n"
 #else				/* __GNU_LIBRARY__ */
+	      "  -a                    Select architecture\n"
 	      "  -d                    Increment the debug level (repeatable)\n"
 	      "  -D                    Dump expanded symbol defs (for debugging only)\n"
+	      "  -T file               Dump expanded types into file (for debugging only)\n"
 	      "  -w                    Enable warnings\n"
 	      "  -q                    Disable warnings (default)\n"
 	      "  -h                    Print this message\n"
@@ -477,10 +481,10 @@ int main(int argc, char **argv)
 		{0, 0, 0, 0}
 	};
 
-	while ((o = getopt_long(argc, argv, "a:dwqVDT:k:p:",
+	while ((o = getopt_long(argc, argv, "a:dwqVDT:h",
 				&long_opts[0], NULL)) != EOF)
 #else				/* __GNU_LIBRARY__ */
-	while ((o = getopt(argc, argv, "a:dwqVDT:k:p:")) != EOF)
+	while ((o = getopt(argc, argv, "a:dwqVDT:h")) != EOF)
 #endif				/* __GNU_LIBRARY__ */
 		switch (o) {
 		case 'a':
