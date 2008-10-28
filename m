Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYJ1JYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYJ1JYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJ1JYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:24:31 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:36725 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYJ1JYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fWFDZc45qhOQYz5nf84krX0JNzvsdu75i4e4p+iPAPDLV1XTJ5q57ZZ7/yHRA9Yzml
         H0L8VAKI3Doa1AuTD0N2i/sUerAT53cBY8rhTRcLXamv3BVM1pK+QNbAsIdCjU+3Hh6I
         1CaQeAXU6t5ra+r0C6zbhmERvn8re2oFKb12c=
Message-ID: <21d34cad0810280224t7382c419k95ff89750caef6b2@mail.gmail.com>
Date: Tue, 28 Oct 2008 17:24:28 +0800
From: "qinghuang feng" <qhfeng.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] LOCKDEP: minor fix for debug_show_all_locks()
Cc: sniper <s3c24xx@gmail.com>, mingo@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081028082920.GK15734@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9bd6b5360810271303teb198dejde3116f69cfffd46@mail.gmail.com>
	 <20081028082920.GK15734@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we failed to get tasklist_lock eventually (count equals 0),
we should only print " ignoring it.\n", and not print
" locked it.\n" needlessly.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index dbda475..6533fd9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3417,8 +3417,7 @@ retry:
 		}
 		printk(" ignoring it.\n");
 		unlock = 0;
-	}
-	if (count != 10)
+	} else if (count != 10)
 		printk(" locked it.\n");

 	do_each_thread(g, p) {
