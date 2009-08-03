Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZHCJK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZHCJK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZHCJK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:10:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63813 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZHCJK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:10:28 -0400
Message-ID: <4A76A96E.8070608@cn.fujitsu.com>
Date: Mon, 03 Aug 2009 17:10:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH] kvm: fix kvm_init()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove debugfs file if kvm_arch_init() return error

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2884baf..6299208 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2679,8 +2679,8 @@ out_free_0:
 	__free_page(bad_page);
 out:
 	kvm_arch_exit();
-	kvm_exit_debug();
 out_fail:
+	kvm_exit_debug();
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
-- 
1.6.1.2




