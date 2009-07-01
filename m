Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZGAGfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZGAGfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZGAGex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:34:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51276 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZGAGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:34:52 -0400
Date: Wed, 1 Jul 2009 08:34:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090701063455.GL6760@one.firstfloor.org>
References: <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <20090630223138.GH1241@elte.hu> <alpine.DEB.1.10.0906301847260.19482@gentwo.org> <20090630230743.GA17968@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630230743.GA17968@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Say it says "256 CPUs".
> 
> But i only run a 2 CPU guest system. But i want to run it with the 
> _on demand capability_ to scale up to 256 virtual CPUs if needed, 
> without having to reboot the guest and without having to allocate 
> all the percpu space for 256 CPUs beforehand. Ok?

Then you would need to fix lots of subsystems. Everyone doing
for_each_possible_cpu() today and not having a cpu notifier callback.

git/linux-2.6% gid for_each_possible_cpu | wc -l
247
git/linux-2.6% gid CPU_UP_PREPARE | wc -l
48

Essentially you would discard the concept of possible CPUs
and replace it only with online CPUs, but possible CPUs
are widely used.

It's unclear to me it's worth all that work (and how to test
it properly), assuming we fix the few per cpu pigs today that make it 
very expensive to preallocate percpu in the big debug configurations.

> It is a simple, basic OS feature and concept.

.. that Linux doesn't support without some heavy lifting.

Not answering emails will not change that fact.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
