Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZCHT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZCHT2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 15:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZCHT2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 15:28:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:46619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbZCHT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 15:28:02 -0400
Date: Sun, 8 Mar 2009 19:27:30 GMT
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jirislaby@gmail.com, jeremy.fitzhardinge@citrix.com,
       jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jirislaby@gmail.com, jeremy.fitzhardinge@citrix.com,
       jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B166D6.2080505@goop.org>
References: <49B166D6.2080505@goop.org>
Subject: [tip:x86/mm-v2] x86-32: make sure virt_addr_valid() returns false for fixmap addresses
Message-ID: <tip-0feca851c1b3cb4ebfa3149144b3d5de0879ebaa@git.kernel.org>
Git-Commit-ID: 0feca851c1b3cb4ebfa3149144b3d5de0879ebaa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 19:27:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0feca851c1b3cb4ebfa3149144b3d5de0879ebaa
Gitweb:     http://git.kernel.org/tip/0feca851c1b3cb4ebfa3149144b3d5de0879ebaa
Author:     "Jeremy Fitzhardinge" <jeremy@goop.org>
AuthorDate: Fri, 6 Mar 2009 10:09:26 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 20:03:52 +0100

x86-32: make sure virt_addr_valid() returns false for fixmap addresses

I found that virt_addr_valid() was returning true for fixmap addresses.

I'm not sure whether pfn_valid() is supposed to include this test,
but there's no harm in being explicit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49B166D6.2080505@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/ioremap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 62773ab..62def57 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -87,6 +87,8 @@ bool __virt_addr_valid(unsigned long x)
 		return false;
 	if (__vmalloc_start_set && is_vmalloc_addr((void *) x))
 		return false;
+	if (x >= FIXADDR_START)
+		return false;
 	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(__virt_addr_valid);
