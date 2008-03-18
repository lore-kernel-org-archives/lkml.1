Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbYCSW7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbYCSW7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936949AbYCSVYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:15 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966325AbYCSVYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:14 -0400
Date: Tue, 18 Mar 2008 23:17:25 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: serge@hallyn.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: check session under tasklist_lock
Message-ID: <20080318201725.GA92@tv-sign.ru>
References: <20080304185745.GA8482@tv-sign.ru> <47DE5665.2030802@bk.jp.nec.com> <20080317170124.GA115@tv-sign.ru> <20080318144431.GA3384@tv-sign.ru> <20080318200304.GA23859@vino.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318200304.GA23859@vino.hallyn.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, serge@hallyn.com wrote:
>
> Quoting Oleg Nesterov (oleg@tv-sign.ru):
> > --- 25/security/commoncap.c~CKP_TAKE_TASKLIST	2008-03-18 17:07:02.000000000 +0300
> > +++ 25/security/commoncap.c	2008-03-18 17:21:10.000000000 +0300
> > @@ -552,10 +552,6 @@ int cap_task_kill(struct task_struct *p,
> >  	if (p->uid == current->uid)
> >  		return 0;
> >  
> > -	/* sigcont is permitted within same session */
> > -	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
> > -		return 0;
> > -
> >  	if (secid)
> >  		/*
> >  		 * Signal sent as a particular user.
> 
> Note that cap_task_kill() should be gone anyway.  What tree were you
> basing this on?

Ah. I realy hoped that cap_task_kill() was already killed. And I googled
this patch: http://marc.info/?l=linux-kernel&m=120422062515386

But I checked 2.6.25-rc5-mm1.bz2, it is still here. And I didn't find
anything related in http://userweb.kernel.org/~akpm/mmotm/. I even checked
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=security/commoncap.c

So, is it still here or killed? If it is dead - great ;)

Oleg.

