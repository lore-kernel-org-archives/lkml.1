Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZBDD6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZBDD6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZBDD6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:58:16 -0500
Received: from ozlabs.org ([203.10.76.45]:40090 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbZBDD6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:58:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to -mm tree
Date: Wed, 4 Feb 2009 14:28:11 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com,
       travis@sgi.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org> <c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com> <20090203112529.26e6bf76.akpm@linux-foundation.org>
In-Reply-To: <20090203112529.26e6bf76.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041428.12059.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 05:55:29 Andrew Morton wrote:
> On Tue, 3 Feb 2009 17:58:13 +0100
> Fr__d__ric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 2009/2/3 Ingo Molnar <mingo@elte.hu>:
> > >
> > > * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> > >
> > >> ------------------------------------------------------
> > >> Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
> > >> From: Andrew Morton <akpm@linux-foundation.org>
> > >>
> > >> The various implemetnations and proposed implemetnations of work_on_cpu()
> > >> are vulnerable to various deadlocks because they all used queues of some
> > >> form.
> > >>
> > >> Unrelated pieces of kernel code thus gained dependencies wherein if one
> > >> work_on_cpu() caller holds a lock which some other work_on_cpu() callback
> > >> also takes, the kernel could rarely deadlock.
> > >>
> > >> Fix this by creating a short-lived kernel thread for each work_on_cpu()
> > >> invokation.
> > >>
> > >> This is not terribly fast, but the only current caller of work_on_cpu() is
> > >> pci_call_probe().
> > >
> > > hm, it's quite ugly as well
> 
> No it isn't.
> 
> It's no less ugly than the current code.
> 
> It's less buggy than the current code.

Whatever, I like your version.

Tho making it a series of 5 and exposing rdmsr_on_cpu/wrmsr_on_cpu for other
uses would be even better.

Thanks,
Rusty.
