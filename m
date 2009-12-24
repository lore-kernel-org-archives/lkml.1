Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZLXDFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZLXDFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 22:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZLXDFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 22:05:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59331 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZLXDFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 22:05:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bR1DFU1bvbcKtELyuc0oiLm8/ob64feEEWLjzIlcH+V416qA8YqJBKFiGYPUQSBQ8q
         fZjPlX4lyqL4ZnXbSPQT7akFs/uLpmE01kDx0bhyahuBaDxyKoqFtFWnJT+U9VFI/pm8
         pZCMA/B74H1bWdEtCKGyAG+DDgyX4gLLLeDcs=
MIME-Version: 1.0
Date: Thu, 24 Dec 2009 09:05:48 +0600
Message-ID: <b9df5fa10912231905t69502923gee5aaf1c1b2efa6a@mail.gmail.com>
Subject: [PATCH] hugetlb: Fix section mismatch warning in hugetlb.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    The patch titled hugetlb-add-per-node-hstate-attributes.patch introduces
 the following section mismatch warning, due to a reference form non-init
function hugetlb_register_node to a init function hugetlb_sysfs_add_hstate.

LD      mm/built-in.o
WARNING: mm/built-in.o(.text+0x5396d): Section mismatch in reference
from the function hugetlb_register_node() to the function
.init.text:hugetlb_sysfs_add_hstate()
The function hugetlb_register_node() references
the function __init hugetlb_sysfs_add_hstate().
This is often because hugetlb_register_node lacks a __init
annotation or the annotation of hugetlb_sysfs_add_hstate is wrong.

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/mm/hugetlb.c	2009-12-18 15:52:35.000000000 +0600
+++ rakib/mm/hugetlb.c	2009-12-23 20:37:16.000000000 +0600
@@ -1515,7 +1515,7 @@ static struct attribute_group hstate_att
 	.attrs = hstate_attrs,
 };

-static int __init hugetlb_sysfs_add_hstate(struct hstate *h,
+static int hugetlb_sysfs_add_hstate(struct hstate *h,
 				struct kobject *parent,
 				struct kobject **hstate_kobjs,
 				struct attribute_group *hstate_attr_group)
