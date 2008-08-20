Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYHTLS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYHTLS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYHTLST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:18:19 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:64825 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYHTLSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=qsi3BaZpYFugYYSM9Dbjwm8XXnOUu9Zywdt3nRLLW9q6qdUo++zWkzpXDtCByZtaaA
         0LYNvgF5+1g2Z4+OO19EqBMt2BGo4nycgtyRluKvtTSHxFHz3tY0vaPz6j0U/sJhcXR7
         buqLy847/oTrTRCwjYtgMRUJeuBvPxwO3FvEQ=
Message-ID: <48ABFD71.6070702@panasas.com>
Date: Wed, 20 Aug 2008 14:18:09 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Linux Audit <linux-audit@redhat.com>
CC: zhangxiliang <zhangxiliang@cn.fujitsu.com>, Eric Paris <eparis@redhat.com>,
       Steve Grubb <sgrubb@redhat.com>, viro@zeniv.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yu Zhiguo <yuzg@cn.fujitsu.com>
Subject: [PATCH] fix warning in audit_match_perm
References: <4892F063.1080109@cn.fujitsu.com> <4893C42A.60803@cn.fujitsu.com> <4893CBA9.9020008@cn.fujitsu.com> <4893CCE5.7020907@cn.fujitsu.com>
In-Reply-To: <4893CCE5.7020907@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kernel/auditsc.c: In function ‘audit_match_perm’:
kernel/auditsc.c:249: warning: ISO C90 forbids mixed declarations and code

This was introduced in commit
1a61c88defcd611bd148d6c960b498e1b8bbbe00

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 kernel/auditsc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 972f8e6..e72b161 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -243,10 +243,12 @@ static inline int open_arg(int flags, int mask)
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
+	unsigned n;
+
 	if (unlikely(!ctx))
 		return 0;
 
-	unsigned n = ctx->major;
+	n = ctx->major;
 	switch (audit_classify_syscall(ctx->arch, n)) {
 	case 0:	/* native */
 		if ((mask & AUDIT_PERM_WRITE) &&
-- 
1.6.0

