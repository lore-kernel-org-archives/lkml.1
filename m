Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZHFJdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZHFJdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZHFJdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:33:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:60075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZHFJdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:33:42 -0400
Message-ID: <4A7AA368.8080606@kernel.org>
Date: Thu, 06 Aug 2009 18:33:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 1/2 2.6.31-rc5 REPOST] init: set nr_cpu_ids before setup_per_cpu_areas()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 09:33:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_cpu_ids is dependent only on cpu_possible_map and
setup_per_cpu_areas() already depends on cpu_possible_map and will use
nr_cpu_ids.  Initialize nr_cpu_ids before setting up percpu areas.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This is repost of the following two patches with sparclinux mailing
list cc'd because I couldn't get any response from David Miller.
Nothing has changed code-wise.

 http://thread.gmane.org/gmane.linux.kernel/867587

These two patches fix boot failure on sparc64 which happens if the
cpus don't have consecutive cpu numbers.

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

