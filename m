Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZLMSs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZLMSs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 13:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZLMSs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 13:48:56 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:47149 "HELO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751258AbZLMSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 13:48:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SSKVv7vL3PjxBqWsyiya9125Se4Ktcr5U+VLkQ2xO1NE2tqJJ0Slk4ym/MBnbeEW/Q
         QHtNIiKfV1Tyq4yuq3wbIs4ZNPUbGwUFD6m3Cnhj9iyF/EXudKb+1UuLygEhKtd0iW2m
         0wSLBZ2HbqeIYxiSZ8T5WIUVTUzHO6IlNLS/E=
Date: Sun, 13 Dec 2009 13:48:42 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [RELEASE] LTTng 0.181 for Linux kernel 2.6.32
Message-ID: <20091213184842.GA16448@hansolo.jdub.homelinux.org>
References: <20091204160633.GA29864@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204160633.GA29864@Krystal>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:06:33AM -0500, Mathieu Desnoyers wrote:
>Hi,
>
>I just released LTTng 0.181 for Linux kernel 2.6.32. All packages and
>links to the git tree can be found at:
>
>http://www.lttng.org
>
>Comment and feedback are always welcome.

This fails to build for PowerPC 44x.  The following trivial patch fixes it.

josh

From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Fix LTTng 0.181 compilation on PowerPC

LTTng fails to build on powerpc due to a missing #include in the instrumented
arch/powerpc/kernel/timer.c file.  Fix it.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 5465ab2..3e7f6e4 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -54,6 +54,7 @@
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/perf_event.h>
+#include <trace/trap.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>

