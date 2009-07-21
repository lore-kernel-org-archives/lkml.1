Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbZGUIQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbZGUIQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZGUIQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:16:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:40053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbZGUIQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:16:18 -0400
Message-ID: <4A657949.6030003@kernel.org>
Date: Tue, 21 Jul 2009 17:16:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] init: set nr_cpu_ids before setup_per_cpu_areas()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 08:16:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_cpu_ids is dependent only on cpu_possible_map and
setup_per_cpu_areas() already depends on cpu_possible_map and will use
nr_cpu_ids.  Initialize nr_cpu_ids before setting up percpu areas.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
These two patches fix sparc64 percpu on machines with holes in
cpu_possible_map.  David, can you please review and ack?

Thanks.

 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 2c5ade7..2d9d6bd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -584,8 +584,8 @@ asmlinkage void __init start_kernel(void)
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
-	setup_per_cpu_areas();
 	setup_nr_cpu_ids();
+	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */

 	build_all_zonelists();
-- 
1.6.0.2

