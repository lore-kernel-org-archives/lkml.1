Return-Path: <linux-kernel-owner+w=401wt.eu-S934303AbYBUU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303AbYBUU5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbYBUU43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:56:29 -0500
Received: from smtp-out.google.com ([216.239.33.17]:24165 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326AbYBUU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:56:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=AiriauBGrG8ajjzndzaLZ9P7K1eGQG3+nE+wOmQE7bjTAtUTckmFMbnLZEeP7FMpJ
	swI9Iq32mYDeb+If1VtNw==
Message-Id: <20080221205525.165641000@menage.corp.google.com>
References: <20080221203518.544461000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Thu, 21 Feb 2008 12:35:19 -0800
From: menage@google.com
To: akpm@linux-foundation.org, xemul@openvz.org, balbir@in.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/2] ResCounter: Add res_counter_read_uint()
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

Index: rescounter-2.6.25-rc2-mm1/include/linux/res_counter.h
===================================================================
--- rescounter-2.6.25-rc2-mm1.orig/include/linux/res_counter.h
+++ rescounter-2.6.25-rc2-mm1/include/linux/res_counter.h
@@ -54,6 +54,7 @@ struct res_counter {
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
+u64 res_counter_read_uint(struct res_counter *counter, int member);
 ssize_t res_counter_write(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*write_strategy)(char *buf, unsigned long long *val));
Index: rescounter-2.6.25-rc2-mm1/kernel/res_counter.c
===================================================================
--- rescounter-2.6.25-rc2-mm1.orig/kernel/res_counter.c
+++ rescounter-2.6.25-rc2-mm1/kernel/res_counter.c
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
