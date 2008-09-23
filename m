Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYIWTRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYIWTRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYIWTRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:17:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:27210 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbYIWTRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:17:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="339662551"
Date: Tue, 23 Sep 2008 12:17:43 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080923191742.GA15609@linux-os.sc.intel.com>
References: <20080919123320.GF7222@lenovo> <20080923005737.GA25045@linux-os.sc.intel.com> <20080923011620.GB25045@linux-os.sc.intel.com> <20080923045637.GA7172@localhost> <20080923183411.GD25045@linux-os.sc.intel.com> <20080923190002.GE10567@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923190002.GE10567@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 12:00:02PM -0700, Cyrill Gorcunov wrote:
> ---
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Clean up obscure for() cycle with straight while() form
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> Index: linux-2.6.git/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/io_apic.c        2008-09-22 17:42:33.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/io_apic.c     2008-09-23 22:45:58.000000000 +0400
> @@ -830,9 +830,8 @@ int save_mask_IO_APIC_setup(void)
>         return 0;
> 
>  nomem:
> -       for (; apic > 0; apic--)
> -               kfree(early_ioapic_entries[apic]);
> -       kfree(early_ioapic_entries[apic]);
> +       while (apic >= 0)
> +               kfree(early_ioapic_entries[apic--]);
>         memset(early_ioapic_entries, 0,
>                 ARRAY_SIZE(early_ioapic_entries));
> 

looks better. thanks.
