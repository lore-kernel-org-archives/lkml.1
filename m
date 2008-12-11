Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbYLKPK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbYLKPK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYLKPKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:10:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:41968 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYLKPKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:10:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Kx+ccgf+EUfJ8Safb8DbzJ5EVQkZ8vdr7m3qQurMSSaHJrCp57Dr3EP7ckEDm9zfb6
         HUX7k62idBU/RVFxV3NDPWKS7xbuXqzRUXqMmRqA0Kdk/tsNcKKohFEkqeQqgmpUGPQm
         MvXG1pDamPKRjE47320JQfy9kzkl9ejSijfjQ=
Message-ID: <49412D50.8090102@gmail.com>
Date: Thu, 11 Dec 2008 16:10:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/fastboot: fix len of func buffer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Impact: fix possible stack overrun

This is a port of a patch included in the mainline (KSYM_SYMBOL_LEN fixes).
The current func len is not large enough to contain the max symbol len, the
right size must be KSYM_SYMBOL_LEN.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/include/trace/boot.h b/include/trace/boot.h
index 6b54537..3ec58b4 100644
--- a/include/trace/boot.h
+++ b/include/trace/boot.h
@@ -9,7 +9,7 @@
  */
 struct boot_trace_call {
 	pid_t			caller;
-	char			func[KSYM_NAME_LEN];
+	char			func[KSYM_SYMBOL_LEN];
 };
 
 /*
@@ -17,7 +17,7 @@ struct boot_trace_call {
  * while it returns.
  */
 struct boot_trace_ret {
-	char			func[KSYM_NAME_LEN];
+	char			func[KSYM_SYMBOL_LEN];
 	int				result;
 	unsigned long long	duration;		/* nsecs */
 };
-- 
1.6.0.4

