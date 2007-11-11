Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbXKKRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbXKKRWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 12:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXKKRWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 12:22:12 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43206 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbXKKRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 12:22:11 -0500
Date: Sun, 11 Nov 2007 12:11:07 -0500
Message-Id: <200711111711.lABHB7xo002409@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] kernel/capability.c get_task_comm compile error (MMOTM) 
In-reply-to: Your message of "Sun, 11 Nov 2007 15:15:10 +0100."
             <20071111141510.GA29126@elte.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071111141510.GA29126@elte.hu>, Ingo Molnar writes:
> 
> * Erez Zadok <ezk@cs.sunysb.edu> wrote:
> 
> > Small patch below fixes compile error.
> 
> > +			char name[sizeof(current->comm)];
> >  			warned++;
> >  			printk(KERN_INFO
> >  			       "warning: process `%s' sets w/ old libcap\n",
> > -			       get_task_comm(current));
> > +			       get_task_comm(name, current));
> 
> that's buggy - get_task_comm() returns void.
> 
> the proper fix would be to first do a get_task_comm() then pass in 
> 'name' as an argument to printk.
> 
> 	Ingo

Ingo, I don't see how it can return NULL.  This is what get_task_comm looks
like in MMOTM-2007-11-10-19-05:

char *get_task_comm(char *buf, struct task_struct *tsk)
{
	/* buf must be at least sizeof(tsk->comm) in size */
	task_lock(tsk);
	strncpy(buf, tsk->comm, sizeof(tsk->comm));
	task_unlock(tsk);
	return buf;
}

The only way it'd return NULL is if a null buf was passed, in which case the
strncpy will oops first.

Erez.
