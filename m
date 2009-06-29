Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbZF2PCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbZF2PCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759640AbZF2PBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:01:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:36856 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZF2PBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:01:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="159617437"
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gleb Natapov <gleb@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
In-Reply-To: <20090629132926.GB20289@redhat.com>
References: <20090629132926.GB20289@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 29 Jun 2009 07:58:39 -0700
Message-Id: <1246287519.27006.10660.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 06:29 -0700, Gleb Natapov wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d1430ef..3e5b6ea 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -260,12 +260,15 @@ config SMP
>  
>  config X86_X2APIC
>  	bool "Support x2apic"
> -	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
> +	depends on X86_LOCAL_APIC && X86_64

Thinking more, probably we shouldn't remove this dependency. This might
encourage people (knowingly or unknowingly) to enable x2apic without
interrupt-remapping. Can we remove this? KVM mode will still work even
if we fail to enable interrupt-remapping. So this shouldn't be an issue,
correct?

Sorry I should have commented about this before.

>  
>  	ioapic_entries = alloc_ioapic_entries();
>  	if (!ioapic_entries) {
> -		pr_info("Allocate ioapic_entries failed: %d\n", ret);
> -		goto end;
> +		 pr_info("Allocate ioapic_entries failed\n");
> +		 return;


We should go to ir_failed ..

>  	}
>  
>  	ret = save_IO_APIC_setup(ioapic_entries);
>  	if (ret) {
>  		pr_info("Saving IO-APIC state failed: %d\n", ret);
> -		goto end;
> +		free_ioapic_entries(ioapic_entries);
> +		return;

same here.

In few hours I will be on 24 hour flight. So please bear with me for
delayed responses.

thanks,
suresh

