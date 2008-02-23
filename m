Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbYBWPhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbYBWPhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYBWPhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:37:31 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60677 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYBWPha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:37:30 -0500
Date: Sat, 23 Feb 2008 09:36:58 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: simplify signal check
Message-ID: <20080223153658.GA26634@sergelap.austin.ibm.com>
References: <20080220161550.GA14630@sergelap.austin.ibm.com> <20080223000243.e6efb30f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223000243.e6efb30f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 20 Feb 2008 10:15:50 -0600 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > >From bd076c7245d02be0cc01b7c09bd7170ec5946492 Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Sun, 17 Feb 2008 20:28:07 -0500
> > Subject: [PATCH 1/1] file capabilities: simplify signal check
> > 
> > Simplify the uid equivalence check in cap_task_kill().  Anyone
> > can kill a process owned by the same uid.
> > 
> > Without this patch wireshark is reported to fail.
> 
> Strange that a patch titled "simplify...." actually fixes a bug.

Sorry.  Yeah that's a bad subject.

> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
> > ---
> >  security/commoncap.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 5aba826..bb0c095 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -552,7 +552,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
> >  	 * allowed.
> >  	 * We must preserve legacy signal behavior in this case.
> >  	 */
> > -	if (p->euid == 0 && p->uid == current->uid)
> > +	if (p->uid == current->uid)
> >  		return 0;
> >  
> >  	/* sigcont is permitted within same session */
> 
> I've marked this as needed-in-2.6.24.  Was that appropriate?

Yes, thanks.  I doubt wireshark is the only thing that'll break
otherwise.

thanks,
-serge
