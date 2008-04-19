Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYDSQFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYDSQFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYDSQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:05:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:23542 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYDSQFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:05:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=Zt4AwCkqBv89lH54gtnQJreoGKpm84jgSJHF7wOmwZzeRuWu1GovDf3EXe5M75Ci1KqQ+KSiS+KQFwidlFBxAepgOxWpcjVO7VCFqzlzCtfgVMw8ktmw95Z2aOnnJsSsbDOJpKGDErEFkrwBY0yvfWuN/b23iA9ZpoZURo7NZXo=
Date: Sun, 20 Apr 2008 00:04:53 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Linux 2.6.25 - posix_types.h
Message-ID: <Pine.LNX.4.64.0804192351220.3260@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

The latest git download changes the behavior of posix_types.h such that 
non-kernel programs are no longer able to include posix types 
(e.g. xserver can no longer be compiled).

I don't know whether this is intended or a bug.

Attached is a patch to allow __i386__ as was done in the past.

Thanks,
Jeff.


--- linux-2.6/include/asm-x86/posix_types.h.org	2008-04-19 16:53:03 +0800
+++ linux-2.6/include/asm-x86/posix_types.h	2008-04-19 16:51:48 +0800
@@ -1,5 +1,5 @@
-#ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
+#if defined(__KERNEL__) || defined(__i386__)
+# if defined(CONFIG_X86_32)
  #  include "posix_types_32.h"
  # else
  #  include "posix_types_64.h"

