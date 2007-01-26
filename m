Return-Path: <linux-kernel-owner+w=401wt.eu-S965628AbXAZJdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965628AbXAZJdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 04:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965618AbXAZJdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 04:33:15 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45874 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965620AbXAZJdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 04:33:14 -0500
Date: Fri, 26 Jan 2007 10:32:08 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: + make-good_sigevent-non-static.patch added to -mm tree
Message-ID: <20070126103208.78c4937f@frecb000686>
In-Reply-To: <20070125154324.GA183@tv-sign.ru>
References: <20070125154324.GA183@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/01/2007 10:34:00,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/01/2007 10:34:01,
	Serialize complete at 26/01/2007 10:34:01
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 18:43:24 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> SИbastien DuguИ wrote:
> >
> > +struct task_struct *good_sigevent(sigevent_t *event)
> > +{
> > +	struct task_struct *task = current->group_leader;
> > +
> > +	if ((event->sigev_notify & SIGEV_THREAD_ID) == SIGEV_THREAD_ID) {
> > +		task = find_task_by_pid(event->sigev_notify_thread_id);
> > +
> > +		if (!task || task->tgid != current->tgid)
> > +			return NULL;
> > +	} else if (event->sigev_notify == SIGEV_SIGNAL) {
> 
> No, no, we can't use "else" here,
> 
> > +		if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)
> 
> because we skip the check above in SIGEV_THREAD_ID case.

  Right, will fix this.

> 
> This way any user can crash the kernel with a minimal effort.

  Well I tried, no crash, just the signal failing to be delivered.

  Thanks,

  Sébastien.
