Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0BAKkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:40:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0BAKke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:40:34 -0500
Date: Mon, 1 Feb 2010 11:39:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jmoskovc@redhat.com, mingo@redhat.com, drbd-dev@lists.linbit.com,
       benh@kernel.crashing.org, t.sailer@alumni.ethz.ch, abelay@mit.edu,
       gregkh@suse.de, spock@gentoo.org, viro@zeniv.linux.org.uk,
       neilb@suse.de, mfasheh@suse.com, menage@google.com,
       shemminger@linux-foundation.org, takedakn@nttdata.co.jp
Subject: Re: [PATCH 2/2] exec: allow core_pipe recursion check to look for
	a value of 1 rather than 0 (v2)
Message-ID: <20100201103933.GA32188@redhat.com>
References: <20100121200806.GA29801@shamino.rdu.redhat.com> <20100129151024.GA19249@hmsreliant.think-freely.org> <20100129151458.GC19249@hmsreliant.think-freely.org> <20100131155000.GB13402@redhat.com> <20100131160030.GB1950@localhost.localdomain> <20100201102936.GA31611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201102936.GA31611@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Oleg Nesterov wrote:
>
> Oh. And in theory, it is better to change wait_for_helper(). It should
> do allow_signal(SIGCHLD) after kernel_thread(). Otherwise, kernel_thread()
> can fail if user-space sends SIGCHLD to the forking thread.

Well ;) And since allow_signal(SIGCHLD) was called, in theory we should
call sys_wait4() + clear_thread_flag(TIF_SIGPENDING) in a loop to protect
against the false SIGCHLD.

> > > Cough. And why call_usermodehelper_exec() has this strange ->path[0] == '\0'
> > > check?
> > >
> > That I can't explain.  I figured I'd let that sleeping dog lie until this got
> > striaghtened out and fix it separately if it needed it
> > Neil
>
> Yes, yes, agreed. As I said, this has nothing to do with this series,
> even if I am right these (minor) bugs should be fixed separately.

Yes.

Oleg.

