Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbZLRWip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbZLRWip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932882AbZLRWio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:38:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737AbZLRWio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:38:44 -0500
Date: Fri, 18 Dec 2009 23:32:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218223230.GA1853@redhat.com>
References: <20091218005650.GA20667@redhat.com> <20091218030601.GB16470@nowhere> <20091218172747.GA10924@redhat.com> <20091218200503.2CA0DF9A4@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218200503.2CA0DF9A4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Roland McGrath wrote:
>
> > Please find the trivial test-case below. It hangs, because
> > PTRACE_SINGLESTEP doesn't trigger the trap.
>
> 2.6.33-rc1 x86-64 works for me with either -m64 or -m32 version of that test.
>
> > (not sure this matters, but I did the testing under kvm)
>
> Apparently it does.  You should hack some printks into do_debug() and see
> how kvm is differing from real hardware.  (Actually you can probably do
> this with a notifier added by a module, not that you are shy about
> recompiling!)
>
> Probably kvm's emulation of the hardware behavior wrt the DR6 bits is not
> sufficiently faithful.  Conceivably, kvm is being consistent with some
> older hardware and we have encoded assumptions that only newer hardware
> meets.  But I'd guess it's just a plain kvm bug.

OK, thanks.

Hmm. Now I see how wrong I was when I said this code is "obviously wrong" ;)

I'll add the debugging printk's and report the output. Sorry for delay,
can't do this today.

Oleg.

