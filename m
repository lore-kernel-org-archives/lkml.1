Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbXFFHdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbXFFHdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXFFHdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:33:43 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:43259 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbXFFHdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:33:42 -0400
Message-Id: <46667FA3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 06 Jun 2007 09:34:27 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Benjamin LaHaise" <bcrl@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <virtualization@lists.osdl.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Ingo Molnar" <mingo@redhat.com>, "Chris Wright" <chrisw@sous-sol.org>,
       "Andi Kleen" <ak@suse.de>, "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [patch 21/33] xen: Xen SMP guest support
References: <20070522140941.802382212@goop.org>
 <20070522141252.611887616@goop.org>
In-Reply-To: <20070522141252.611887616@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>--- a/arch/i386/xen/time.c
>+++ b/arch/i386/xen/time.c
>@@ -105,17 +105,15 @@ static void get_runstate_snapshot(struct
> 	preempt_enable();
> }
> 
>-static void setup_runstate_info(void)
>+static void setup_runstate_info(int cpu)
> {
> 	struct vcpu_register_runstate_memory_area area;
> 
>-	area.addr.v = &__get_cpu_var(runstate);
>+	area.addr.v = &per_cpu(runstate, cpu);
> 
> 	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
> 			       smp_processor_id(), &area))

Shouldn't this be 'cpu' rather than 'smp_processor_id()'?

> 		BUG();
>-
>-	get_runstate_snapshot(&__get_cpu_var(runstate_snapshot));
> }
> 
> static void do_stolen_accounting(void)

Jan

