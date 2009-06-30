Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbZF3VrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbZF3VrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZF3VrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:47:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:47855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZF3VrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:47:02 -0400
Date: Tue, 30 Jun 2009 21:45:38 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       efault@gmx.de, heukelum@fastmail.fm, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, heukelum@fastmail.fm, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <1246366820.6538.1.camel@marge.simson.net>
References: <1246366820.6538.1.camel@marge.simson.net>
Subject: [tip:x86/urgent] x86: Fix symbol annotation for arch/x86/lib/clear_page_64.S::clear_page_c
Message-ID: <tip-9e314996e3dc5189b9b36dce67088e882e989897@git.kernel.org>
Git-Commit-ID: 9e314996e3dc5189b9b36dce67088e882e989897
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 21:45:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e314996e3dc5189b9b36dce67088e882e989897
Gitweb:     http://git.kernel.org/tip/9e314996e3dc5189b9b36dce67088e882e989897
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 30 Jun 2009 15:00:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 30 Jun 2009 23:43:15 +0200

x86: Fix symbol annotation for arch/x86/lib/clear_page_64.S::clear_page_c

Noticed the zero-sized function symbol while looking at 'perf' profiles,
it causes the profiler to display those addresses in hexa.

Turns out that this was wrong/bogus for an eternity.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <1246366820.6538.1.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/lib/clear_page_64.S |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index 9a10a78..ebeafcc 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -5,15 +5,14 @@
  * Zero a page. 	
  * rdi	page
  */			
-	ALIGN
-clear_page_c:
+ENTRY(clear_page_c)
 	CFI_STARTPROC
 	movl $4096/8,%ecx
 	xorl %eax,%eax
 	rep stosq
 	ret
 	CFI_ENDPROC
-ENDPROC(clear_page)
+ENDPROC(clear_page_c)
 
 ENTRY(clear_page)
 	CFI_STARTPROC
