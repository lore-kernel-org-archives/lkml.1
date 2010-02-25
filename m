Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab0BYCOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:14:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758782Ab0BYCOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:14:14 -0500
Date: Wed, 24 Feb 2010 18:13:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] supress uid comparison test if core output files are
 pipes
Message-Id: <20100224181332.5cdc2454.akpm@linux-foundation.org>
In-Reply-To: <20100225013210.GA10527@localhost.localdomain>
References: <20100222200851.GD3344@hmsreliant.think-freely.org>
	<20100224135053.e75800c1.akpm@linux-foundation.org>
	<20100225013210.GA10527@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010 20:32:10 -0500 Neil Horman <nhorman@tuxdriver.com> wrote:

> > > diff --git a/fs/exec.c b/fs/exec.c
> > > index 6303d18..6af2214 100644
> > > --- a/fs/exec.c
> > > +++ b/fs/exec.c
> > > @@ -1987,8 +1987,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> > >  	/*
> > >  	 * Dont allow local users get cute and trick others to coredump
> > >  	 * into their pre-created files:
> > > +	 * Note, this is not relevant for pipes
> > >  	 */
> > > -	if (inode->i_uid != current_fsuid())
> > > +	if (!ispipe && (inode->i_uid != current_fsuid()))
> > >  		goto close_fail;
> > >  	if (!cprm.file->f_op)
> > >  		goto close_fail;
> > 
> > hm, this actually appears to fix a regression, added by:
> > 
> In a sense yes.  Previously though, Ingos check was both useless for pipes
> (since you can't have a user create a pipe that will map to what the coredump
> path creates anyway, making this check useless), but it worked anyway, since the
> crashing process created the pipe, so the uid check always matched.  With the
> refactoring andi and I did, thats no longer true, so the check could fail.  This
> patch just fixes it up by recongnizing that the check isn't needed at all for
> pipes

Which refactoring?  Please identify precisely the patch which this patch fixes up?
