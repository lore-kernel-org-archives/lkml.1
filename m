Return-Path: <linux-kernel-owner+w=401wt.eu-S932334AbZHJRIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbZHJRIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZHJRIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:08:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43129 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762AbZHJRIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:08:43 -0400
Date: Mon, 10 Aug 2009 19:03:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: stephane eranian <eranian@googlemail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: F_SETOWN_TID: F_SETOWN was thread-specific for a while
Message-ID: <20090810170338.GA14223@redhat.com>
References: <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com> <20090809054601.GA26152@shareable.org> <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10, stephane eranian wrote:
>
> You must use F_SETSIG on SIGIO if you want your signal handler to
> receive the file descriptor in siginfo. This is useful if you want to perform
> some actions on the descriptor. That is the case in perfmon and this is
> the case in certain situations with perfcounters as well.
>
> Setting SA_SIGINFO provides siginfo, but the si_fd field is NOT set
> correctly without F_SETSIG. I have verified this with perfcounters, and
> this is indeed the case.
>
> This behavior seems kind of odd to me.

Agreed, this looks a bit odd. But at least this is documented. From
man 2 fcntl:

	By using F_SETSIG with a nonzero value, and setting SA_SIGINFO for the
	signal handler (see sigac- tion(2)), extra information about I/O events
	is passed to the handler in a  siginfo_t  structure.  If  the si_code
	field indicates the source is SI_SIGIO, the si_fd field gives the file
	descriptor associated with the event.  Otherwise, there is no indication
	which file descriptors are pending,

Not sure if it is safe to change the historical behaviour.

(the manpage is not exactly right though, and the comment in send_sigio_to_task()
 is not right too: SI_SIGIO (and, btw, SI_QUEUE/SI_DETHREAD) is never used).

Oleg.

