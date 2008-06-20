Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbYFTM7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbYFTM7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 08:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYFTM7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 08:59:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYFTM7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 08:59:44 -0400
Date: Fri, 20 Jun 2008 14:59:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen: don't drop NX bit
Message-ID: <20080620125924.GK7439@elte.hu>
References: <4856E2D4.3020402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4856E2D4.3020402@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When converting the pfn/mfn in a pagetable entry, make sure we mask 
> out the protection flags properly.  Formerly, this code was losing the 
> NX bit, and not dealing with extra Xen-defined software flags in ptes.
>
> Because NX is now enforced properly, we must put the hypercall page 
> into the .text segment so that it is executable.

applied all three fix patches to tip/x86/xen, thanks Jeremy.

i have also cherry-picked them into x86/urgent, to push v2.6.26-wards if 
they passes testing. The commits are [in that order]:

# x86/urgent: 4653938: xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
# x86/urgent: 05345b0: xen: mask unwanted pte bits in __supported_pte_mask
# x86/urgent: ebb9cfe: xen: don't drop NX bit

	Ingo
