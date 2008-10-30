Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYJ3RKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYJ3RKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYJ3RKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:10:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbYJ3RKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:10:22 -0400
Date: Thu, 30 Oct 2008 19:10:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bert Wesarg <bert.wesarg@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Strange stop-signal behavior in multithreaded program with
	defunct main
Message-ID: <20081030181051.GB11521@redhat.com>
References: <4907E6B9.8080700@gmail.com> <20081030110000.GA3767@redhat.com> <cfd18e0f0810300855w6e14bb81gfacd33d6bcb103b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0810300855w6e14bb81gfacd33d6bcb103b5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30, Michael Kerrisk wrote:
>
> On Thu, Oct 30, 2008 at 6:00 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 10/28, Michael Kerrisk wrote:
> >>
> >> Bert Wesarg described a scenario that I quickly replicated on
> >> 2.6.28-rc2 (and 2.6.25 -- it's not a regression in 2.6.28-rc)
> >> using the program below: if we have a multithreaded process
> >> with a defunct main thread running on a tty, and that
> >> process is sent a stop signal (either ^Z (SIGTSTP) or a stop
> >> signal sent from another terminal using kill(1)), then:
> >>
> >> a) the terminal is locked up; and
> >>
> >> b) the program is unresponsive to any other signal, except SIGKILL
> >> or SIGCONT.
> >
> > Yes, known problem. Please look at
> >
> >        [RFC,PATCH 3/3] do_wait: fix waiting for stopped group with dead leader
> >        http://marc.info/?t=119713920000003
> 
> Okay -- thanks for the info.  I've added some text to man-pages to
> cover this bug.

Well, we should fix this bug, of course.

I'll try to redo my old patch, but fyi I am very busy right now, and
most probably I will be completely offline during the next week.

Oleg.

