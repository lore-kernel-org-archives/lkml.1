Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZDXRpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZDXRpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZDXRpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:45:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40982 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbZDXRpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:45:22 -0400
Date: Fri, 24 Apr 2009 19:41:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: Q: ptrace_signal() && PTRACE_SETSIGINFO (Was: SIGSTOP &&
	ptrace)
Message-ID: <20090424174140.GA15020@redhat.com>
References: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com> <20090423142627.GA31572@redhat.com> <20090423151633.GA3120@redhat.com> <20090424063159.BCEDAFC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424063159.BCEDAFC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Roland McGrath wrote:
>
> > Yes. PTRACE_SETSIGINFO can change *info if debugger wants something
> > special. But then we do:
> >
> > 	if (signr != info->si_signo) {
> > 		info->si_signo = signr;
> [...]
> > Why? If the tracer changes ->exit_code it should know what it does.
>
> If it uses PTRACE_SETSIGINFO it should know what it does, and update
> the siginfo_t to match the signal it passes to PTRACE_CONT et al.
>
> > Why do we reset *info?
>
> PTRACE_SETSIGINFO did not always exist, and even now might not be used by a
> simple-minded application.  If the user is sophisticated, it calls
> PTRACE_SETSIGINFO and then passes the signal number to match.  If not, it
> never calls PTRACE_SETSIGINFO at all, but expects the signal number it
> chose to pass in PTRACE_CONT to behave "normally" in the tracee.

OK, understand.

> > But the real question, how can PTRACE_SETSIGINFO change ->si_signo
> > (for example, for do_signal_stop(si_signo)) if this in fact is not
> > allowed?
>
> It's allowed.  You just have to pass the same value you set in si_signo as
> the argument to PTRACE_CONT after you do PTRACE_SETSIGINFO.

Yes, yes, I see. I meant "the tracer can not use signr != ->si_signo",
but now I don't see the reason it should.

Oleg.

