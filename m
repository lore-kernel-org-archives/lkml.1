Return-Path: <linux-kernel-owner+w=401wt.eu-S1751683AbZDUG7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbZDUG7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZDUG6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:58:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZDUG6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:58:54 -0400
Date: Tue, 21 Apr 2009 08:58:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, Weidong Han <weidong.han@intel.com>
Subject: Re: [patch 1/5] x2apic, IR: cleanup X86_X2APIC and INTR_REMAP
	config checks
Message-ID: <20090421065841.GA22937@elte.hu>
References: <20090420200450.128993000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420200450.128993000@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Add x2apic_supported() to cleanup CONFIG_X86_X2APIC checks.
> 
> Fix CONFIG_INTR_REMAP checks.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Weidong Han <weidong.han@intel.com>
> ---
> 
> Index: tip/arch/x86/include/asm/apic.h

Ob'nit'pick: please generate diffstats for future patches as it 
makes in-email review much easier.

The diffstat is:

 arch/x86/include/asm/apic.h          |   10 +++----
 arch/x86/include/asm/io_apic.h       |    2 -
 arch/x86/include/asm/irq_remapping.h |    2 -
 arch/x86/kernel/apic/apic.c          |   49 ++++++++---------------------------
 arch/x86/kernel/apic/io_apic.c       |    2 -
 arch/x86/kernel/apic/probe_64.c      |    2 -
 include/linux/dmar.h                 |    2 +
 7 files changed, 21 insertions(+), 48 deletions(-)

Which already shows that the patch has a very nice cleanup factor.

I've added an "[ Impact: cleanup ]" tag to it - the patch is not 
supposed to have any functional side-effects, right? (i.e. has no 
fixes embedded in it.)

a question:

>  	if (intr_remapping_enabled)
>  		disable_intr_remapping();

Could the intr_remapping_enabled check be moved inside 
disable_intr_remapping(), and thus the ugly 'if (flag)' construct 
could go away?

>  	if (intr_remapping_enabled) {
> +		reenable_intr_remapping(x2apic_mode);
>  		unmask_8259A();
>  		restore_IO_APIC_setup(ioapic_entries);
>  		free_ioapic_entries(ioapic_entries);
>  	}

Ditto - shouldnt this sequence move into reenable_intr_remapping() - 
or into a new helper function? (or is it too single-purpose)

Anyway, this already looks good as-is so i can apply it if you do 
delta patches on top of it to improve it further.

	Ingo
