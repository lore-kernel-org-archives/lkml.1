Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbXKSNm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbXKSNm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXKSNms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:42:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbXKSNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:42:48 -0500
Date: Mon, 19 Nov 2007 14:39:46 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: Chris Friedhoff <chris@friedhoff.org>
Cc: "Serge E. Hallyn" <sergeh@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Posix file capabilities in 2.6.24rc2; now 2.6.24-rc3
Message-Id: <20071119143946.b0664b6c.chris@friedhoff.org>
In-Reply-To: <20071115230227.9dabbb5f.chris@friedhoff.org>
References: <20071113230720.22c6a036.chris@friedhoff.org>
	<20071113235318.GA6477@sergelap.austin.ibm.com>
	<20071114101251.a1f6214d.chris@friedhoff.org>
	<20071114180235.GA25344@sergelap.austin.ibm.com>
	<20071115230227.9dabbb5f.chris@friedhoff.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.10.14; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX185jhQChSCmQwzfgqg0bxJkV93BdH4jZJVkEV3
 fJYuEr29LQ6+ss3m8YuwLXHYDMTPsVEKMdZ4LTWCdZOjH5getd
 9Ow08i5+HTCnHPqAtkTkN0dziMQUJZX
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Serge,

just to let you know: with 2.6.24-rc3 I have the same problem.

Chris


On Thu, 15 Nov 2007 23:02:27 +0100
Chris Friedhoff <chris@friedhoff.org> wrote:

> No, the patch doesn't fix the problem.
> I still have the black screen with the cursor when I close the
> xsession, only the windowmanager is closed.
> consolemessage:
> xinit:  Operation not permitted (errno 1): Can't kill X server
> kernel has capabilities, xinit has no caps granted.
> 
> Chris
> 
> 
> > I'm setting up a vm to play with this.  Will look into it.
> > 
> > Oh, looking at a few branches, I see that the patch for bug# 9247
> > (on bugzilla.kernel.org) isn't in 2.6.24-rc2 yet.  Can you check
> > whether the following patch fixes it?
> > 
> > thanks,
> > -serge
> > 
> > >From 347faf5852644b91632813885784104f4cdb640a Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Wed, 14 Nov 2007 13:00:52 -0500
> > Subject: [PATCH 1/1] file capabilities: allow sigcont within session (v2.6.24-rc2)
> > 
> > Allow sigcont to be sent to a process with greater capabilities
> > if it is in the same session.  Otherwise, a shell from which
> > I've started a root shell and done 'suspend' can't be restarted
> > by the parent shell.
> > 
> > (this patch against v2.6.24-rc2)
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  security/commoncap.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index bf67871..c9f6867 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -534,6 +534,8 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
> >  		 * Used only by usb drivers?
> >  		 */
> >  		return 0;
> > +	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
> > +		return 0;
> >  	if (cap_issubset(p->cap_permitted, current->cap_permitted))
> >  		return 0;
> >  	if (capable(CAP_KILL))
> > -- 
> > 1.5.1.1.GIT
> 
> 
> --------------------
> Chris Friedhoff
> chris@friedhoff.org


--------------------
Chris Friedhoff
chris@friedhoff.org
