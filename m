Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbZDQOPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbZDQOPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759795AbZDQOPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:15:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911AbZDQOPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:15:39 -0400
Date: Fri, 17 Apr 2009 16:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Weidong Han <weidong.han@intel.com>
Cc: dwmw2@infradead.org, allen.m.kay@intel.com, fenghua.yu@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 5/5] x86: fix x2apic/intr-remap resume
Message-ID: <20090417141516.GE23493@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com> <1239957736-6161-6-git-send-email-weidong.han@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239957736-6161-6-git-send-email-weidong.han@intel.com>
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


* Weidong Han <weidong.han@intel.com> wrote:

>  #ifdef CONFIG_INTR_REMAP
> -	if (intr_remapping_enabled)
> -		reenable_intr_remapping(EIM_32BIT_APIC_ID);
> +	if (intr_remapping_enabled) {
> +		if (x2apic)
> +			reenable_intr_remapping(EIM_32BIT_APIC_ID);
> +		else
> +			reenable_intr_remapping(EIM_8BIT_APIC_ID);

ok, we had this sequence before. Might be worthwile to push the 
x2apic condition into reenable_intr_remapping() itself? That would 
simplify the call sites.

	Ingo
