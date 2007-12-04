Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbXLDVE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbXLDVE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbXLDVEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:04:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45260 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbXLDVEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:04:48 -0500
Date: Tue, 4 Dec 2007 22:04:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [git pull] scheduler fixes
Message-ID: <20071204210430.GF32018@elte.hu>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <20071204120715.4ea204a8@mandriva.com.br> <alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org> <20071204160005.GA29783@elte.hu> <20071204161827.GA491@elte.hu> <20071204182851.GA18208@kroah.com> <20071204164124.447a5c36@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204164124.447a5c36@mandriva.com.br>
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


* Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br> wrote:

> | >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> | > 
> | > It has another commit besides this fix. Thanks,
> | 
> | Can you make up something that I can apply for 2.6.23-stable?  or is 
> | this not an issue on that tree?
> 
>  FWIW I couldn't reproduce the problem with 2.6.23.9. sched_slice() is 
> quite different on that kernel and _maybe_ it won't never divide by 
> zero.

no, this is due to a fairly recent commit, so 2.6.23 should not be 
affected. (We cleaned up sched_rr_interval() in one of the 2.6.24 
scheduler commits.)

>  My original report on vendor-sec was wrong. I've said that 2.6.23.9 
> had the same bug but turns out the kernel I tested had the Ingo's CFS 
> backport patch applied. I didn't know that, I thought it was a vanilla 
> kernel.
> 
>  Btw, I think it's important to release a new CFS backport patch 
> because maybe some distro is using it (Mandriva stable kernel is using 
> the CFS backport patch, but we didn't update to latest version yet).

this should only affect the v24 CFS version - i've updated the v24 
backport patches. sched_rr_interval() is almost never used, and it's 
basically never used for SCHED_OTHER tasks.

	Ingo
