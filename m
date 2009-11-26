Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbZKZHxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbZKZHxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbZKZHxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:53:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33845 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014AbZKZHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:53:50 -0500
Date: Thu, 26 Nov 2009 13:23:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091126075335.GA18508@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125154052.GA6734@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 04:40:52PM +0100, Oleg Nesterov wrote:
> On 11/25, Ananth N Mavinakayanahalli wrote:
> >
> > I ran the ptrace-tests testsuite [1] on powerpc on the vanilla ptrace
> > and then with ptrace/utrace. The results for ptrace/utrace look better
> > :-)
> 
> Great! thanks a lot Ananth for doing this.
> 
> ptrace-utrace still fails 2 tests,
> 
> > FAIL: syscall-reset
> 
> I'll take a look later. Since unpatched kernel fails this test too
> I am not going to worry right now. I think this is ppc specific, x86
> passes this test.
> 
> > step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
> > /bin/sh: line 5: 24803 Aborted                 ${dir}$tst
> > FAIL: step-fork
> 
> This is expected. Should be fixed by
> 
> 	ptrace-copy_process-should-disable-stepping.patch
> 
> in -mm tree. (I am attaching this patch below just in case)
> I din't mention this patch in this series because this bug
> is "ortogonal" to utrace/ptrace.

Oleg,

The patch doesn't seem to fix the issue on powerpc:

step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
/bin/sh: line 5: 17325 Aborted                 ${dir}$tst
FAIL: step-fork

Ananth
