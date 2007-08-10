Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbXHJAyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbXHJAyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbXHJAyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:54:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41602 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbXHJAyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:54:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: [PATCH 03/10] sysctl: Remove binary sysctl support where it clearly doesn't work.
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 09 Aug 2007 18:53:14 -0600
In-Reply-To: <m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 09 Aug 2007 18:51:24 -0600")
Message-ID: <m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These functions all of wrapper functions for the proc interface
that are needed for them to work correctly.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d6257ee..ccae8da 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -350,7 +350,6 @@ static struct ctl_table kern_table[] = {
 	},
 #ifdef CONFIG_PROC_SYSCTL
 	{
-		.ctl_name	= KERN_TAINTED,
 		.procname	= "tainted",
 		.data		= &tainted,
 		.maxlen		= sizeof(int),
@@ -359,7 +358,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_CAP_BSET,
 		.procname	= "cap-bound",
 		.data		= &cap_bset,
 		.maxlen		= sizeof(kernel_cap_t),
@@ -635,7 +633,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 	{
-		.ctl_name       = KERN_NMI_WATCHDOG,
 		.procname       = "nmi_watchdog",
 		.data           = &nmi_watchdog_enabled,
 		.maxlen         = sizeof (int),
@@ -818,7 +815,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 	{
-		.ctl_name	= VM_DIRTY_WB_CS,
 		.procname	= "dirty_writeback_centisecs",
 		.data		= &dirty_writeback_interval,
 		.maxlen		= sizeof(dirty_writeback_interval),
@@ -826,7 +822,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &dirty_writeback_centisecs_handler,
 	},
 	{
-		.ctl_name	= VM_DIRTY_EXPIRE_CS,
 		.procname	= "dirty_expire_centisecs",
 		.data		= &dirty_expire_interval,
 		.maxlen		= sizeof(dirty_expire_interval),
@@ -854,7 +849,6 @@ static struct ctl_table vm_table[] = {
 	},
 #ifdef CONFIG_HUGETLB_PAGE
 	 {
-		.ctl_name	= VM_HUGETLB_PAGES,
 		.procname	= "nr_hugepages",
 		.data		= &max_huge_pages,
 		.maxlen		= sizeof(unsigned long),
@@ -1079,7 +1073,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_NRFILE,
 		.procname	= "file-nr",
 		.data		= &files_stat,
 		.maxlen		= 3*sizeof(int),
-- 
1.5.1.1.181.g2de0

