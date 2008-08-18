Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYHRIA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYHRIA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYHRIAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:00:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbYHRIAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:00:12 -0400
Date: Mon, 18 Aug 2008 09:59:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -v3 6/7] kexec jump: __ftrace_enabled_save/restore
Message-ID: <20080818075937.GI30694@elte.hu>
References: <1218510876.24951.45.camel@caritas-dev.intel.com> <20080815124938.GB24663@elte.hu> <1219022293.5663.14.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219022293.5663.14.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> On Fri, 2008-08-15 at 14:49 +0200, Ingo Molnar wrote:
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > +/* Ftrace disable/restore without lock. Some synchronization mechanism
> > > + * must be used to prevent ftrace_enabled to be changed between
> > > + * disable/restore. */
> > 
> > use the proper comment style please:
> > 
> > /*
> >  *
> >  */
> 
> OK. I will change it.

it's upstream already, please send a followup clean up patch.

> > > +static inline int __ftrace_enabled_save(void)
> > > +{
> > > +#ifdef CONFIG_FTRACE
> > > +	int saved_ftrace_enabled = ftrace_enabled;
> > > +	ftrace_enabled = 0;
> > > +	return saved_ftrace_enabled;
> > > +#else
> > > +	return 0;
> > > +#endif
> > > +}
> > > +
> > > +static inline void __ftrace_enabled_restore(int enabled)
> > > +{
> > > +#ifdef CONFIG_FTRACE
> > > +	ftrace_enabled = enabled;
> > > +#endif
> > > +}
> > 
> > hm, what is this used for?
> > 
> > also, instead of such an ugly inline, why not create a proper 
> > kernel/trace/* function for this. That would also give it access to all 
> > the proper locking mechanisms - instead of relying on some extral 
> > mechanism.
> 
> This function is used for kexec jump in machine_kexec(). Where all 
> non-boot CPUs and IRQ are disabled, system is going to kexec, and it 
> is not allowed to schedule to other process in this circumstance, so a 
> non-lock version is needed. A locked version has been implemented by 
> Steven Rostedt, I think it can be used for other circumstance.

ok, fair enough.

	Ingo
