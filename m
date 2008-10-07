Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYJGKaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYJGKaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYJGK3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:29:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYJGK3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:29:42 -0400
Subject: Re: IRQ balancing on a router
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jan Kasprzak <kas@fi.muni.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20081003063857.76b7b61a@linux.intel.com>
References: <20081003132117.GM16624@fi.muni.cz>
	 <20081003063857.76b7b61a@linux.intel.com>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 12:29:39 +0200
Message-Id: <1223375380.26330.24.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 06:38 -0700, Arjan van de Ven wrote:

> The good news is that irqthreads at least have the potential to solve
> this "lack of information"; if not, we could consider doing a form of
> microaccounting for irq handlers....

I have some patches floating about that account for nmi/irq/softirq time
in a fine grained scale. The trouble is that i've so far not found a way
to handle the case of a jiffie based sched_clock().

The trouble with that is that time always increases in IRQ context, so
nmi=0, softirq=0, regular=0 but irq=100%, which is obviuosly
sub-optimal :-)

