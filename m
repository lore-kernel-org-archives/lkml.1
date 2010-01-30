Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320Ab0A3UWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0A3UWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858Ab0A3UWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:22:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:40698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0A3UWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:22:14 -0500
Message-ID: <4B64946D.6070507@suse.com>
Date: Sat, 30 Jan 2010 15:19:57 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] hugetlb: Fix section mismatches
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 hugetlb_sysfs_add_hstate is called by hugetlb_register_node directly
 during init and also indirectly via sysfs after init.

 This patch removes the __init tag from hugetlb_sysfs_add_hstate.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Lee.Schermerhorn@hp.com <Lee.Schermerhorn@hp.com>
---
 mm/hugetlb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1515,10 +1515,9 @@ static struct attribute_group hstate_att
 	.attrs = hstate_attrs,
 };
 
-static int __init hugetlb_sysfs_add_hstate(struct hstate *h,
-				struct kobject *parent,
-				struct kobject **hstate_kobjs,
-				struct attribute_group *hstate_attr_group)
+static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
+				    struct kobject **hstate_kobjs,
+				    struct attribute_group *hstate_attr_group)
 {
 	int retval;
 	int hi = h - hstates;
-- 
Jeff Mahoney
SuSE Labs
