Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbXGHNtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbXGHNtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXGHNtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:49:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbXGHNtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:49:00 -0400
Date: Sun, 8 Jul 2007 15:48:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
Message-ID: <20070708134850.GB22911@elte.hu>
References: <11838994974161-git-send-email-avi@qumranet.com> <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4690E973.7000606@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> >>+#ifdef CONFIG_SCHED_KVM
> >>+static __read_mostly struct sched_kvm_hooks kvm_hooks;
> >>+#endif
> >
> >please just add a current->put_vcpu() function pointer instead of 
> >this hooks thing.
> 
> Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  
> The function pointers are common to all virtual machines.

well, this function pointer could then be reused by other virtual 
machines as well, couldnt it? If the task struct overhead is a problem 
(it really isnt, and it's dependent on CONFIG_KVM) then we could switch 
it around to a notifier-alike mechanism.

	Ingo
