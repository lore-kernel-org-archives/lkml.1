Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYJCJj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYJCJj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJCJju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:39:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13628 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJCJjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=p8RVC8T91G/f3T8jp+frBowx+rm3HMdWfdzc0fG/HVuaeh9JxTCtxPzafkjDSRj1EX
         WlobBGbihPFn4lIIOldNKzT1xLXiZjXhvfeWcjf7wO0/FPiHFmEBwHIX3dR89foHI132
         pSc/upnhjkIss7Kput8/ptPScjblDQ5gZtQJ8=
Message-ID: <48E5E862.1070504@gmail.com>
Date: Fri, 03 Oct 2008 11:39:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] Trivial fix: correct a format to avoid a warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last -tip gives this warning:

kernel/softirq.c: Dans la fonction «__do_softirq» :
kernel/softirq.c:216: attention : format «%ld» expects type «long int», but argument 2 has type «int»

This patch corrects the format type, and a small mistake in the "softirq" word.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2df0b36..19f14a3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -210,7 +210,7 @@ restart:
 			h->action(h);
 
 			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered sotfirq %ld %p"
+				printk(KERN_ERR "huh, entered softirq %d %p"
 				       "with preempt_count %08x,"
 				       " exited with %08x?\n", h - softirq_vec,
 				       h->action, prev_count, preempt_count());
