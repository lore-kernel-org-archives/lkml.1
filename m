Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZCAHNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZCAHNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 02:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZCAHNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 02:13:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:53029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbZCAHNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 02:13:44 -0500
Message-ID: <49AA357C.3070006@kernel.org>
Date: Sun, 01 Mar 2009 16:13:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH tj-percpu 1/3] percpu: kill compile warning in pcpu_populate_chunk()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Mar 2009 07:13:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove compile warning

Mark local variable map_end in pcpu_populate_chunk() with
uninitialized_var().  The variable is always used in tandem with
map_start and guaranteed to be initialized before use but gcc doesn't
understand that.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
This the first of three misc fix patches for #tj-percpu.  Patches are
also available in the tj-percpu git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Thanks.

 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 5954e7a..3d0f545 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -639,7 +639,7 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	int page_start = PFN_DOWN(off);
 	int page_end = PFN_UP(off + size);
 	int map_start = -1;
-	int map_end;
+	int uninitialized_var(map_end);
 	unsigned int cpu;
 	int i;
 
-- 
1.6.0.2

