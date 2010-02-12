Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0BLPZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:25:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab0BLPZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:25:07 -0500
Date: Fri, 12 Feb 2010 16:24:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] Blackfin: initial tracehook support
Message-ID: <20100212152404.GA9410@redhat.com>
References: <20100202185907.GE3630@lst.de> <1265881389-26925-2-git-send-email-vapier@gentoo.org> <20100211204653.34BB3900@magilla.sf.frob.com> <8bd0f97a1002111554ib69bd48rc3c5f4af65058281@mail.gmail.com> <20100212032406.BE645C81B@magilla.sf.frob.com> <8bd0f97a1002112033m5805d4eco3add4d5625e71e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1002112033m5805d4eco3add4d5625e71e9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Mike Frysinger wrote:
>
> On Thu, Feb 11, 2010 at 22:24, Roland McGrath wrote:
>
> > On some machines, single-step into a syscall instruction is no different
> > from other user instructions, so the normal SIGTRAP will come afterwards
> > anyway.
> >
> > On other machines, entering the kernel for the syscall instruction defeats
> > the normal user-mode effects of single-step being enabled.  In that event,
> > you want to call tracehook_report_syscall_exit() if single-step is enabled.
> > You must pass a nonzero second argument if your arch code is not going to
> > generate the normal SIGTRAP associated with having single-stepped into the
> > syscall instruction.
>
> so tracehook_report_syscall_exit() checking TIF_SINGLESTEP only makes
> sense when the arch doesnt support hardware single stepping in user
> mode ?  the Blackfin processor does support hardware single stepping
> (and we utilize it in Linux).

I'd like to know the answer too ;)

But, even if x86 supports hardware single stepping, it does check
TIF_SINGLESTEP and pass it to tracehook_report_syscall_exit(step).

Consider PTRACE_SINGLESTEP which follows the syscall-entry stop.
The tracee gets the trap before return to user-mode. Otherwise,
if we just return with X86_EFLAGS_TF, it gets the trap after the
next instruction after syscall insn. But I don't know whether
blackfin should follow this logic.

> also, in reading the kerneldocs for tracehook_report_syscall_exit(),
> it says "an attempted system call".  should system calls greater than
> NR_syscall (-ENOSYS) also get traced ?

I'd say yes, but let's wait for Roland's reply.

Oleg.

