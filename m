Return-Path: <linux-kernel-owner+w=401wt.eu-S936680AbXHLPop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936680AbXHLPop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbXHLPof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:44:35 -0400
Received: from www.osadl.org ([213.239.205.134]:50283 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760061AbXHLPod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:44:33 -0400
Message-Id: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 15:46:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>
Subject: [patch 0/3] [patch 0/3] genirq: Suppress resend of level interrupts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The delayed irq disable functionality introduced a bug due to
retriggering level type interrupts in case of the delayed disable. The
resulting problem was discussed and debugged here:
http://marc.info/?l=linux-kernel&m=118202978609968&w=2

The resend of a level type interrupt is unnessecary and adds extra
noise to the system. Level type interrupts are resent by hardware when
they are still active at irq_enable(). The hard-/soft-ware resend is
only useful for edge type interrupts.

The following patch series addresses the problem and fixes an
unnoticed mismerge which affects the same area as well.

	tglx

-- 

