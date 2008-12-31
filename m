Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYLaJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYLaJAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYLaJAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:00:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58325 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYLaJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:00:04 -0500
Message-ID: <495B345A.5080302@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:59:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] cpumask: fix compile error in kernel/irq/proc.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Fix compile error

Pass correct argument type to is_affinity_mask_valid().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/irq/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 2abd3a7..5a5ac60 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -111,7 +111,7 @@ static ssize_t default_affinity_write(struct file *file,
 	if (err)
 		goto out;
 
-	if (!is_affinity_mask_valid(new_value)) {
+	if (!is_affinity_mask_valid(*new_value)) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.5.4.rc3

