Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXGHMWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXGHMWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXGHMV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:21:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXGHMVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:21:47 -0400
Date: Sun, 8 Jul 2007 14:21:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 09/20] KVM: MMU: Fix Wrong tlb flush order
Message-ID: <20070708122137.GB30226@elte.hu>
References: <11838956891287-git-send-email-avi@qumranet.com> <1183895689306-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183895689306-git-send-email-avi@qumranet.com>
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

> From: Shaohua Li <shaohua.li@intel.com>
> 
> Need to flush the tlb after updating a pte, not before.

>  		rmap_remove(vcpu, spte);
> -		kvm_flush_remote_tlbs(vcpu->kvm);
>  		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
> +		kvm_flush_remote_tlbs(vcpu->kvm);

hm, isnt this a must-have fix for v2.6.22 (and .21) as well?

	Ingo
