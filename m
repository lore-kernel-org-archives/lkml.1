Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZALXwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZALXwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZALXv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:51:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54852 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZALXv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:51:56 -0500
Date: Tue, 13 Jan 2009 00:51:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, Daniel.Beschorner@facton.com,
       pageexec@freemail.hu, stable@kernel.org
Subject: Re: [patch] x86: fix PTE corruption issue while mapping RAM using
	/dev/mem
Message-ID: <20090112235135.GA22722@elte.hu>
References: <20090112203114.GA13157@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112203114.GA13157@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: fix PTE corruption issue while mapping RAM using /dev/mem 
> 
> Beschorner Daniel reported:
> > hwinfo problem since 2.6.28, showing this in the oops:
> > 	Corrupted page table at address 7fd04de3ec00
> 
> PaX Team reported a regression with this commit:
> 
> >	commit 9542ada803198e6eba29d3289abb39ea82047b92
> >	Author: Suresh Siddha <suresh.b.siddha@intel.com>
> >	Date:   Wed Sep 24 08:53:33 2008 -0700
> >
> >	    x86: track memtype for RAM in page struct
> 
> This commit breaks mapping any RAM page through /dev/mem, as the
> reserve_memtype() was not initializing the return attribute type and as such
> corrupting the PTE entry that was setup with the return attribute type.
> 
> Because of this bug, application mapping this RAM page through /dev/mem
> will die with "Corrupted page table at address xxxx" message in the kernel
> log and also the kernel identity mapping which maps the underlying RAM
> page gets converted to UC.
> 
> Fix this by initializing the return attribute type before calling
> reserve_ram_pages_type()
> 
> Reported-by: PaX Team <pageexec@freemail.hu>
> Reported-and-tested-by: Beschorner Daniel <Daniel.Beschorner@facton.com>
> Tested-and-Acked-by: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: <stable@kernel.org>
> ---

applied to tip/x86/urgent, thanks Suresh!

note that the patch caused some conflicts (there were other changes in 
pat.c) - i merged it up manually but could you please check the final 
commit in tip/master whether it's all OK?

	Ingo
