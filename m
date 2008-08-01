Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbYHAPN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbYHAPN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYHAPNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:13:48 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:43383 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYHAPNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=v5Q1ghf1LQtYWpENQffvENxS+tov42L86O94hEZhnWBZiwRSWjFGw/DrjLowqiPGgO
         fC6OPi2HmK4+lGnD/2+VzPruJdRaA1SmWYNSNH8PiVW4NsLUxnYdN2/KF3gIJGoQ1+5s
         puDkIf4vRn5Aew21BQq7cUXAu+4xJ0gus0yfs=
Message-ID: <48f7fe350808010813u4e71c3e7h4d25127533a12726@mail.gmail.com>
Date: Fri, 1 Aug 2008 11:13:46 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH][RESEND] mm: fix uninitialized variables for find_vma_prepare callers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was submitted for 2.6.26-rc8-mm1 but it must have gotten overlooked:

diff --git a/mm/mmap.c b/mm/mmap.c
index 4c5211b..3d65a03 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -372,7 +372,7 @@ find_vma_prepare(struct mm_struct *mm, unsigned long addr,
 		if (vma_tmp->vm_end > addr) {
 			vma = vma_tmp;
 			if (vma_tmp->vm_start <= addr)
-				return vma;
+				break;
 			__rb_link = &__rb_parent->rb_left;
 		} else {
 			rb_prev = __rb_parent;
