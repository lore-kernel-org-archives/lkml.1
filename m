Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbZIPWkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbZIPWkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbZIPWj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:39:56 -0400
Received: from kroah.org ([198.145.64.141]:48929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760340AbZIPWjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:15 2009
Message-Id: <20090916223715.431178121@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 15/45] perf_counter: Fix buffer overflow in perf_copy_attr()
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=perf_counter-fix-buffer-overflow-in-perf_copy_attr.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

commit b3e62e35058fc744ac794611f4e79bcd1c5a4b83 upstream.

If we pass a big size data over perf_counter_open() syscall,
the kernel will copy this data to a small buffer, it will
cause kernel crash.

This bug makes the kernel unsafe and non-root local user can
trigger it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4AAF37D4.5010706@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_counter.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4171,6 +4171,7 @@ static int perf_copy_attr(struct perf_co
 			if (val)
 				goto err_size;
 		}
+		size = sizeof(*attr);
 	}
 
 	ret = copy_from_user(attr, uattr, size);


