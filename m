Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZHTJpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZHTJpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 05:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZHTJpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 05:45:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbZHTJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 05:45:50 -0400
Date: Thu, 20 Aug 2009 02:44:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
Message-Id: <20090820024453.dd9909a2.akpm@linux-foundation.org>
In-Reply-To: <1250755318.8974.26.camel@macbook.infradead.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
	<20090819142634.0fc550d1.akpm@linux-foundation.org>
	<1250754748.8974.17.camel@macbook.infradead.org>
	<1250755318.8974.26.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 09:01:58 +0100 David Woodhouse <dwmw2@infradead.org> wrote:

> +	if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
> +		/* Promote an attitude of violence to a BIOS engineer today */
> +		WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
> +		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
> +		     drhd->reg_base_addr,

Printing a u64 with %ll will (still) generate a warning on four architectures.

> +		     dmi_get_system_info(DMI_BIOS_VENDOR),
> +		     dmi_get_system_info(DMI_BIOS_VERSION),
> +		     dmi_get_system_info(DMI_PRODUCT_VERSION));
> +		goto err_unmap;
> +	}
