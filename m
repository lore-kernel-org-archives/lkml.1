Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbZKBRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbZKBRkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZKBRkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:40:36 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57248 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbZKBRkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:40:36 -0500
Date: Mon, 2 Nov 2009 12:40:29 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH 2/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091102174029.GD4075@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091020005412.GC8886@localhost.localdomain> <20091102151032.GF23776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102151032.GF23776@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:10:32PM +0100, Ingo Molnar wrote:
> 
> two small comments:
> 
> this is a really dangerous pattern:
> 
> > +	if (!lock_task_sighand(tsk, &flags))
> > +		goto out_put_all;
> > +
> 
> as it's followed by:
> 
> > +	else {
> > +		struct rlimit val;
> > +
> > +		task_lock(tsk->group_leader);
> > +		val = current->signal->rlim[resource];
> > +		task_unlock(tsk->group_leader);
> > +		retval = copy_to_user(rlim, &val, sizeof(*rlim)) ? -EFAULT : 0;
> > +	}
> 
> please turn that into the regular:
> 
> 	if () {
> 		...
> 	} else {
> 		...
> 	}
> 
> pattern that is a lot harder to mess up later on.
> 
Yeah, ok, I can do that.

> > +	return retval;
> > +}
> > +
> > +
> >  #ifdef __ARCH_WANT_SYS_OLD_GETRLIMIT
> 
> one too many newlines?
> 
Probably, I'll trim it.  Thanks.
Neil

> 	Ingo
> 
