Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYKGErv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYKGErv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYKGErn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:47:43 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39431 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYKGErl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:47:41 -0500
Date: Fri, 7 Nov 2008 10:16:55 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, h-shimamoto@ct.jp.nec.com,
       laijs@cn.fujitsu.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: bugfix: try_module_get even if calling_mod is
	NULL
Message-ID: <20081107044655.GA17228@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <490FE405.1000105@cn.fujitsu.com> <4910F697.2050203@redhat.com> <4910FB3D.4020805@cn.fujitsu.com> <491212C0.4030900@redhat.com> <4912222F.9040605@ct.jp.nec.com> <49122745.4090004@redhat.com> <49123521.6020608@redhat.com> <20081106170023.d5349c42.akpm@linux-foundation.org> <4913A7B2.9000609@redhat.com> <20081106185456.0b1d00eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106185456.0b1d00eb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 06:54:56PM -0800, Andrew Morton wrote:
> On Fri, 07 Nov 2008 11:28:02 +0900 Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Andrew Morton wrote:
> > > I do not understand this description "Get probed module even if the
> > > caller is in the kernel core code".
> > > 
> > > What bug is being fixed here?  What is the kernel behaviour before and
> > > after the patch?
> > 
> > When someone called register_*probe() from kernel-core code(not from
> > module) and that probes a kernel module, users can remove the probed
> > module because kprobe doesn't increment reference counter of the module.
> > (on the other hand, if the kernel-module calls register_*probe,
> > kprobe increments refcount of the probed module.)
> > 
> > Currently, we have no register_*probe() calling from kernel-core(except
> > smoke-test, but the smoke-test doesn't probe module), so there is no
> > real bugs. But the logic is wrong(or not fair) and it can causes a
> > problem when someone might want to probe module from kernel.
> > 
> > After this patch is applied, even if someone put register_*probe() call
> > in the kernel-core code, it increments the reference counter of the
> > probed module, and it prevents user to remove the module until stopping
> > probing it.
> > 
> > > Was the bug present in 2.6.27, 2.6.26 etc?  Or was it a post-2.6.28
> > > regression?
> > 
> > Hmm, it might be an enhancement, because currently the kernel doesn't
> > have real bugs.
> > 
> 
> OK, thanks, so I scheduled this for 2.6.29.
> 
> Also, I decided that
> kprobes-disable-preempt-for-module_text_address-and-kernel_text_address.patch
> is needed in 2.6.28.  Please let me know if that was incorrect.  Please
> also let me know if you think that patch is needed in 2.6.27.x or
> earlier.

That is correct and this doesn't warrant inclusion in 2.6.27.x.

Ananth
