Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0BFMJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 07:09:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0BFMJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 07:09:16 -0500
Date: Sat, 6 Feb 2010 13:08:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? process_32.c:__switch_to() calls __math_state_restore()
	before updating current_task
Message-ID: <20100206120815.GB22280@redhat.com>
References: <20100204165105.GA5905@redhat.com> <1265305253.2768.7.camel@sbs-t61.sc.intel.com> <20100205124407.GA24974@redhat.com> <20100206120640.GA22280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100206120640.GA22280@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Oleg Nesterov wrote:
>
> On 02/05, Oleg Nesterov wrote:
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
> >
> > So, the task must have the valid ->thread.xstate,
>
> This is probably correct. But a malicious user can set sc->fpsate
> and fool the kernel, so we must assume buf != NULL implies the
                             ^^^^
                             can't
> valid ->xstate.

Oleg.

