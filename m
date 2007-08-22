Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbXHVI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbXHVI7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXHVIxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:00 -0400
Received: from 1wt.eu ([62.212.114.60]:1972 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbXHVIw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:59 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084004.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:05 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 21/58] CPU online file permission
Content-Disposition: inline; filename=0021-CPU-online-file-permission.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a reason why the "online" file in the subdirectories for the CPUs
in /sys/devices/system isn't world-readable?  I cannot imagine it to be
security relevant especially now that a getcpu() syscall can be used to
determine what CPUa thread runs on.

The file is useful to correctly implement the sysconf() function to return
the number of online CPUs.  In the presence of hotplug we currently cannot
provide this information.  The patch below should to it.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/base/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 7fd095e..be31b43 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -53,7 +53,7 @@ static ssize_t store_online(struct sys_device *dev, const char *buf,
 		ret = count;
 	return ret;
 }
-static SYSDEV_ATTR(online, 0600, show_online, store_online);
+static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
 static void __devinit register_cpu_control(struct cpu *cpu)
 {
-- 
1.5.2.5

-- 
