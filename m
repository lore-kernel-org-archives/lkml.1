Return-Path: <linux-kernel-owner+w=401wt.eu-S936156AbXHJOia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936156AbXHJOia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760640AbXHJOiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:38:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53809 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760110AbXHJOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:38:17 -0400
Date: Fri, 10 Aug 2007 16:38:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] kernel/sysctl_check.c must #include <linux/string.h>
Message-ID: <20070810143802.GG18938@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc1-mm2:
>...
> +sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
> +sysctl-factor-out-sysctl_data.patch
> +sysctl-error-on-bad-sysctl-tables.patch
> +sysctl-update-sysctl_check_table.patch
> +sysct-mqueue-remove-the-binary-sysctl-numbers.patch
> +sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
> +sysctl-fix-neighbour-table-sysctls.patch
> +sysctl-ipv6-route-flushing-kill-binary-path.patch
> +sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
> +sysctl-x86_64-remove-unnecessary-binary-paths.patch
> +sysctl-remove-broken-cdrom-binary-sysctls.patch
> +sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
> +sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
> 
>  sysctl cleanups
>...

This patch fixes the following compile error:

<--  snip  -->

...
  CC      kernel/sysctl_check.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c: In function 'sysctl_binary_lookup':
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c:1303: error: implicit declaration of function 'strcmp'
make[2]: *** [kernel/sysctl_check.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -3,6 +3,7 @@
 #include "../arch/s390/appldata/appldata.h"
 #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
 #include <linux/sunrpc/debug.h>
+#include <linux/string.h>
 #include <net/ip_vs.h>
 
 struct trans_ctl_table {

