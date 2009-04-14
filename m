Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZDNQyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZDNQyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZDNQyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:54:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZDNQyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:54:45 -0400
Date: Tue, 14 Apr 2009 18:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH -tip] x86: cpu/intel_cacheinfo.c fix compilation
	warnings
Message-ID: <20090414165433.GC2089@elte.hu>
References: <1239712990.3079.17.camel@ht.satnam> <20090414133242.GB27163@elte.hu> <1239727581.2966.17.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239727581.2966.17.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Tue, 2009-04-14 at 15:32 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > fix:
> > >   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
> > >   arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
> > >   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
> > >   arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’
> > 
> > you again 'fixed' a warning.
> > 
> > this made you fail to analyze and miss the real reason for this for 
> > example:
> > 
> > >   arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’
> > 
> > > -	int node = cpu_to_node(cpu);
> > 
> > the local variable is clearly initialized.
> > 
> > The problem is not with that variable - the problem is most likely 
> > with the cpu_to_node() macro not creating a reference to the 'cpu' 
> > variable in a compiler-visible way, in the !NUMA case.
> > 
> > The typical way to solve this is to add a dummy:
> > 
> > 	(void)(cpu)
> > 
> > use to the 'cpu' parameter to the macro definition - or, (which is a 
> > much better solution), to convert it to an inline function.
> > 
> 
> OK send patch:
> [PATCH -tip] x86: k8.h reference to node in node_to_k8_nb_misc for !CONFIG_K8_NB

You sent a patch, but did you read+understand the 
suggestions i made above?

	Ingo
