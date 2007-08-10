Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbXHJBE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbXHJBE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765262AbXHJBES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:04:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44954 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbXHJBER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:04:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@sw.ru>
Subject: [PATCH 10/10] sysctl: Remove the binary interface for aio-nr, aio-max-nr, acpi_video_flags
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mc8at5.fsf_-_@ebiederm.dsl.xmission.com>
	<m1myx08arh.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ir7o8ap1.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejic8an8.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 09 Aug 2007 19:03:23 -0600
In-Reply-To: <m1ejic8an8.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 09 Aug 2007 19:02:19 -0600")
Message-ID: <m1abt08alg.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


aio-nr, aio-max-nr, acpi_video_flags are unsigned long values
which sysctl does not handle properly with a 64bit kernel
and a 32bit user space.

Since no one is likely to be using the binary sysctl values
and the ascii interface still works, this patch just removes
support for the binary sysctl interface from the kernel.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ccae8da..03759ab 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -688,7 +688,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
 	{
-		.ctl_name	= KERN_ACPI_VIDEO_FLAGS,
 		.procname	= "acpi_video_flags",
 		.data		= &acpi_realmode_flags,
 		.maxlen		= sizeof (unsigned long),
@@ -1148,7 +1147,6 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &two,
 	},
 	{
-		.ctl_name	= FS_AIO_NR,
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
 		.maxlen		= sizeof(aio_nr),
@@ -1156,7 +1154,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
 	{
-		.ctl_name	= FS_AIO_MAX_NR,
 		.procname	= "aio-max-nr",
 		.data		= &aio_max_nr,
 		.maxlen		= sizeof(aio_max_nr),
-- 
1.5.1.1.181.g2de0

