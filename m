Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZBRRNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZBRRNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZBRRNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:13:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbZBRRNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:13:05 -0500
Date: Wed, 18 Feb 2009 09:12:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       'iommu@lists.linux-foundation.org', LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Suspend and Resume Support for Intel IOMMU
In-Reply-To: <20090218165633.GA20167@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.2.00.0902180910160.21686@localhost.localdomain>
References: <20090218165633.GA20167@linux-os.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Feb 2009, Fenghua Yu wrote:
>
> +static int vtd_enabled;
..
> +static int iommu_resume(struct sys_device *dev)
> +{
..
> +	if (!vtd_enabled)
> +		return 0;

Hmm. Why do this?

Wouldn't it be much more logical to only register the iommu_sysdev if the 
thing is enabled, rather than having an odd flag that gets tested at 
runtime?

		Linus
