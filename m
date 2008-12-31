Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYLaJ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYLaJ0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYLaJ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:26:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbYLaJ0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:26:34 -0500
Message-ID: <495B3A92.6070900@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 17:25:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       tony.luck@intel.com
Subject: Re: [-tip tree] compile error in arch/ia64/kernel/acpi.c
References: <495B3857.90802@cn.fujitsu.com>
In-Reply-To: <495B3857.90802@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to CC Tony Luck <tony.luck@intel.com>

Li Zefan wrote:
> arch/ia64/kernel/acpi.c:205: error: conflicting types for 'total_cpus'
> include/linux/smp.h:25: error: previous declaration of 'total_cpus' was here
> 
> due to [PATCH 3/3] cpumask: add sysfs displays for configured and disabled cpu maps
> (http://lkml.org/lkml/2008/12/19/25)
> 

Is this a sane fix?

----

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] IA64: fix compile error

Remove static total_cpus in arch/ia64/kernel/acpi.c, use global
total_cpus defined in drivers/base/cpu.c.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 arch/ia64/kernel/acpi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 54ae373..0553648 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -202,7 +202,6 @@ char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
 
-static int total_cpus __initdata;
 static int available_cpus __initdata;
 struct acpi_table_madt *acpi_madt __initdata;
 static u8 has_8259;
-- 
1.5.4.rc3


