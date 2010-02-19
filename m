Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0BSRHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:07:10 -0500
Received: from kroah.org ([198.145.64.141]:57763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab0BSRBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:04 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:51 2010
Message-Id: <20100219163251.071809208@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [73/93] x86: Re-get cfg_new in case reuse/move irq_desc
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 37ef2a3029fde884808ff1b369677abc7dd9a79a upstream.

When irq_desc is moved, we need to make sure to use the right cfg_new.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B07A739.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3157,6 +3157,7 @@ unsigned int create_irq_nr(unsigned int
 			continue;
 
 		desc_new = move_irq_desc(desc_new, node);
+		cfg_new = desc_new->chip_data;
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;


