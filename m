Return-Path: <linux-kernel-owner+w=401wt.eu-S935109AbZDCReb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935109AbZDCReb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZDCReV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:34:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:52323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbZDCReU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:34:20 -0400
Date: Fri, 3 Apr 2009 17:33:32 GMT
From: Russ Anderson <rja@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330225240.GA22776@sgi.com>
References: <20090330225240.GA22776@sgi.com>
Subject: [tip:x86/uv] x86, UV: system table in bios accessed after unmap
Message-ID: <tip-1a544e659cbfce178395e9a090a47d1907d0cfa8@git.kernel.org>
Git-Commit-ID: 1a544e659cbfce178395e9a090a47d1907d0cfa8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 17:33:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a544e659cbfce178395e9a090a47d1907d0cfa8
Gitweb:     http://git.kernel.org/tip/1a544e659cbfce178395e9a090a47d1907d0cfa8
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Mon, 30 Mar 2009 17:52:40 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 19:25:57 +0200

x86, UV: system table in bios accessed after unmap

Use the copy of UV system table in kernel memory, not the one in
bios after unmapping.

Signed-off-by: Russ Anderson <rja@sgi.com>
LKML-Reference: <20090330225240.GA22776@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/bios_uv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index f638827..63a88e1 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -182,7 +182,8 @@ void uv_bios_init(void)
 	memcpy(&uv_systab, tab, sizeof(struct uv_systab));
 	iounmap(tab);
 
-	printk(KERN_INFO "EFI UV System Table Revision %d\n", tab->revision);
+	printk(KERN_INFO "EFI UV System Table Revision %d\n",
+					uv_systab.revision);
 }
 #else	/* !CONFIG_EFI */
 
