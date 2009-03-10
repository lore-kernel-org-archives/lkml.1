Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZCJJea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZCJJea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZCJJeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:34:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:15113 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZCJJeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QHO+j8FqBiZx3e9QO2q5NDHS+x/7w57UftJ6/UolMf0lhDo5EytB7ZQTmhNXeYVK3Q
         GTkDmi/beFUE9hGfJxNw+qEM7kAvdYoNqNd8xCjBz5LJAy0kjHnTh6A/wN5DqoKHIsJx
         csEMI7tj9vLZNNEkTSC71Rr3swnvAKivXmtCY=
Date: Tue, 10 Mar 2009 17:34:47 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Roland McGrath <roland@redhat.com>
Subject: [Patch] ptrace: remove a useless goto
Message-ID: <20090310093447.GC3179@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Obviously, this goto is useless. Remove it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Roland McGrath <roland@redhat.com>

---
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index c9cf48b..1379559 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -612,8 +612,6 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
 		goto out_put_task_struct;
 
 	ret = arch_ptrace(child, request, addr, data);
-	if (ret < 0)
-		goto out_put_task_struct;
 
  out_put_task_struct:
 	put_task_struct(child);

 
