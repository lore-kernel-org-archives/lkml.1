Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbZBFClX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbZBFClX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZBFClJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:41:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:55011 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472AbZBFClH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=GXg5alQUAcS0cFbxGjKuUCJUJK4+B/bnHp0vfJzYIpEZ4Xhygl0zhySV+ulkwWu8/h
         bENsSfBsX8Fq/rrkCWqdvB0cqj9IuGl8IKsODXejNgjZS3JJv5BJtPGXb+ScnTHU/FWx
         5hLqouTdoDmyMQzbcIdMj4xOoXsQa96sfz5Y4=
MIME-Version: 1.0
In-Reply-To: <703a7cde0902050929s200cd6a4m95f32aa9c93293ad@mail.gmail.com>
References: <703a7cde0902050929s200cd6a4m95f32aa9c93293ad@mail.gmail.com>
Date: Fri, 6 Feb 2009 11:41:06 +0900
Message-ID: <703a7cde0902051841q6aa9dc10y2a19f2ddbb6a1b72@mail.gmail.com>
Subject: Re: [PATCH] [ARM] Fix condition in arm_elf_read_implies_exec() to set 
	READ_IMPLIES_EXEC
From: Makito SHIOKAWA <lkhmkt@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally, XN bit seems to be supported from ARMv6.

Signed-off-by: Makito SHIOKAWA <lkhmkt@gmail.com>
---
 arch/arm/kernel/elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -74,9 +74,9 @@ EXPORT_SYMBOL(elf_set_personality);
  */
 int arm_elf_read_implies_exec(const struct elf32_hdr *x, int executable_stack)
 {
-	if (executable_stack != EXSTACK_ENABLE_X)
+	if (executable_stack != EXSTACK_DISABLE_X)
 		return 1;
-	if (cpu_architecture() <= CPU_ARCH_ARMv6)
+	if (cpu_architecture() < CPU_ARCH_ARMv6)
 		return 1;
 	return 0;
 }
