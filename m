Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYISWxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYISWxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYISWxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:53:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:60236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYISWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:53:21 -0400
Date: Fri, 19 Sep 2008 15:53:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: sparse_irq: userspace ABI breakage in -tip tree
Message-ID: <20080919155321.1181638a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 70426a06a58561c401e64c5767d71a011d4b978b
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Tue Aug 19 20:50:27 2008 -0700

    x86: make 32 bit to use sparse_irq

@@ -285,7 +303,7 @@ int show_interrupts(struct seq_file *p, void *v)
                action = desc->action;
                if (!action && !any_count)
                        goto skip;
-               seq_printf(p, "%3d: ",i);
+               seq_printf(p, "%#x: ",i);
 #ifndef CONFIG_SMP
                seq_printf(p, "%10u ", kstat_irqs(i));
 #else


this is a userspace ABI breakage; you're changing /proc/interrupts from
decimal to hex! This file is used by both humans and computer programs,
and the humans will get confused, but the computer programs will break.
Not a good idea to put into mainline.

(I'm not so convinced of sparse_irq as a whole to be honest, but that's
a different story)
