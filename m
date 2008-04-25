Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYDYAmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYDYAmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYDYAm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:42:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42983 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbYDYAm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:42:27 -0400
Date: Fri, 25 Apr 2008 03:41:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [2.6 patch] ia64: let NUMA select SMP
Message-ID: <20080425004139.GE18854@cs181133002.pp.htv.fi>
References: <1FE6DD409037234FAB833C420AA843EC012F9EF0@orsmsx424.amr.corp.intel.com> <20080425001652.GD18854@cs181133002.pp.htv.fi> <1FE6DD409037234FAB833C420AA843EC012F9F55@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC012F9F55@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 05:25:06PM -0700, Luck, Tony wrote:
> >>       Build fix for CONFIG_NUMA=y && CONFIG_SMP=n
> >>...
> >
> > Why is this an allowed configuration on ia64?
> 
> It shows up in allnoconfig ... probably because some
> bit of Kconfig forces NUMA=y.

allnoconfig results in CONFIG_IA64_GENERIC=y, which in turn selects NUMA.

What about the patch below instead?

> I can't imagine that it is ever a useful combination ... except to
> find places in the code where people have:
> 
> #if defined(CONFIG_SMP)
>  ...
> #else
> 
> #if defined(CONFIG_NUMA) // !!! SMP=n, NUMA code???
>   ...
> #endif
> #endif
> 
> 
> Which is what happened, and is being fixed, here.

If it isn't a useful combination such code makes no sense.

> -Tony

cu
Adrian


<--  snip  -->


CONFIG_NUMA=y, CONFIG_SMP=n isn't a useful combination, so let NUMA 
select SMP.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a94d43a82a3c5a95c82b9688e5adebca6dcb7acb diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index cd13e13..19e8167 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -387,6 +387,7 @@ config NUMA
 	bool "NUMA support"
 	depends on !IA64_HP_SIM && !FLATMEM
 	default y if IA64_SGI_SN2
+	select SMP
 	select ACPI_NUMA if ACPI
 	help
 	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory


