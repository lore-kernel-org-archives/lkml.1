Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbYHZUBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbYHZUBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758985AbYHZUBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:01:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42485 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758943AbYHZUBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:01:05 -0400
Message-ID: <48B460FE.2020100@sgi.com>
Date: Tue, 26 Aug 2008 13:01:02 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -	bisected
References: <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org> <48B452F3.9040304@sgi.com> <alpine.LFD.1.10.0808261205530.3363@nehalem.linux-foundation.org> <20080826192848.GA20653@redhat.com>
In-Reply-To: <20080826192848.GA20653@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
...
> 
> But yes, for this to be even remotely feasible, there has to be a negligable
> performance cost associated with it, which right now, we clearly don't have.
> Given that the number of people running 4096 CPU boxes even in a few years time
> will still be tiny, punishing the common case is obviously absurd.
> 
> 	Dave
> 

I did do some fairly extensive benchmarking between configs of NR_CPUS = 128 and
4096 and most performance hits were in the neighborhood of < 5% on systems with
8 cpus and 4GB of memory (our most common test system).  [But changing cpumask_t's
to be pointers instead of values will likely increase this.]  I've tried to be
very sensitive to this issue with all my previous changes, so convincing the distros
to set NR_CPUS=4096 would be as painless for them as possible. ;-)

Btw, huge count cpu systems I don't think are that far away.  I believe the nextgen
Larabbee chips will be geared towards HPC applications [instead of just GFX apps],
and putting 4 of these chips on a motherboard would add up to 512 cpu threads (1024
if they support hyperthreading.)

Thanks,
Mike
