Return-Path: <linux-kernel-owner+w=401wt.eu-S941428AbYCSWbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941428AbYCSWbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936003AbYCSVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:04:34 -0400
Received: from smtp109.sbc.mail.re2.yahoo.com ([68.142.229.96]:36641 "HELO
	smtp109.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763826AbYCSVEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:04:32 -0400
X-YMail-OSG: vaJtqKAVM1kIpNq.J3msqDUHHOOTbbHToznMMyPbEuwX618ZOsh8fFq.zXdzDqHAEhE74UdBnKf7ZvlBu1ICDM6DFzDQNBzfg6q4RpDG1ORFtnbsqg--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 18 Mar 2008 18:14:39 -0500
From: serge@hallyn.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: serge@hallyn.com, Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: check session under
	tasklist_lock
Message-ID: <20080318231439.GA24419@vino.hallyn.com>
References: <20080304185745.GA8482@tv-sign.ru> <47DE5665.2030802@bk.jp.nec.com> <20080317170124.GA115@tv-sign.ru> <20080318144431.GA3384@tv-sign.ru> <20080318200304.GA23859@vino.hallyn.com> <20080318201725.GA92@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318201725.GA92@tv-sign.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@tv-sign.ru):
> On 03/18, serge@hallyn.com wrote:
> >
> > Quoting Oleg Nesterov (oleg@tv-sign.ru):
> > > --- 25/security/commoncap.c~CKP_TAKE_TASKLIST	2008-03-18 17:07:02.000000000 +0300
> > > +++ 25/security/commoncap.c	2008-03-18 17:21:10.000000000 +0300
> > > @@ -552,10 +552,6 @@ int cap_task_kill(struct task_struct *p,
> > >  	if (p->uid == current->uid)
> > >  		return 0;
> > >  
> > > -	/* sigcont is permitted within same session */
> > > -	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
> > > -		return 0;
> > > -
> > >  	if (secid)
> > >  		/*
> > >  		 * Signal sent as a particular user.
> > 
> > Note that cap_task_kill() should be gone anyway.  What tree were you
> > basing this on?
> 
> Ah. I realy hoped that cap_task_kill() was already killed. And I googled
> this patch: http://marc.info/?l=linux-kernel&m=120422062515386
> 
> But I checked 2.6.25-rc5-mm1.bz2, it is still here. And I didn't find
> anything related in http://userweb.kernel.org/~akpm/mmotm/. I even checked
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=security/commoncap.c
> 
> So, is it still here or killed? If it is dead - great ;)

Hmm, I thought it had been pulled in.  I don't see it.  I'll re-spin and
re-send against -mm, -stable, and -git.

thanks,
-serge
