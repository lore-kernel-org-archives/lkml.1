Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZBXNCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZBXNCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZBXNCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:02:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbZBXNCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:02:33 -0500
Date: Tue, 24 Feb 2009 14:02:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224130212.GC31295@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3DE76.5010606@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> > and i think that abstraction is wrong.
> 
> No, it's not wrong.  It simply is irrelevant - it's congruent 
> vs. contiguos and all that we need is congruent.  Contiguous 
> of course achieves congruent but it doesn't make any 
> difference for this purpose.

Well, as long as we can go up in unit size to 2MB (on 64-bit 
x86) i'm fine with that model.

There's no granularity artifacts, right? pcpu_populate_chunk() 
intelligently only populates pages on an as-needed basis, so 
extending the percpu areas with a 2MB unit does not trigger 
nr_cpus*2MB allocations straight away.

The code looks very clean and if we can agree on the SMP/NUMA 
symmetry and the dynamic-ptr optimizations that it allows, plus 
if you can up the unit size to 2MB on 64-bit x86, i'm a happy 
camper and will pull it.

	Ingo
