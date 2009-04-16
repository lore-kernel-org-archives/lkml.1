Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZDPJRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZDPJRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZDPJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:17:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47762 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbZDPJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:17:30 -0400
Date: Thu, 16 Apr 2009 11:16:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] irq: make io_apic_set_pci_routing to take device
Message-ID: <20090416091620.GI9813@elte.hu>
References: <49E68C41.4020801@kernel.org> <49E68D39.4010803@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E68D39.4010803@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: so use dev_to_node

> and use node in irq_desc_all_node()
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/ia64/kernel/acpi.c        |    5 +++--
>  arch/x86/include/asm/io_apic.h |    4 ++--
>  arch/x86/include/asm/mpspec.h  |    4 +++-
>  arch/x86/kernel/acpi/boot.c    |    8 ++++----
>  arch/x86/kernel/apic/io_apic.c |   10 ++++++++--
>  drivers/acpi/pci_irq.c         |    5 +++--
>  drivers/char/hpet.c            |    4 ++--
>  drivers/pnp/pnpacpi/rsparser.c |    2 +-
>  include/linux/acpi.h           |    2 +-
>  9 files changed, 27 insertions(+), 17 deletions(-)

Please split this into two patches: one "obviously correct" one that 
just extends the call parameters, and another one that makes use of 
the new information:

> +	if (dev)
> +		node = dev_to_node(dev);
> +	else
> +		node = cpu_to_node(boot_cpu_id);

Btw., this sequence raises the question: wouldnt it be cleaner to 
have some sort of (somewhat artificial) 'boot platform device' that 
could be passed down instead of NULL, which would give 
dev_to_node(&boot_platform_dev) == boot_cpu_id?

Dunno - maybe it's not worth it and your solution is the cleanest.

Also, when submitting patches, please always try to Cc: affected 
non-x86 maintainers:

  scripts/get_maintainer.pl -f drivers/acpi/pci_irq.c   \
   drivers/pnp/pnpacpi/rsparser.c include/linux/acpi.h  \
   arch/ia64/kernel/acpi.c

Thanks,

	Ingo
