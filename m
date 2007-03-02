Return-Path: <linux-kernel-owner+w=401wt.eu-S2992487AbXCBOlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992487AbXCBOlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992491AbXCBOlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:41:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:58412 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992490AbXCBOlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:41:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=JptUwzuHUL/uxDLzb0eUvTFFsT6TJ8XF/iU0IMjzSgmFPf8bNUpRrU6/u5jYL6CR1Y1QB5q1Dx73Jzea7DaepaHXDk4HiOBYljiMS5za5owSiZX7I0bJuoCI78/6dEBxWT/3MUU7HNyFDA5x5hnHZBHp+ektJCJZ9HoYZKxL0PQ=
Date: Fri, 2 Mar 2007 14:40:07 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       abelay@novell.com, shaohua.li@intel.com, len.brown@intel.com
Subject: [-mm patch] cpu_idle: fix build break 
Message-ID: <20070302144007.GC12727@slug>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
> +git-acpi-fix-cpuidle-borkage.patch
This attached patch might be needed too, the build breaks if
!CONFIG_HOTPLUG_CPU and CONFIG_CPU_IDLE
 
  CC      drivers/cpuidle/cpuidle.o
drivers/cpuidle/cpuidle.c: In function 'cpuidle_init':
drivers/cpuidle/cpuidle.c:272: erreur: 'cpuidle_cpu_notifier' undeclared (first use in this function)
drivers/cpuidle/cpuidle.c:272: erreur: (Each undeclared identifier is reported only once
drivers/cpuidle/cpuidle.c:272: erreur: for each function it appears in.)
make[2]: *** [drivers/cpuidle/cpuidle.o] Erreur 1
make[1]: *** [drivers/cpuidle] Erreur 2
make: *** [drivers] Erreur 2

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index dc626d9..9aa1734 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -269,7 +269,9 @@ static int __init cpuidle_init(void)
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_HOTPLUG_CPU
 	register_hotcpu_notifier(&cpuidle_cpu_notifier);
+#endif
 
 	ret = sysdev_driver_register(&cpu_sysdev_class, &cpuidle_sysdev_driver);
 
