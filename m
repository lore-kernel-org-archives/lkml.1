Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYIZNEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYIZNEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYIZNEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:04:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51243 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYIZNEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:04:38 -0400
Date: Fri, 26 Sep 2008 08:04:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
Message-ID: <20080926130409.GA14055@us.ibm.com>
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC7553.8040708@nttdata.co.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Serge E. Hallyn wrote:
> > > So IMO there is some major badness here in the form of copying all of
> > > those functions out of fs/namei.c.  I think we need to discuss
> > > case-by-case whether using the functions is appropriate (and hence
> > > they should be made non-static in fs/namei.c), or whether the intended
> > > goal should be met some other way.  For instance:
> Indeed.
> 
> To perform DAC before MAC, cloning DAC code (like this patch) or some
> modifications against existing kernel code (such as non-static
> may_open()) are needed.
> 
> This posting is the result of our intention that all changes should
> be within security/* . We are now aiming TOMOYO Linux to be merged
> without messing up the existing kernel code. (Also we put the code of
> singly linked list TOMOYO Linux uses not in include/linux/list.h but
> in security/tomoyo/common.h to avoid recomplilation.)
> 
> We are ready to remove DAC code in TOMOYO Linux LSM module for now.
> (But DAC should be performed before MAC, it's our future work.) Since
> DAC is performed after security_path_*() hooks, this approach has no
> impact to the semantics of TOMOYO Linux. Is it preferable?

I see.  Good point.

Unfortunately I think that is a shortcoming in the security_path_*
patchset.  Unfortunate bc that is going to be a pain to work out.

But I do think it needs to be worked out in the core code, not in
Tomoyo (and each lsm using security_path_*).  So for starters,
both vfs_mknod and vfs_create do may_create, so just pull that
into the callers.  Now Al or Christoph may yell NO due to the
intended layering (which i'm not clear on), in which case the
solution will be tougher.

> > > likewise...  (except in the case of fifo/sock, devcgroup should not be
> > > consulted as I'm not sure it'll handle that properly - have you tested
> > > tis with the device cgroup enabled?)
> Not tested yet... But I don't think problem occurs.
> 
> Regards,
