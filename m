Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbYBMOzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbYBMOzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYBMOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:55:28 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58955 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041AbYBMOz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:55:27 -0500
Date: Wed, 13 Feb 2008 15:55:20 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Nur Hussein <nurhussein@gmail.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, arjan@infradead.org,
       akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       kyle@parisc-linux.org, schwidefsky@de.ibm.com, lethal@linux-sh.org
Subject: Re: Taint kernel after WARN_ON(condition) v2
Message-ID: <20080213155520.681e7c06@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080213142740.GA4895@gandalf.middleearth>
References: <20080213142740.GA4895@gandalf.middleearth>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 22:27:40 +0800
Nur Hussein <nurhussein@gmail.com> wrote:

> This does not work on architectures where WARN_ON has its own definition. 
> These archs are:
> 	1. s390
> 	2. superh
> 	3. avr32
> 	4. parisc

Hmm. Relying on the generic code in lib/bug.c qualifies as "own
definition" these days? I think the patch below should take care of all
four...unless I've misunderstood something.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

diff --git a/lib/bug.c b/lib/bug.c
index 530f38f..0d67419 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -35,6 +35,7 @@
 
     Jeremy Fitzhardinge <jeremy@goop.org> 2006
  */
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/bug.h>
@@ -149,6 +150,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 			       (void *)bugaddr);
 
 		show_regs(regs);
+		add_taint(TAINT_WARN);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
