Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbZK3UGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbZK3UGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZK3UGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:06:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZK3UGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:06:50 -0500
Date: Mon, 30 Nov 2009 21:00:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Veaceslav Falico <vfalico@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com, Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: powerpc: syscall_dotrace() && retcode (Was: powerpc: fork &&
	stepping)
Message-ID: <20091130200056.GA11764@redhat.com>
References: <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com> <20091126202312.GA21945@redhat.com> <19214.63688.860929.962005@cargo.ozlabs.ibm.com> <20091126223703.GA28556@redhat.com> <20091127174627.GB26193@darkmag.usersys.redhat.com> <20091128073049.GD23108@in.ibm.com> <20091129210716.GA19205@redhat.com> <1259536501.2076.39.camel@pasglop> <1259541801.2076.44.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259541801.2076.44.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30, Benjamin Herrenschmidt wrote:
>
> On Mon, 2009-11-30 at 10:15 +1100, Benjamin Herrenschmidt wrote:
>
> > Yes, the asm should be changed. I suppose we could check if the result
> > of do_syscall_trace_enter is negative, and if it is, branch to the exit
> > path using r3 as the error code. Would that be ok ?
> >
> > Something like this:
>
> Note however that there's a trace exit too and that's normally the right
> place to alter the result don't you think ?

Yes, the result can be changed when the tracee reports syscall-exit.

Should powerpc allow this on syscall-entry? I do not know. x86 does,
and we have this test-case which assumes powerpc should allow too.
But when it comes to ptrace I can almost never know what was the
supposed behaviour/api.

Jan, Roland, what do you think?

Oleg.

