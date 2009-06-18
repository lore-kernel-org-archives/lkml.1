Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbZFROhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbZFROhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZFROhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:37:42 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:37601 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZFROhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:37:41 -0400
Date: Thu, 18 Jun 2009 18:37:38 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
To: linux-kernel@vger.kernel.org
Cc: wd@denx.de
Subject: [PATCH] Fix userland build failure in linux/if_tunnel.h
Message-ID: <20090618183738.662f7ef1@emcraft.com>
Organization: Emcraft Systems
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

The last commit to linux/if_tunnel.h broke the busybox
application build.
When linking the final image linker complains:
networking/libiproute/lib.a(iptunnel.o): In function `parse_args':
/work/psl/e/arm-aa/target_rpms/busybox/BUILD/busybox-1.7.1/networking/libiproute/iptunnel.c:189:
undefined reference to
`__cpu_to_be16' /work/psl/e/arm-aa/target_rpms/busybox/BUILD/busybox-1.7.1/networking/libiproute/iptunnel.c:190:
undefined reference to
`__cpu_to_be16' /work/psl/e/arm-aa/target_rpms/busybox/BUILD/busybox-1.7.1/networking/libiproute/iptunnel.c:202:
undefined reference to `__cpu_to_be16'
...

Please review the following patch, which fixes the build error.

Subject: [PATCH] The busybox application build failed in linking complaining to unresolved
 __cpu_to_be16 (ARM target). This patch fixes this.

Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
---
 include/linux/if_tunnel.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/if_tunnel.h b/include/linux/if_tunnel.h
index 5a9aae4..137130b 100644
--- a/include/linux/if_tunnel.h
+++ b/include/linux/if_tunnel.h
@@ -2,6 +2,7 @@
 #define _IF_TUNNEL_H_
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 #ifdef __KERNEL__
 #include <linux/ip.h>
-- 
1.6.0.6

