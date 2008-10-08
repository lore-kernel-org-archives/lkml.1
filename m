Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYJHJut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYJHJut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYJHJum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:50:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34130 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYJHJul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:50:41 -0400
Date: Wed, 8 Oct 2008 11:50:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, yinghai@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
Message-ID: <20081008095024.GA31622@elte.hu>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org> <Pine.LNX.4.64.0810021705460.26309@shark.he.net> <20081007163331.711a938c.kamezawa.hiroyu@jp.fujitsu.com> <48EB8BBB.8000907@kernel.org> <20081008084753.f1a4fc2e.kamezawa.hiroyu@jp.fujitsu.com> <20081007170103.3dcb6384.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007170103.3dcb6384.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > could be merging problem again.
> > > 
> > > please check in arch/x86/kernel/vmliux_64.lds.S
> > > 
> > > it should be like 
> > > 
> > >   __con_initcall_end = .;
> > >   __x86_cpu_dev_start = .;
> > >   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
> > >         *(.x86_cpu_dev.init)
> > >   }
> > >   __x86_cpu_dev_end = .;
> > > 
> > >   DYN_ARRAY_INIT(8)
> > > 
> > >   SECURITY_INIT
> 
> The above is what's presently in Ingo's "tip" tree.
> 
> > Oh, yes. like this.
> > ==
> >  __con_initcall_end = .;
> >   __x86_cpu_dev_start = .;
> >   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
> >         *(.x86_cpu_dev.init)
> >   }
> >   SECURITY_INIT
> >   __x86_cpu_dev_end = .;
> > ==
> > 
> > I'll try next version when it comes.
> 
> If that fixes it then Ingo's tree will need fixing too, I suppose.

it should be:

  __x86_cpu_dev_end = .;

  DYN_ARRAY_INIT(8)

  SECURITY_INIT

and that's what it is in -tip. Am i missing something?

	Ingo
