Return-Path: <linux-kernel-owner+w=401wt.eu-S1946377AbXBCHcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946377AbXBCHcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 02:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946378AbXBCHcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 02:32:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45441 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946377AbXBCHcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 02:32:18 -0500
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq
	migration.
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@osdl.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070202170500.57b6c3a3.akpm@linux-foundation.org>
References: <200701221116.13154.luigi.genoni@pirelli.com>
	 <200702021848.55921.luigi.genoni@pirelli.com>
	 <m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	 <200702021905.39922.luigi.genoni@pirelli.com>
	 <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	 <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	 <20070202170500.57b6c3a3.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 03 Feb 2007 08:32:09 +0100
Message-Id: <1170487929.3073.988.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Once the migration operation is complete we know we will receive
> > no more interrupts on this vector so the irq pending state for
> > this irq will no longer be updated.  If the irq is not pending and
> > we are in the intermediate state we immediately free the vector,
> > otherwise in we free the vector in do_IRQ when the pending irq
> > arrives.
> 
> So is this a for-2.6.20 thing?  The bug was present in 2.6.19, so
> I assume it doesn't affect many people?

I got a few reports of this; irqbalance may trigger this kernel bug it
seems... I would suggest to consider this for 2.6.20 since it's a
hard-hang case

