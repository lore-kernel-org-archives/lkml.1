Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0BHU2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:28:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab0BHU2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:28:52 -0500
Date: Mon, 8 Feb 2010 21:26:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? process_32.c:__switch_to() calls __math_state_restore()
	before updating current_task
Message-ID: <20100208202652.GA27043@redhat.com>
References: <20100204165105.GA5905@redhat.com> <1265305253.2768.7.camel@sbs-t61.sc.intel.com> <20100205124407.GA24974@redhat.com> <1265654890.2843.27.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265654890.2843.27.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Suresh Siddha wrote:
>
> On Fri, 2010-02-05 at 04:44 -0800, Oleg Nesterov wrote:
> > Could you please explain me another issue? I know nothing about fpu
> > handling, I am reading this code trying to understand the unrelated
> > bug with the old kernel.
> >
> > In short: why restore_i387_xstate() does init_fpu() when !used_math(),
> > can't (or shouldn't) it merely do set_used_math() ?
> >
> > 	restore_i387_xstate:
> >
> > 		if (!used_math()) {
> > 			err = init_fpu(tsk);
> > 			if (err)
> > 				return err;
> > 		}
> >
> > note that buf != NULL. This means that used_math() was true when
> > get_sigframe() was called, otherwise buf == sigcontext->fpstate
> > would be NULL, right?
>
> No. When the signal is delivered sigcontext->fpstate can be null and
> when we return from the signal handler, user can update the
> sigcontext->fpstate pointer

Yes, I already realized this, see my next emails.

> and the user expects the kernel to update
> the fpstate of the process accordingly.

but I didn't know it is "officially" allowed to populate .xstate
this way.


Thanks Suresh for your explanations.

Oleg.

