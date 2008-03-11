Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbYCKIfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbYCKIfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYCKIfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:35:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47884 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYCKIfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:35:37 -0400
Date: Tue, 11 Mar 2008 09:35:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v5
Message-ID: <20080311083517.GC25110@elte.hu>
References: <20080310222955.565902000@linux-os.sc.intel.com> <20080311050644.GB4589@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311050644.GB4589@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > -	extern void __bad_fxsave_alignment(void);
> > -
> > -	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
> > -		__bad_fxsave_alignment();
> 
> I think removal of such checks needs giving necessary alignment to 
> cache. Previously it worked because of __aligned((16)) and 
> L1_CACHE_SHIFT combo.

it's still checked, just elsewhere:

> +       WARN_ON((unsigned long)dst->thread.xstate & 15);

i'd not expect us to ever align worse than 16 bytes in the future so 
this is a non-issue i think.

	Ingo
