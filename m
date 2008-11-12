Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYKLSAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYKLSAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:00:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYKLR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:59:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYKLR7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:59:35 -0500
Date: Wed, 12 Nov 2008 18:58:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Make nmi_shootdown_cpus() usable by non-kdump code
Message-ID: <20081112175847.GA12252@elte.hu>
References: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduardo Habkost <ehabkost@redhat.com> wrote:

> Hi, Ingo,
> 
> As tip/master is a moving target, I am splitting the previous 
> kdump/reboot virtualization-disable code series[1] into smaller 
> series so the simpler parts can be included sooner. This first 
> series is just for making nmi_shootdown_cpus() usable by non-kdump 
> code, by moving their generic parts to reboot.c.

applied them to tip/x86/crashdump, thanks Eduardo!

this branch btw. is an append-only non-rebasing tree that is not a 
moving target, you can access it via:

  http://people.redhat.com/mingo/tip.git/README

and then do:

  git checkout -b x86/crashdump tip/x86/crashdump

it has the following changes queued up currently:

Eduardo Habkost (8):
      x86 kdump: extract kdump-specific code from crash_nmi_callback()
      x86 kdump: move crashing_cpu assignment to nmi_shootdown_cpus()
      x86 kdump: create kdump_nmi_shootdown_cpus()
      x86 kdump: make kdump_nmi_callback() a function ptr on crash_nmi_callback()
      x86 kdump: make nmi_shootdown_cpus() non-static
      x86: move nmi_shootdown_cpus() to reboot.c
      x86: make nmi_shootdown_cpus() available on !SMP and !X86_LOCAL_APIC
      x86: disable IRQs before doing anything on nmi_shootdown_cpus()

Huang Ying (3):
      kexec/i386: remove PAGE_SIZE alignment from relocate_kernel
      kexec/i386: allocate page table pages dynamically
      kexec/i386: setup kexec page table in C

if you prefer less flux then you can send patches against that branch, 
we'll sort out interaction with other trees.

	Ingo
