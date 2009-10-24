Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZJXI1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZJXI1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 04:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZJXI1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 04:27:08 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:21423 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZJXI1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 04:27:06 -0400
Message-ID: <4AE2BA5E.3020104@miraclelinux.com>
Date: Sat, 24 Oct 2009 17:27:10 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: akpm@linux-foundation.org, oleg@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
References: <4AE1804A.2050404@miraclelinux.com> <20091023210707.EDA87AFC4@magilla.sf.frob.com>
In-Reply-To: <20091023210707.EDA87AFC4@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

Thank you for your reply.

 > This seems to me primarily like a failure of
 > documentation.

You just said it. At first, I thought it.

 > That description is basically content-free, it applies equally to any
 > potential error from any call.

The reality is, the man-pages has been summary.


 > If you'd asked me off hand what EAGAIN from timer_create could mean, I
 > would have told you right off that you have too many timers or too many
 > aggregate queued signals.

This idea is for system engineeres, not kernel developers.
In this case, I found this cause soon, because I could reproduce
this phenomenon.
But when it run into this limit occasionally, we can't obtain
any solid physical evidence. On the contrary, It's OK.

If application don't see error value or nobody debugging by strace,
we just no way. We get yelled at by customer.

So I thought this logging.


PS,
Now I have one idea.
When the TCP socket is not called close(), sometimes it countinue to 
stay in kernel as FIN_WAIT2 state. I'm understanding why it's happened.
But I think it is same problem.


Thank you
Naohiro Ooiwa.


Roland McGrath wrote:
> I have nothing in particular against the logging.  (However, to me it seems
> a little odd to use system-wide logging for normal well-defined error cases
> of individual programs.)  This seems to me primarily like a failure of
> documentation.
> 
> If you'd asked me off hand what EAGAIN from timer_create could mean, I
> would have told you right off that you have too many timers or too many
> aggregate queued signals.  I'm a person who would happen to know, of
> course.  But also, if you look in POSIX.1 for the timer_create definition,
> under ERRORS it says:
> 
>       [EAGAIN] The system lacks sufficient signal queuing resources to
>       	       honor the request.
>       [EAGAIN] The calling process has already created all of the timers it
>       	       is allowed by this implementation.
> 
> Now that is a little vague about it potentially relating to the
> RLIMIT_SIGPENDING limit (which is not a POSIX.1 feature, though exactly the
> sort of thing permitted by the "is allowed by this implementation" clause).
> But it certainly points you in some reasonable directions so this doesn't
> seem like it would be such a mystery.
> 
> But it's certainly unfortunate that man-pages-3.19 for timer_create has only:
> 
>        -EAGAIN
>               The system could not process the request.
> 
> That description is basically content-free, it applies equally to any
> potential error from any call.
> 
> 
> Thanks,
> Roland

