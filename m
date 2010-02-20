Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0BTOMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:12:52 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:55957 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0BTOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:12:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k4zcLM3ehkudCl7wXsFIymgy0IkNZf2igwNk+gcZpCaitaJ7Jt5848CUsYUCnuPDEH
         okh1bmZQ6LdT68dIaIcNVG0mgk8psuh2MkLH4Xg2cqG/Q3GskfbTY39iCbYsP5chXldG
         lGQNdnmtqphLccS8VC7tOzd8CNg938/k0WWLs=
Date: Sat, 20 Feb 2010 22:12:41 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] sysctl extern cleanup - mm
Message-ID: <20100220141241.GE3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move min_free_kbytes extern declaration to linux/mm.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/mm.h |    1 +
 kernel/sysctl.c    |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/mm.h	2010-02-20 14:02:25.281592573 +0800
+++ linux-2.6.32/include/linux/mm.h	2010-02-20 14:14:21.374855298 +0800
@@ -31,6 +31,7 @@ extern int page_cluster;
 
 #ifdef CONFIG_SYSCTL
 extern int sysctl_legacy_va_layout;
+extern int min_free_kbytes;
 #else
 #define sysctl_legacy_va_layout 0
 #endif
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:13:08.415694935 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:13:28.511525875 +0800
@@ -72,7 +72,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int min_free_kbytes;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
