Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYL0EL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYL0EL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 23:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYL0ELs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 23:11:48 -0500
Received: from ozlabs.org ([203.10.76.45]:52819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYL0ELs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 23:11:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18773.43656.189438.155690@cargo.ozlabs.ibm.com>
Date: Sat, 27 Dec 2008 15:09:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       David Howells <dhowells@redhat.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [PATCH] kbuild, sparseirq: work around GCC bug with __weak aliases
In-Reply-To: <20081226134218.GA1054@elte.hu>
References: <20081219134636.GA11772@linux.vnet.ibm.com>
	<494C0BF0.3080109@kernel.org>
	<20081223132127.GA5450@linux.vnet.ibm.com>
	<495153A4.5060201@kernel.org>
	<20081224163400.GA11562@linux.vnet.ibm.com>
	<49529CE1.4040005@kernel.org>
	<20081226091217.GA5100@linux.vnet.ibm.com>
	<4954AC7B.3020603@kernel.org>
	<20081226102716.GA31450@uranus.ravnborg.org>
	<20081226133354.GC29265@elte.hu>
	<20081226134218.GA1054@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > I recall David Howells had a similar issue with the bootparamter patch 
> > > set. The workaround he used was to add a barrier(); call in the weak 
> > > function to avoid the inline.
> > 
> > could we add some extra attribute to __weak that would have a similar 
> > effect? Something like __attribute__((noinline)), or something silly 
> > like __attribute__((deprecated)) - just to keep gcc from screwing up 
> > __weak functions? Perhaps adding a section attribute would have a 
> > similar effect? (putting weak definitions into an extra section is 
> > probably helpful anyway)
> 
> I've applied the patch below to tip/irq/sparseirq - could someone with an 
> affected GCC version please check whether this solves the crash?

I recall from discussions earlier that noinline doesn't fix the
problem, and I just tested a similar case and verified that adding
noinline doesn't stop some versions of gcc from inlining them.  The
empty weak functions in kernel/perf_counter.c were getting inlined by
the cross-gcc (gcc 4.1.1) I use for compiling powerpc kernels on my
laptop, and adding noinline doesn't help there.

Paul.
