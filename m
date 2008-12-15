Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYLOLE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYLOLE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYLOLEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:04:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54431 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbYLOLET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:04:19 -0500
Date: Mon, 15 Dec 2008 12:02:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: broken do_each_pid_{thread,task}
Message-ID: <20081215110238.GA15606@redhat.com>
References: <494581D7.6000203@gmail.com> <20081215102415.GA11106@redhat.com> <49463679.7080306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49463679.7080306@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15, Jiri Slaby wrote:
>
> Oleg Nesterov napsal(a):
> > On 12/14, Jiri Slaby wrote:
> >> I'm getting
> >> `if (type == PIDTYPE_PID)' is unreachable
> >> warning from kernel/exit.c. The preprocessed code looks like:
> >> do {
> >>          struct hlist_node *pos___;
> >>          if (pgrp != ((void *)0))
> >>                  for (LIST ITERATION) {
> >>                          {
> >>                           if (!((p->state & 4) != 0))
> >>                            continue;
> >>                           retval = 1;
> >>                           break;
> >>                          }
> >>                          if (PIDTYPE_PGID == PIDTYPE_PID)
> >>                                  break;
> >>                  }
> >> } while (0);
> >> and it's obviously wrong.
> >
> > Why do you think it is wrong? This break stops the "hlist_for_each"
> > loop, not the enclosing "do while".
>
> The `continue' matters here (and also in other do_each_pid_task cases).
> Sorry for not mentioning it explicitly.

Still can't understand... OK, I think we misundersood each other.
Do you agree that the code is technically correct? Or I missed
something?

"continue" looks fine to me too, it is also for the inner loop.

> > Actually, I don't understand why the compiler complains, and I never
> > saw a warning myself.
>
> Because the `if' is not reachable :).

Yes, I see it is not reachable, but I don't understand why this
deserves a warning ;)

Look, "if (PIDTYPE_PGID == PIDTYPE_PID)" is not possible too, should
the compiler (or whatever) complain?
	
> (And it's not compiler which complains
> here.)

Ah, OK, thanks. Just curious, and who does?

> > Yes, this is obviously not what was intended. But afaics, this is
> > the only place which should be fixed?
>
> Actually yes. And add a big warning to the macros or whatever to not get
> into it later again.

Agreed.

Oleg.

