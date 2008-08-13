Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYHMBhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYHMBhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYHMBhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:37:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:61418 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYHMBhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:37:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,199,1217833200"; 
   d="scan'208";a="428714778"
Subject: Re: [PATCH -v3 6/7] kexec jump: __ftrace_enabled_save/restore
From: Huang Ying <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080812130609.GB3951@redhat.com>
References: <1218510876.24951.45.camel@caritas-dev.intel.com>
	 <20080812130609.GB3951@redhat.com>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 09:37:36 +0800
Message-Id: <1218591456.24951.62.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 09:06 -0400, Vivek Goyal wrote:
> On Tue, Aug 12, 2008 at 11:14:36AM +0800, Huang Ying wrote:
> > Add __ftrace_enabled_save/restore, used to disable ftrace for a
> > while. Now, this is used by kexec jump, which need a version without
> > lock, for general situation, a locked version should be used.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > ---
> >  include/linux/ftrace.h |   21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -98,6 +98,27 @@ static inline void tracer_disable(void)
> >  #endif
> >  }
> >  
> > +/* Ftrace disable/restore without lock. Some synchronization mechanism
> > + * must be used to prevent ftrace_enabled to be changed between
> > + * disable/restore. */
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
> > +
> >  #ifdef CONFIG_FRAME_POINTER
> >  /* TODO: need to fix this for ARM */
> >  # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> 
> I guess steven would like to see a patch which introduces both locked
> and lockless versions and with a very good comment explaining in what
> kind of unusual situation one can use the lockless version.

Have sent a locked version to Steven. And, there are some comments for
non-locked version, __ftrace_enabled_save() in above patch. What do you
think about it?

Best Regards,
Huang Ying


