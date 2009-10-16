Return-Path: <linux-kernel-owner+w=401wt.eu-S1763361AbZJPA3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763361AbZJPA3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763276AbZJPA3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:29:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:9062 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614AbZJPA3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ybk5rx/aTpPkfio+I9tNIQoW/g/cq1YVuIG5pV2YZjtjicX91qdK3sTTE4uYrZTAub
         Arsojl5PejPdqXNRiCyYCHGUwAUhKDQQFyfsO9pCgPR/DnRNm29me2gUMandL0SyQoPq
         tgKk0FpXWYqCpvHyVdEW3VtIRlIotzSWZifqM=
Date: Fri, 16 Oct 2009 04:28:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: rjw@sisk.pl, htmldeveloper@gmail.com, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sysctl: fix false positives when PROC_SYSCTL=n
Message-ID: <20091016002837.GA4185@x200>
References: <bug-14408-10286@http.bugzilla.kernel.org/>
 <20091015132323.bea94a13.akpm@linux-foundation.org>
 <m1tyy0i7tm.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tyy0i7tm.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having ->procname but not ->proc_handler is valid when PROC_SYSCTL=n,
people use such combination to reduce ifdefs with non-standard handlers.

http://bugzilla.kernel.org/show_bug.cgi?id=14408

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/sysctl_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1521,7 +1521,7 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 			if (!table->ctl_name && table->strategy)
 				set_fail(&fail, table, "Strategy without ctl_name");
 #endif
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_SYSCTL
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
 #endif
