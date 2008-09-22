Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYIVJc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYIVJc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYIVJcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:32:51 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57021 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYIVJcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GiAdj2sDSgWfNWLkkplE3A5paqzxmOpIs1iquMHOKD5gGH4rU7N2tSDDYj/OhFS4vM
         GxjWHYLso0RAb2qIKB7LoXdmZNfWwWIo6yKiojRTb1NA38hX7MLCKMQyZZm533WIgWSk
         6V8t8u0a6X1LDt3W4/pYsc/dUhIDJkYnv8PVw=
Message-ID: <a63d67fe0809220232w1679f074i33629bf37a47f579@mail.gmail.com>
Date: Mon, 22 Sep 2008 12:32:49 +0300
From: "Dan Carpenter" <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] possible NULL deref in alloc_posix_timer()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by static checker (http://repo.or.cz/w/smatch.git).
Compile tested.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- kernel/posix-timers.c.orig  2008-08-29 01:52:02.000000000 +0300
+++ kernel/posix-timers.c       2008-09-20 21:54:19.000000000 +0300
@@ -441,7 +441,7 @@
                return tmr;
        if (unlikely(!(tmr->sigq = sigqueue_alloc()))) {
                kmem_cache_free(posix_timers_cache, tmr);
-               tmr = NULL;
+               return NULL;
        }
        memset(&tmr->sigq->info, 0, sizeof(siginfo_t));
        return tmr;
