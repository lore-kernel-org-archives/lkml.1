Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYBWX3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYBWX3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbYBWX1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:27:49 -0500
Received: from smtp-out.google.com ([216.239.45.13]:39448 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbYBWX1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:27:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=rnxYy3t/0+Cdkxs76fXZTkE9RPhefGOW0hAuJJCCi99XBBMlWZUz3NbOLL2klD+7F
	1aHL5yICmvvIKQd3DSYXQ==
Message-Id: <20080223232617.472024000@menage.corp.google.com>
References: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:27 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 02/10] CGroup API files: Add res_counter_read_u64()
Content-Disposition: inline; filename=resource_counter_read_uint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a function for returning the value of a resource counter member,
in a form suitable for use in a cgroup read_u64 control file method.

Signed-off-by: Paul Menage <menage@google.com>

---
 include/linux/res_counter.h |    5 ++++-
 kernel/res_counter.c        |    5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

Index: cgroup-2.6.25-rc2-mm1/include/linux/res_counter.h
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/include/linux/res_counter.h
+++ cgroup-2.6.25-rc2-mm1/include/linux/res_counter.h
@@ -39,8 +39,9 @@ struct res_counter {
 	spinlock_t lock;
 };
 
-/*
+/**
  * Helpers to interact with userspace
+ * res_counter_read_u64() - returns the value of the specified member.
  * res_counter_read/_write - put/get the specified fields from the
  * res_counter struct to/from the user
  *
@@ -51,6 +52,8 @@ struct res_counter {
  * @pos:     and the offset.
  */
 
+u64 res_counter_read_u64(struct res_counter *counter, int member);
+
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
Index: cgroup-2.6.25-rc2-mm1/kernel/res_counter.c
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/kernel/res_counter.c
+++ cgroup-2.6.25-rc2-mm1/kernel/res_counter.c
@@ -92,6 +92,11 @@ ssize_t res_counter_read(struct res_coun
 			pos, buf, s - buf);
 }
 
+u64 res_counter_read_u64(struct res_counter *counter, int member)
+{
+	return *res_counter_member(counter, member);
+}
+
 ssize_t res_counter_write(struct res_counter *counter, int member,
 		const char __user *userbuf, size_t nbytes, loff_t *pos,
 		int (*write_strategy)(char *st_buf, unsigned long long *val))

--
