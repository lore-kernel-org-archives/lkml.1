Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZKUSXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZKUSXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbZKUSXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:23:03 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65061 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbZKUSXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=X8W9X0LWxaYRGXERS3i63m6qN9wuXzfeqYlXYn1pS25l8JcjEyh2r8ArnUvpO9SfcU
         n1QXX6/x24GSQDT6Dln3gkSaBLzKvbmYmINc9Um0ZM7OPPuD+h4VfZl8q+u0OQbRiePZ
         uK0Qn7EIar6IZMJPO6ZBw41FVc3+GGCYWpTBo=
Message-ID: <4B08330E.4020300@gmail.com>
Date: Sat, 21 Nov 2009 19:35:58 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Blackfin: Fix memset in smp_send_reschedule() and -stop()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To set zeroes the sizeof the struct should be used rather
than sizeof the pointer, kzalloc does that.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/blackfin/mach-common/smp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index d98585f..d92b168 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -276,10 +276,9 @@ void smp_send_reschedule(int cpu)
 	if (cpu_is_offline(cpu))
 		return;
 
-	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
 	if (!msg)
 		return;
-	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_RESCHEDULE;
 
@@ -305,10 +304,9 @@ void smp_send_stop(void)
 	if (cpus_empty(callmap))
 		return;
 
-	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
 	if (!msg)
 		return;
-	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_CPU_STOP;
 
