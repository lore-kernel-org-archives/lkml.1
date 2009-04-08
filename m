Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbZDHUSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbZDHUSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZDHUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:17:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:15998 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZDHUR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=jZeKQy0XSfJg87FKzrNkKP3utQVnJ2Z84gQ/v0xTOjw1ncPAo9eXoICMQEcWW5hcyl
         LbYAxiv0mrdSfpayN8mxG6oP2HRkvK9lmKGxF7mNdjj6Kot+veeJZn4wCQzivEe6MlAt
         txy05w9J2JUlIUfijr1BPW3xuoEkXlY3bFO3w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] kill-the-BKL: fix missing #include smp_lock.h
Date: Wed,  8 Apr 2009 22:17:53 +0200
Message-Id: <1239221873-18628-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a build error

Latest tip:kill-the-BKL tree triggers this build error:

  CC      kernel/hung_task.o
kernel/hung_task.c: In function ‘check_hung_task’:
kernel/hung_task.c:103: erreur: implicit declaration of function ‘debug_print_bkl’
make[1]: *** [kernel/hung_task.o] Erreur 1
make: *** [kernel/hung_task.o] Erreur 2

hung_task.c forget to include smp_lock.h

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hung_task.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index ea199d5..c790a59 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -13,6 +13,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/lockdep.h>
+#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 
-- 
1.6.1

