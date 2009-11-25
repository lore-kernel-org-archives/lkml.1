Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZKYPi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZKYPi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbZKYPiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:38:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:48645 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbZKYPiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:38:54 -0500
Date: Wed, 25 Nov 2009 07:40:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091125074033.4c46c1b0@infradead.org>
In-Reply-To: <m1ws1f6csh.fsf@fess.ebiederm.org>
References: <20091120211139.GB19106@sgi.com>
	<m1r5rrr9v5.fsf@fess.ebiederm.org>
	<20091122011457.GA16910@sgi.com>
	<alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
	<1259069986.4531.1453.camel@laptop>
	<alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	<20091124065022.6933be1a@infradead.org>
	<m1ws1f6csh.fsf@fess.ebiederm.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 09:41:18 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:
> Oii.
> 
> I don't think it is bad to export information to applications like
> irqbalance.
> 
> I think it pretty horrible that one of the standard ways I have heard
> to improve performance on 10G nics is to kill irqbalance.

irqbalance does not move networking irqs; if it does there's something
evil going on in the system. But thanks for the bugreport ;)


> Guys.  Migrating an irq from one cpu to another while the device is
> running without dropping interrupts is hard.

no it isn't; we've been doing it for years.


> I think the irq scheduler is the only scheduler (except for batch
> jobs) that we don't put in the kernel.  It seems to me that if we are
> going to go to all of the trouble to rewrite the generic code to
> better support irqbalance because we are having serious irqbalance
> problems, it will be less effort to suck irqbalance into the kernel
> along with everything else.

we had that; it didn't work.
what I'm asking for is for the kernel to expose the numa information;
right now that is the piece that is missing.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
