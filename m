Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZBKTvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZBKTvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZBKTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:51:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39893 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZBKTvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:51:21 -0500
Date: Wed, 11 Feb 2009 20:50:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.28.4 freezing on a 32-bits x86 Thinkpad T43p
Message-ID: <20090211195038.GC25968@elte.hu>
References: <20090204211106.GA30824@Krystal> <20090204211759.GK22608@elte.hu> <20090211193125.GA30975@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211193125.GA30975@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Here is a new backtrace, taken with a huge amount of debugging active, which still 
> points to an interrupt handler nested over kvm_mmu_pte_write as the culprit. It's 
> weird that the kvm code gets called on my modest Pentium M laptop, which I think 
> has no VT-x support at all. I am not running any KVM VMs on this machine. The 
> problem still happens on 2.6.28.4, and Slub redzones did not identify any memory 
> corruption. This could be due to kvm_mmu_pte_write which either should not be 
> called at all, or due to improper interrupt disabling in this function.

Does latest tip:master fix it? In particular this one:

  9cf161a: x86/cpa: make sure cpa is safe to call in lazy mmu mode

fixes a crasher related to KVM and mmu notifiers ...

	Ingo
