Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0BHStQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:49:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:48164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0BHStO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:49:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,431,1262592000"; 
   d="scan'208";a="594129386"
Subject: Re: PATCH? process_32.c:__switch_to() calls __math_state_restore()
 before updating current_task
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100205124407.GA24974@redhat.com>
References: <20100204165105.GA5905@redhat.com>
	 <1265305253.2768.7.camel@sbs-t61.sc.intel.com>
	 <20100205124407.GA24974@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 08 Feb 2010 10:48:10 -0800
Message-Id: <1265654890.2843.27.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 04:44 -0800, Oleg Nesterov wrote:
> Could you please explain me another issue? I know nothing about fpu
> handling, I am reading this code trying to understand the unrelated
> bug with the old kernel.
> 
> In short: why restore_i387_xstate() does init_fpu() when !used_math(),
> can't (or shouldn't) it merely do set_used_math() ?
> 
> 	restore_i387_xstate:
> 		
> 		if (!used_math()) {
> 			err = init_fpu(tsk);
> 			if (err)
> 				return err;
> 		}
> 
> note that buf != NULL. This means that used_math() was true when
> get_sigframe() was called, otherwise buf == sigcontext->fpstate
> would be NULL, right?

No. When the signal is delivered sigcontext->fpstate can be null and
when we return from the signal handler, user can update the
sigcontext->fpstate pointer and the user expects the kernel to update
the fpstate of the process accordingly.

> So, the task must have the valid ->thread.xstate, 

Need not be.

thanks,
suresh

