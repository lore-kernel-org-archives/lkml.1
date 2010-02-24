Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0BXLug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:50:36 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41874 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab0BXLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:50:35 -0500
Date: Wed, 24 Feb 2010 06:50:08 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] supress uid comparison test if core output files are
 pipes
Message-ID: <20100224115008.GA15380@hmsreliant.think-freely.org>
References: <20100222200851.GD3344@hmsreliant.think-freely.org>
 <20100224110903.GA18240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224110903.GA18240@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 12:09:03PM +0100, Oleg Nesterov wrote:
> On 02/22, Neil Horman wrote:
> >
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1987,8 +1987,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  	/*
> >  	 * Dont allow local users get cute and trick others to coredump
> >  	 * into their pre-created files:
> > +	 * Note, this is not relevant for pipes
> >  	 */
> > -	if (inode->i_uid != current_fsuid())
> > +	if (!ispipe && (inode->i_uid != current_fsuid()))
> >  		goto close_fail;
> 
> Ah. This is because the previous recursion-check moved create_write_pipe()
> from current's context to kthread's context, right?
> 
Yes, thats correct.

> Looks like a right (and "must have") fix for recent -mm changes to me.
> 
Also correct.

> 
> 
> This also reminds me do_coredump() asks for cleanup. I'll try to redo/resend
> my old cleanup patches on top of your changes.
> 
Cool, thanks!
Neil

> Oleg.
> 
> 
