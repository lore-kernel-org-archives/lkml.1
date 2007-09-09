Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbXIITDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbXIITDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 15:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758768AbXIITCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 15:02:55 -0400
Received: from web52007.mail.re2.yahoo.com ([206.190.48.56]:44952 "HELO
	web52007.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758724AbXIITCy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 15:02:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=IRHlqHp4MkCq4pND+iRx7sTEBfYWrCepicZocRjmtVRvil3SPEdBMbu1uH52uKBfEcS9QkAe/R3FL4nDUf24hRPCHXyNVrS85L4cCweanS1xFLVZJ38AGlCEABgdCDZ2GLd9jKc4LIvc+zeyeVKjW3n0oE/QjovbU9u+GxmNYX0=;
X-YMail-OSG: a0ZudycVM1n23istXpopzxZxEmxZSRADgXU94_oyd1Kf6AQvP2nZztyDsmZaioq.490bUpXTflOo9OSB.TJH2BtEbwHmOTMKaX.bbV915h9aeHUbiV0pWZaBBclxBg--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Sun, 9 Sep 2007 12:02:53 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] [Bug 8998] Mutex documentation is unclear about software interrupts, tasklets and timers in Linux 2.6.23-rc
To: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <643744.22696.qm@web52007.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -uprN linux-2.6.23/Documentation/mutex-design.txt linux-2.6.23-patched/Documentation/mutex-design.txt
--- linux-2.6.23/Documentation/mutex-design.txt    2007-09-09 21:47:10.545275000 +0300
+++ linux-2.6.23-patched/Documentation/mutex-design.txt    2007-09-09 21:48:17.935493000 +0300
@@ -90,7 +90,8 @@ of advantages of mutexes:
    * - task may not exit with mutex held
    * - memory areas where held locks reside must not be freed
    * - held mutexes must not be reinitialized
-   * - mutexes may not be used in irq contexts
+   * - mutexes may not be used in hardware or software interrupt
+   *   contexts such as tasklets and timers
 
    furthermore, there are also convenience features in the debugging
    code:
diff -uprN linux-2.6.23/include/linux/mutex.h linux-2.6.23-patched/include/linux/mutex.h
--- linux-2.6.23/include/linux/mutex.h    2007-09-09 21:49:04.531143500 +0300
+++ linux-2.6.23-patched/include/linux/mutex.h    2007-09-09 21:49:44.946525500 +0300
@@ -29,7 +29,8 @@
  * - task may not exit with mutex held
  * - memory areas where held locks reside must not be freed
  * - held mutexes must not be reinitialized
- * - mutexes may not be used in irq contexts
+ * - mutexes may not be used in hardware or software interrupt
+ *   contexts such as tasklets and timers
  *
  * These semantics are fully enforced when DEBUG_MUTEXES is
  * enabled. Furthermore, besides enforcing the above rules, the mutex



Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>




      __________________________________  
Kennt man wirklich jeden über 3 Ecken? Die Antworten gibt's bei Yahoo! Clever. www.yahoo.de/clever
