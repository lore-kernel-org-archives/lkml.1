Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYHRBSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYHRBSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYHRBSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:18:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:33214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYHRBSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,224,1217833200"; 
   d="scan'208";a="371421091"
Subject: Re: [PATCH -v3 6/7] kexec jump: __ftrace_enabled_save/restore
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080815124938.GB24663@elte.hu>
References: <1218510876.24951.45.camel@caritas-dev.intel.com>
	 <20080815124938.GB24663@elte.hu>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 09:18:13 +0800
Message-Id: <1219022293.5663.14.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 14:49 +0200, Ingo Molnar wrote:
> * Huang Ying <ying.huang@intel.com> wrote:
> 
> > +/* Ftrace disable/restore without lock. Some synchronization mechanism
> > + * must be used to prevent ftrace_enabled to be changed between
> > + * disable/restore. */
> 
> use the proper comment style please:
> 
> /*
>  *
>  */

OK. I will change it.

> > +static inline int __ftrace_enabled_save(void)
> > +{
> > +#ifdef CONFIG_FTRACE
> > +	int saved_ftrace_enabled = ftrace_enabled;
> > +	ftrace_enabled = 0;
> > +	return saved_ftrace_enabled;
> > +#else
> > +	return 0;
> > +#endif
> > +}
> > +
> > +static inline void __ftrace_enabled_restore(int enabled)
> > +{
> > +#ifdef CONFIG_FTRACE
> > +	ftrace_enabled = enabled;
> > +#endif
> > +}
> 
> hm, what is this used for?
> 
> also, instead of such an ugly inline, why not create a proper 
> kernel/trace/* function for this. That would also give it access to all 
> the proper locking mechanisms - instead of relying on some extral 
> mechanism.

This function is used for kexec jump in machine_kexec(). Where all
non-boot CPUs and IRQ are disabled, system is going to kexec, and it is
not allowed to schedule to other process in this circumstance, so a
non-lock version is needed. A locked version has been implemented by
Steven Rostedt, I think it can be used for other circumstance.

Best Regards,
Huang Ying


