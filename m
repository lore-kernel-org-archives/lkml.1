Return-Path: <linux-kernel-owner+w=401wt.eu-S936486AbZLQE2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936486AbZLQE2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935708AbZLQE1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:27:44 -0500
Received: from kroah.org ([198.145.64.141]:55733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935701AbZLQEEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:54 2009
Message-Id: <20091217035654.268686380@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [088/151] xen: register timer interrupt with IRQF_TIMER
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit f350c7922faad3397c98c81a9e5658f5a1ef0214 upstream.

Otherwise the timer is disabled by dpm_suspend_noirq() which in turn prevents
correct operation of stop_machine on multi-processor systems and breaks
suspend.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -434,7 +434,7 @@ void xen_setup_timer(int cpu)
 		name = "<timer kasprintf failed>";
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER,
 				      name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);


