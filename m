Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZK0PLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZK0PLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZK0PLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:11:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbZK0PLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 10:11:16 -0500
Date: Fri, 27 Nov 2009 16:05:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Veaceslav Falico <vfalico@redhat.com>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
Message-ID: <20091127150531.GE5137@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com> <20091127053925.GA8135@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127053925.GA8135@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Ananth N Mavinakayanahalli wrote:
>
> On Thu, Nov 26, 2009 at 03:50:51PM +0100, Oleg Nesterov wrote:
>
> > Ananth, could you please run the test-case from the changelog
> > below ? I do not really expect this can help, but just in case.
>
> Right, it doesn't help :-(
>
> GDB shows that the parent is forever struck at wait().

Now this is interesting. Could you please double check the parent hangs
in wait() ?

This doesn't match the testing we did on powerpc machine with Veaceslav,
and I hoped the problem was already resolved?

Please see other emails in this thread.


Hmm. Fortunately I still have the access to the testing machine.
Yes, according to gdb it looks as if it "hangs" in wait(). This
is not true. You can strace gdb itself, or look at xxx_ctxt_switches
in /proc/pid_of_parent/status.

Better yet, do not use gdb at all. Just strace (without -f) the parent,
you should see it continues to trace the child and loops forever.

Oleg.

