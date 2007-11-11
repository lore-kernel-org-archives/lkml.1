Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbXKKUp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbXKKUp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbXKKUpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:45:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbXKKUpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:45:15 -0500
Date: Sun, 11 Nov 2007 21:44:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] kernel/capability.c get_task_comm compile error (MMOTM)
Message-ID: <20071111204419.GA18829@elte.hu>
References: <20071111141510.GA29126@elte.hu> <200711111711.lABHB7xo002409@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711111711.lABHB7xo002409@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Erez Zadok <ezk@cs.sunysb.edu> wrote:

> Ingo, I don't see how it can return NULL.  This is what get_task_comm 
> looks like in MMOTM-2007-11-10-19-05:
> 
> char *get_task_comm(char *buf, struct task_struct *tsk)
> {
> 	/* buf must be at least sizeof(tsk->comm) in size */
> 	task_lock(tsk);
> 	strncpy(buf, tsk->comm, sizeof(tsk->comm));
> 	task_unlock(tsk);
> 	return buf;
> }
> 
> The only way it'd return NULL is if a null buf was passed, in which 
> case the strncpy will oops first.

hm, here it says in include/linux/sched.h:

 extern void get_task_comm(char *to, struct task_struct *tsk);

HEAD ecd744eec3a.

	Ingo
