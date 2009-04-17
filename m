Return-Path: <linux-kernel-owner+w=401wt.eu-S1761022AbZDQOay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022AbZDQOay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZDQOaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:30:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbZDQOaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:30:46 -0400
Date: Fri, 17 Apr 2009 16:30:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Weidong Han <weidong.han@intel.com>, David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dwmw2@infradead.org, allen.m.kay@intel.com, fenghua.yu@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] fix bugs of x2apic/intr-remap
Message-ID: <20090417143033.GF23493@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Weidong Han <weidong.han@intel.com> wrote:

> interupt remapping was decoupled from x2apic already, but there 
> are still some issues, such as doesn't ack remapped interrupts 
> correctly, and doesn't remap ioapic interrupt when x2apic is not 
> enabled.
> 
> This patchset fixes the ack for remapped interrupts, and alwasys 
> enables interrupt remapping before ioapic setup to guarantee 
> ioapic interrupts are remapped, adjusts the dependency of x2apic 
> and interrupt remapping in lapic_resume. In addition, add option 
> "nointremap" to disable interrupt remapping.
> 
> The patchset can be applied on linux head. Thanks.
> 
> Weidong Han (5):
>   docs: add nox2apic back to kernel-parameters.txt
>   x86,intr-remap: fix ack for interrupt remapping
>   x86, intr-remap: enable interrupt remapping early
>   x86, intr-remap: add option to disable interrupt remapping
>   x86: fix x2apic/intr-remap resume
> 
>  Documentation/kernel-parameters.txt |    5 ++
>  arch/x86/include/asm/apic.h         |   15 +-----
>  arch/x86/kernel/apic/apic.c         |   91 +++++++++++++++++------------------
>  arch/x86/kernel/apic/io_apic.c      |   32 ++----------
>  drivers/pci/intel-iommu.c           |    9 ----
>  drivers/pci/intr_remapping.c        |   39 ++++++++++-----
>  include/linux/dmar.h                |    1 +
>  7 files changed, 84 insertions(+), 108 deletions(-)

Thanks, this series is exactly what the doctor ordered: it fixes 
real problems and still manages to shrink the code!

I've made a few smaller observations to specific patches but none 
seemed like a real showstopper to me so i've applied your series to 
tip:x86/apic (with minor edits to the changelogs) to get this tested 
some more - pending Ack/Nak from David and Jesse for the IOMMU and 
PCI interactions.

Please do the fixlets/cleanups as delta patches against 
tip:x86/apic:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
