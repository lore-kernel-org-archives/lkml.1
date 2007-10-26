Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXJZISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXJZISW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 04:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXJZISI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 04:18:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35022 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbXJZISF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 04:18:05 -0400
Date: Fri, 26 Oct 2007 10:17:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] raid6: generate raid6tables.c with proper style
Message-ID: <20071026081752.GA1232@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: raid6: generate raid6tables.c with proper style
From: Ingo Molnar <mingo@elte.hu>

nitpicking from the coding style police: generate a raid6tables.c that 
does not show up in my editor all red ;-)

this also improves the code quality metric of drivers/md/ by
a factor of 10:

                             errors   lines of code   errors/KLOC
 drivers/md/  [old]            9349           45543         205.2
 drivers/md/  [new]            1062           45551          23.3

while humans are not likely to read that file, lets just do this to make 
life easier for automated quality checking ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/md/mktables.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux/drivers/md/mktables.c
===================================================================
--- linux.orig/drivers/md/mktables.c
+++ linux/drivers/md/mktables.c
@@ -69,7 +69,9 @@ int main(int argc, char *argv[])
     for ( j = 0 ; j < 256 ; j += 8 ) {
       printf("\t\t");
       for ( k = 0 ; k < 8 ; k++ ) {
-	printf("0x%02x, ", gfmul(i,j+k));
+        if (k)
+	  printf(" ");
+	printf("0x%02x,", gfmul(i,j+k));
       }
       printf("\n");
     }
@@ -86,7 +88,9 @@ int main(int argc, char *argv[])
     printf("\t");
     for ( j = 0 ; j < 8 ; j++ ) {
       exptbl[i+j] = v;
-      printf("0x%02x, ", v);
+      if (j)
+	      printf(" ");
+      printf("0x%02x,", v);
       v = gfmul(v,2);
       if ( v == 1 ) v = 0;	/* For entry 255, not a real entry */
     }
@@ -102,7 +106,9 @@ int main(int argc, char *argv[])
     printf("\t");
     for ( j = 0 ; j < 8 ; j++ ) {
       invtbl[i+j] = v = gfpow(i+j,254);
-      printf("0x%02x, ", v);
+      if (j)
+	      printf(" ");
+      printf("0x%02x,", v);
     }
     printf("\n");
   }
@@ -115,7 +121,9 @@ int main(int argc, char *argv[])
   for ( i = 0 ; i < 256 ; i += 8 ) {
     printf("\t");
     for ( j = 0 ; j < 8 ; j++ ) {
-      printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
+      if (j)
+	      printf(" ");
+      printf("0x%02x,", invtbl[exptbl[i+j]^1]);
     }
     printf("\n");
   }
