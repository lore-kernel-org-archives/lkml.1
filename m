Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbZKZRbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbZKZRbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZKZRbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:31:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZKZRbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:31:08 -0500
Date: Thu, 26 Nov 2009 18:25:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
Message-ID: <20091126172524.GA14768@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126145051.GB4382@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Oleg Nesterov wrote:
>
> On 11/26, Ananth N Mavinakayanahalli wrote:
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

Just noticed the test-case fails in handler_fail(). Most probably
this means it is killed by SIGALRM because either parent or child
hang in wait(). Perhaps we have another (ppc specific?) bug, but
currently I do not understand how this is possible, this should
not be arch-dependent.

Oleg.

