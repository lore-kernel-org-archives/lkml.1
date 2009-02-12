Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbZBLNFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbZBLNFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 08:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbZBLNFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 08:05:31 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:43444 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbZBLNFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:05:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=aFTMaxl5u+jCEqZLPvYD/hGQYPHhNsssza2w1PPRxBnEZ8M3L7F0mTGB/TWUhCwpR3
         CHWA0QaKBFmxtj/Yjm1djDxtSmO4MXcQCAceKjgyLIIs7NAtxiJc0ydA/h9edHyL/eow
         Lw3/LAGrmJ2IL7DgHXH5Bn/sEkx/RfJzNV6B0=
Message-ID: <49941E98.8050402@gmail.com>
Date: Thu, 12 Feb 2009 14:05:28 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] frv: duplicate output_buffer of E03
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of an error, output_buffer gets an E0X value. E03 was set in two
different error conditions while E02 was missing, this occurred in two sections.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index 7ca8a6b..4411c24 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -1880,7 +1880,7 @@ void gdbstub(int sigval)
 			}
 
 			if (temp >= 5) {
-				gdbstub_strcpy(output_buffer,"E03");
+				gdbstub_strcpy(output_buffer,"E02");
 				break;
 			}
 
@@ -1908,7 +1908,7 @@ void gdbstub(int sigval)
 			}
 
 			if (temp >= 5) {
-				gdbstub_strcpy(output_buffer,"E03");
+				gdbstub_strcpy(output_buffer,"E02");
 				break;
 			}
 
