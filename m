Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZGSQ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZGSQ2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 12:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZGSQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 12:28:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbZGSQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 12:28:32 -0400
Date: Sun, 19 Jul 2009 18:27:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090719162735.GB19434@elte.hu>
References: <20090719114411.GN5638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090719114411.GN5638@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Gleb Natapov <gleb@redhat.com> wrote:

> +	if (!ret) {
> +		/* IR is required if there is APIC ID > 255 even when running
> +		 * under KVM
> +		*/

Eeek.

> +	if (x2apic_preenabled) {
> +		panic("x2apic enabled by bios. But IR enabling failed."
> +		      " Check that CONFIG_X86_X2APIC and CONFIG_INTR_REMAP are"
> +		      " enabled.");

We dont want to break such messages mid-line, it makes it hard to 
git-grep for them. Also, the '. But' looks weird.

	Ingo
