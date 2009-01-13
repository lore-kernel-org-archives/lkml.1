Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZAMWud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZAMWud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZAMWuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:50:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753AbZAMWuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:50:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: mtk.manpages@gmail.com, "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: [PATCH] sys_waitid: return -EFAULT for NULL
In-Reply-To: Roland McGrath's message of  Tuesday, 13 January 2009 14:47:59 -0800 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
X-Fcc: ~/Mail/linus
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	<cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	<20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
X-Shopping-List: (1) Scenic pyrotechnical sandwiches
   (2) Trenchant detergent socks
   (3) Pregnant unit checks
Message-Id: <20090113224941.36F19FC3DD@magilla.sf.frob.com>
Date: Tue, 13 Jan 2009 14:49:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's always been invalid to call waitid() with a NULL pointer.  It was an
oversight that it was allowed (and acts like a wait4() call instead).

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/exit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index c7740fa..fa25790 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1760,6 +1760,8 @@ asmlinkage long sys_waitid(int which, pid_t upid,
 	enum pid_type type;
 	long ret;
 
+	if (unlikely(!infop))
+		return -EFAULT;
 	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED))
 		return -EINVAL;
 	if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
