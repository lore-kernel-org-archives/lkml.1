Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbZCNBzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbZCNBzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbZCNBVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:49 -0400
Received: from kroah.org ([198.145.64.141]:35738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754366AbZCNBVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:45 2009
Message-Id: <20090314011045.310960315@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [patch 094/114] ext4: Initialize preallocation list_heads properly
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=ext4-initialize-preallocation-list_head-s-properly.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit d794bf8e0936dce45104565cd48c571061f4c1e3)

When creating a new ext4_prealloc_space structure, we have to
initialize its list_head pointers before we add them to any prealloc
lists.  Otherwise, with list debug enabled, we will get list
corruption warnings.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3690,6 +3690,8 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 	pa->pa_free = pa->pa_len;
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
+	INIT_LIST_HEAD(&pa->pa_inode_list);
+	INIT_LIST_HEAD(&pa->pa_group_list);
 	pa->pa_deleted = 0;
 	pa->pa_linear = 0;
 
@@ -3748,6 +3750,7 @@ ext4_mb_new_group_pa(struct ext4_allocat
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
 	INIT_LIST_HEAD(&pa->pa_inode_list);
+	INIT_LIST_HEAD(&pa->pa_group_list);
 	pa->pa_deleted = 0;
 	pa->pa_linear = 1;
 


