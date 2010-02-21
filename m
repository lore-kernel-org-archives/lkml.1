Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0BUOYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:24:01 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63691 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0BUOX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:23:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=s5gnJk36LZMfQjHSxdNCcdj7aNtnKWgJoBSXrtrh6P1lTghRciLiG+vn72Hq7u0aeb
         388WCPkkyglf04bNYV+GIrq4Qx9iKXH6aacGhJtz1fWd4E04Ws0IMMzsXyOhJdApss0C
         2uerxT3Tg0LcEgfjPLnNDc0LYjpgvrNGJc/eU=
Date: Sun, 21 Feb 2010 22:23:51 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 07/17] sysctl extern cleanup - latencytop
Message-ID: <20100221142351.GA3008@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

latencytop_enabled is declcared in linux/latencytop.h, so remove the
declaration in sysctl.c, include the head file instead.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:55:08.013076578 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:57:19.646397324 +0800
@@ -58,6 +58,7 @@
 #include <linux/binfmts.h>
 #include <linux/pid.h>
 #include <linux/compat.h>
+#include <linux/latencytop.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -73,7 +74,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
