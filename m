Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbZK0Fjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbZK0Fjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZK0Fja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:39:30 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48482 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZK0Fj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:39:27 -0500
Date: Fri, 27 Nov 2009 11:09:25 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
Message-ID: <20091127053925.GA8135@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126145051.GB4382@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 03:50:51PM +0100, Oleg Nesterov wrote:
> I changed the subject. This bug has nothing to do with utrace,
> the kernel fails with or without these changes.
> 
> On 11/26, Ananth N Mavinakayanahalli wrote:
> >
> > On Wed, Nov 25, 2009 at 04:40:52PM +0100, Oleg Nesterov wrote:
> > > On 11/25, Ananth N Mavinakayanahalli wrote:
> > > >
> > > > step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
> > > > /bin/sh: line 5: 24803 Aborted                 ${dir}$tst
> > > > FAIL: step-fork
> > >
> > > This is expected. Should be fixed by
> > >
> > > 	ptrace-copy_process-should-disable-stepping.patch
> > >
> > > in -mm tree. (I am attaching this patch below just in case)
> > > I din't mention this patch in this series because this bug
> > > is "ortogonal" to utrace/ptrace.
> >
> > The patch doesn't seem to fix the issue on powerpc:
> >
> > step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
> > /bin/sh: line 5: 17325 Aborted                 ${dir}$tst
> > FAIL: step-fork
> 
> Good to know, thanks again Ananth.
> 
> I'll take a look. Since I know nothing about powerpc, I can't
> promise the quick fix ;)
> 
> The bug was found by code inspection, but the fix is not trivial
> because it depends on arch/, and it turns out the arch-independent
> fix in
> 
> 	ptrace-copy_process-should-disable-stepping.patch
> 	http://marc.info/?l=linux-mm-commits&m=125789789322573
> 
> doesn't work.
> 
> Ananth, could you please run the test-case from the changelog
> below ? I do not really expect this can help, but just in case.

Right, it doesn't help :-(

GDB shows that the parent is forever struck at wait().

Ananth
