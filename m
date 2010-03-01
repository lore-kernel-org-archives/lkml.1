Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0CAXZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:25:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:58500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0CAXZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:25:36 -0500
Date: Mon, 1 Mar 2010 23:21:39 GMT
From: "tip-bot for Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, venkatesh.pallipadi@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, venkatesh.pallipadi@intel.com, tglx@linutronix.de
In-Reply-To: <20100224214355.GA16431@linux-os.sc.intel.com>
References: <20100224214355.GA16431@linux-os.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86, pat: In rbt_memtype_check_insert(), update new->type only if valid
Message-ID: <tip-4daa2a8093ecd1148270a1fc64e99f072b8c2901@git.kernel.org>
Git-Commit-ID: 4daa2a8093ecd1148270a1fc64e99f072b8c2901
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 23:21:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4daa2a8093ecd1148270a1fc64e99f072b8c2901
Gitweb:     http://git.kernel.org/tip/4daa2a8093ecd1148270a1fc64e99f072b8c2901
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Wed, 24 Feb 2010 13:43:55 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 14:28:48 -0800

x86, pat: In rbt_memtype_check_insert(), update new->type only if valid

new->type should only change when there is a valid ret_type. Otherwise
the requested type and return type should be same.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20100224214355.GA16431@linux-os.sc.intel.com>
Tested-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/pat_rbtree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index 9063f40..07de4cb 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -223,7 +223,9 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 						new->type, ret_type);
 
 	if (!err) {
-		new->type = *ret_type;
+		if (ret_type)
+			new->type = *ret_type;
+
 		memtype_rb_insert(&memtype_rbroot, new);
 	}
 	return err;
