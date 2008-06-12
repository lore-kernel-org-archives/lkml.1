Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYFLJNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYFLJNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYFLJN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:13:29 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53080 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYFLJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:13:29 -0400
Message-ID: <4850E875.8060506@de.ibm.com>
Date: Thu, 12 Jun 2008 11:12:21 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Oberparleiter <oberparleiter@googlemail.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net
Subject: Re: [PATCH 6/6] gcov: architecture specific compile flag adjustments
References: <4843F6F7.9020000@de.ibm.com> <20080611170127.46b46d28.akpm@linux-foundation.org>
In-Reply-To: <20080611170127.46b46d28.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 02 Jun 2008 15:34:47 +0200
> Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> Exclude code from profiling which is not linked to the main kernel or
>> which is running in a context not compatible with the assumptions made
>> by gcc's profiling code.
> 
> powerpc allmodconfig fails with
> 
> Error: External symbol '__gcov_init' referenced from prom_init.c
> Error: External symbol '__gcov_merge_add' referenced from prom_init.c

--
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Fix for gcov patch fallout:

powerpc allmodconfig fails with

Error: External symbol '__gcov_init' referenced from prom_init.c
Error: External symbol '__gcov_merge_add' referenced from prom_init.c

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 arch/powerpc/kernel/Makefile |    1 +
 1 files changed, 1 insertion(+)

Index: linux-2.6.26-rc5-mm2/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6.26-rc5-mm2.orig/arch/powerpc/kernel/Makefile
+++ linux-2.6.26-rc5-mm2/arch/powerpc/kernel/Makefile
@@ -11,6 +11,7 @@ ifeq ($(CONFIG_PPC32),y)
 CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
+GCOV_prom_init.o := n
 
 ifdef CONFIG_FTRACE
 # Do not trace early boot code
