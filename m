Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbZFNPdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbZFNPdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZFNPdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:33:04 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:30047 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZFNPdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kVdk2xVsXOsOVYK9oyHZNIfJsirkN8RUVWQ4RMWteQPXhxj7uudslnybuW+5MN860h
         O5cSYg0jotj38ZVPgRFFzsAH/SzET43U/8UHsA7qWrSdcxCURmczTDy2HFwYqXd/JT9c
         aGmCt/tiuz3dPA8Mf/8F6pqrIZDTD+IAw4sH8=
MIME-Version: 1.0
Date: Sun, 14 Jun 2009 23:33:03 +0800
Message-ID: <2674af740906140833h608ffdefj746096af3a559876@mail.gmail.com>
Subject: [PATCH] setup_affinity return 1 with failure
From: Yong Zhang <yong.zhang0@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_affinity should return 1 when failure, then make checking in
irq_select_affinity_usr() reasonable.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index aaf5c9d..8d2a992 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -137,7 +137,7 @@ int irq_set_affinity(unsigned int irq, const
struct cpumask *cpumask)
 static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	if (!irq_can_set_affinity(irq))
-		return 0;
+		return 1;

 	/*
 	 * Preserve an userspace affinity setup, but make sure that
-- 
1.6.0.4
