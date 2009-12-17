Return-Path: <linux-kernel-owner+w=401wt.eu-S936489AbZLQEZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936489AbZLQEZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935730AbZLQEE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:59 -0500
Received: from kroah.org ([198.145.64.141]:55739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935707AbZLQEEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:54 2009
Message-Id: <20091217035654.398436035@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [089/151] xen: register runstate on secondary CPUs
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 028896721ac04f6fa0697f3ecac3f98761746363 upstream.

The commit "xen: re-register runstate area earlier on resume" caused us
to never try and setup the runstate area for secondary CPUs. Ensure that
we do this...

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -295,6 +295,7 @@ static int __cpuinit xen_cpu_up(unsigned
 		(unsigned long)task_stack_page(idle) -
 		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
+	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
 	xen_init_lock_cpu(cpu);
 


