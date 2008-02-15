Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbYBOUt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbYBOUt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYBOUsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:48:55 -0500
Received: from smtp-out.google.com ([216.239.45.13]:5238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbYBOUsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:48:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=ZbtHf7Cvn/xAUywK/LgVc9AnsaUYQh8kCr6PcGhaxkhj8en/1HF8DEJo59BiEpNuJ
	nQQTuRdX8UXpF1YWaMHKw==
Message-Id: <20080215204821.252919000@menage.corp.google.com>
References: <20080215204418.535025000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Fri, 15 Feb 2008 12:44:22 -0800
From: Paul Menage <menage@google.com>
To: balbir@in.ibm.com, pj@sgi.com, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 4/7] CGroup API: Add res_counter_read_uint()
Content-Disposition: inline; filename=resource_counter_read_uint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a function for returning the value of a resource counter member,
in a form suitable for use in a cgroup read_uint control file method.

Signed-off-by: Paul Menage <menage@google.com>

---
 include/linux/res_counter.h |    1 +
 kernel/res_counter.c        |    5 +++++
 2 files changed, 6 insertions(+)

Index: cgroupmap-2.6.24-mm1/include/linux/res_counter.h
===================================================================
--- cgroupmap-2.6.24-mm1.orig/include/linux/res_counter.h
+++ cgroupmap-2.6.24-mm1/include/linux/res_counter.h
@@ -54,6 +54,7 @@ struct res_counter {
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
+u64 res_counter_read_uint(struct res_counter *counter, int member);
 ssize_t res_counter_write(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*write_strategy)(char *buf, unsigned long long *val));
Index: cgroupmap-2.6.24-mm1/kernel/res_counter.c
===================================================================
--- cgroupmap-2.6.24-mm1.orig/kernel/res_counter.c
+++ cgroupmap-2.6.24-mm1/kernel/res_counter.c
@@ -92,6 +92,11 @@ ssize_t res_counter_read(struct res_coun
 			pos, buf, s - buf);
 }
 
+u64 res_counter_read_uint(struct res_counter *counter, int member)
+{
+	return *res_counter_member(counter, member);
+}
+
 ssize_t res_counter_write(struct res_counter *counter, int member,
 		const char __user *userbuf, size_t nbytes, loff_t *pos,
 		int (*write_strategy)(char *st_buf, unsigned long long *val))

--
