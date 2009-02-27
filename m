Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZB0JFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZB0JFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZB0JEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:04:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbZB0JEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:04:48 -0500
Date: Fri, 27 Feb 2009 10:03:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, mpm@selenic.com,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, linux-api@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090227090323.GC16211@elte.hu>
References: <20090211141434.dfa1d079.akpm@linux-foundation.org> <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu> <20090226223112.GA2939@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226223112.GA2939@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > I think the main question is: will we ever find ourselves in 
> > the future saying that "C/R sucks, nobody but a small 
> > minority uses it, wish we had never merged it"? I think the 
> > likelyhood of that is very low. I think the current OpenVZ 
> > stuff already looks very useful, and i dont think we've 
> > realized (let alone explored) all the possibilities yet.
> 
> This is collecting and start of dumping part of cleaned up 
> OpenVZ C/R implementation, FYI.
> 
>  arch/x86/include/asm/unistd_32.h   |    2 
>  arch/x86/kernel/syscall_table_32.S |    2 
>  include/linux/Kbuild               |    1 
>  include/linux/cr.h                 |   56 ++++++
>  include/linux/ipc_namespace.h      |    3 
>  include/linux/syscalls.h           |    5 
>  init/Kconfig                       |    2 
>  kernel/Makefile                    |    1 
>  kernel/cr/Kconfig                  |   11 +
>  kernel/cr/Makefile                 |    8 
>  kernel/cr/cpt-cred.c               |  115 +++++++++++++
>  kernel/cr/cpt-fs.c                 |  122 +++++++++++++
>  kernel/cr/cpt-mm.c                 |  134 +++++++++++++++
>  kernel/cr/cpt-ns.c                 |  324 +++++++++++++++++++++++++++++++++++++
>  kernel/cr/cpt-signal.c             |  121 +++++++++++++
>  kernel/cr/cpt-sys.c                |  228 ++++++++++++++++++++++++++
>  kernel/cr/cr-ctx.c                 |  141 ++++++++++++++++
>  kernel/cr/cr.h                     |   61 ++++++
>  kernel/cr/rst-sys.c                |    9 +
>  kernel/sys_ni.c                    |    3 
>  20 files changed, 1349 insertions(+)

That does not look scary to me at all. Andrew?

Before going into any fine details, a small high-level structure 
nit: the namespace is fine in kernel/cr/ too i guess, but 
wouldnt it be even better to move it close to their respective 
subsystems? mm/checkpoint.c, etc.?

Just like we have mm/nommu.c fs/proc/nommu.c, etc. - not 
kernel/nommu/mm.c kernel/nommu/proc.c.

I realize that for your forward-porting efforts it was a good 
idea to keep it all separated, but once we move this upstream 
the organization should be in close proximity of the code it 
affects.

That will have another advantage as well: the folks maintaining 
those subsystems will be more aware of it.

	Ingo
