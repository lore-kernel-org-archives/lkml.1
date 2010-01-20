Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626Ab0ATPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0ATPoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310Ab0ATPoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:44:16 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:48598 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab0ATPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:44:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mxLMzWuKsTJxYjfvGiO5BOFpzC5oBGYYaizc6FFnngL43smbM+Bsn0fp2pKLSK/C6F
         ZNtFFEE6+W2F4h2e176d4dd58MLWu5FMzn6oojloX4eM13N51GvQsh1oKSM4pedyU7Qr
         jYGIEvUzfVGYin3K+1GU1v/j8K5cWmnu4FjKM=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Carsten Emde <C.Emde@osadl.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/2] rt-tests: Makefile: Add NUMA compile option.
Date: Wed, 20 Jan 2010 16:36:23 +0100
Message-Id: <1264001784-11965-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264001784-11965-1-git-send-email-jkacur@redhat.com>
References: <1264001784-11965-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a NUMA compile option, and links to numa only for the tests that
need it. (Currently that is only cyclictest)

If you want to build with the NUMA feature, then define NUMA to anything.
Eg., make NUMA=1

This only adds support to the Makefile. Further patches are required
to make this work in cyclictest itself.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 Makefile |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 5db524d..4e1a7e3 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ VERSION_STRING = 0.61
 TARGETS	= cyclictest signaltest pi_stress \
 	  hwlatdetect rt-migrate-test ptsematest sigwaittest svsematest \
 	  sendme pip
-LIBS 	= -lpthread -lrt -lnuma
+LIBS 	= -lpthread -lrt
 EXTRA_LIBS ?= -ldl	# for get_cpu
 DESTDIR	?=
 prefix  ?= /usr/local
@@ -19,6 +19,11 @@ else
 	CFLAGS	+= -O0 -g
 endif
 
+ifdef NUMA
+	CFLAGS += -DNUMA
+	NUMA_LIBS = -lnuma
+endif
+
 VPATH	= src/cyclictest:
 VPATH	+= src/signaltest:
 VPATH	+= src/pi_tests:
@@ -36,7 +41,7 @@ VPATH	+= src/lib
 all: $(TARGETS)
 
 cyclictest: cyclictest.o rt-utils.o
-	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)
+	$(CC) $(CFLAGS) -o $@ $^ $(LIBS) $(NUMA_LIBS)
 
 signaltest: signaltest.o rt-utils.o
 	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)
-- 
1.6.6

