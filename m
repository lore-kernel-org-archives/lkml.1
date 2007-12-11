Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbXLKNiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbXLKNiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbXLKNiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:38:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbXLKNiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:38:13 -0500
Date: Tue, 11 Dec 2007 14:37:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: dor.laor@qumranet.com
Cc: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Performance overhead of get_cycles_sync
Message-ID: <20071211133738.GA8150@elte.hu>
References: <475E8C8B.7070308@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475E8C8B.7070308@qumranet.com>
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


* Dor Laor <dor.laor@gmail.com> wrote:

> Hi Ingo, Thomas,
>
> In the latest kernel (2.6.24-rc3) I noticed a drastic performance 
> decrease for KVM networking. The reason is many vmexit (exit reason is 
> cpuid instruction) caused by calls to gettimeofday that uses tsc 
> sourceclock. read_tsc calls get_cycles_sync which might call cpuid in 
> order to serialize the cpu.
>
> Can you explain why the cpu needs to be serialized for every gettime 
> call? Do we need to be that accurate? (It will also slightly improve 
> physical hosts). I believe you have a reason and the answer is yes. In 
> that case can you replace the serializing instruction with an 
> instruction that does not trigger vmexit? Maybe use 'ltr' for example?

hm, where exactly does it call CPUID?

	Ingo
