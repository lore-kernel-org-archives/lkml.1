Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYKFAIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYKFAIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYKFAIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:08:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYKFAIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:08:15 -0500
Message-ID: <49123521.6020608@redhat.com>
Date: Wed, 05 Nov 2008 19:06:57 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kprobes: bugfix: try_module_get even if calling_mod is NULL
References: <490FE405.1000105@cn.fujitsu.com> <4910F697.2050203@redhat.com> <4910FB3D.4020805@cn.fujitsu.com> <491212C0.4030900@redhat.com> <4912222F.9040605@ct.jp.nec.com> <49122745.4090004@redhat.com>
In-Reply-To: <49122745.4090004@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get probed module even if the caller is in the kernel core code.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

>> One question, off topic.
>> If calling_mod is NULL, no try_module_get(), is that OK?
>
> Good question. Currently, kprobes is called only from kernel modules,
> so calling_mod should be always !NULL.
> However, it should be fixed, because the logic is not correct.

Thank you so much. So here is the additional bugfix patch.

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.28-rc3/kernel/kprobes.c
===================================================================
--- 2.6.28-rc3.orig/kernel/kprobes.c
+++ 2.6.28-rc3/kernel/kprobes.c
@@ -634,7 +634,7 @@ static int __kprobes __register_kprobe(s
 		 * avoid incrementing the module refcount, so as to allow
 		 * unloading of self probing modules.
 		 */
-		if (calling_mod && calling_mod != probed_mod) {
+		if (calling_mod != probed_mod) {
 			if (unlikely(!try_module_get(probed_mod))) {
 				preempt_enable();
 				return -EINVAL;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

