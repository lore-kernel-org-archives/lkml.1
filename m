Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZCBSDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZCBSDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbZCBSDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:03:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbZCBSDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:03:17 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200903021855.02765.bzolnier@gmail.com>
References: <1235996477.5330.174.camel@laptop>
	 <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
	 <200903021855.02765.bzolnier@gmail.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 19:02:55 +0100
Message-Id: <1236016975.5330.990.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 18:55 +0100, Bartlomiej Zolnierkiewicz wrote:
> IDE IRQ handler (& probably many others) assume that IRQ layer won't be
> trying to call it again while IRQ is being serviced -- is this going to
> change with the introduction of threaded IRQs?

No, the real hardirq handler needs to disable the irq line before
telling it wants the thread to run. The thread will then have to
re-enable the irq line after its done.



