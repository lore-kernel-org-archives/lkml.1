Return-Path: <linux-kernel-owner+w=401wt.eu-S1764364AbXGPRWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764364AbXGPRWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbXGPRWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:22:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52374 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbXGPRWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:22:38 -0400
Date: Mon, 16 Jul 2007 12:22:36 -0500
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] crash in 2.6.22-git2 sysctl_set_parent()
Message-ID: <20070716172236.GA5771@austin.ibm.com>
References: <20070713200515.GS5549@austin.ibm.com> <m13azreqtr.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13azreqtr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 07:06:56PM -0600, Eric W. Biederman wrote:
> >  			.data		= &ipv4_devconf.loop,
> >  			.maxlen		= sizeof(int),
> >  			.mode		= 0644,
> > +			.child	= 0x0,
> >  			.proc_handler	= &proc_dointvec,
> >  		},
> Where did this entry above in devinet_sysctl come from?

My bad.
I habitually apply the "send-to-self" patch, since some of the 
network testing that I do is easiest if I load up the all of the 
adapters in the same box. (If you're not familiar with this patch ... 
its great, and I wish it was integratedd into mainline. It allows
one to drive network traffic through the physical devices, even
if they are in the same box.  Without it, the network stack is
too clever, and won't allow you to do this.)

> > +		{
> > +			.ctl_name	= 0,
> > +			.procname	= 0,
> > +		},
> I probably would have just done:
> +		{},

Yes, in retrospect, this would have been the simplest solution.

> What added the additional entry to devinet_root_dir?  I don't see that
> in Linus' tree?
> 
> The result may be fine but if it isn't named in a per network device
> manner we are adding duplicate entries to the root /proc/sys directory
> which is wrong.
> 
> Actually come to think of it I am concerned that someone added a
> settable entry into /proc/sys/ it should at least be in /proc/sys/net/
> where it won't conflict with other uses of that directory.  Especially
> as things like network devices have user controlled names.

Sigh. Silly me. Haste makes waste.

--linas

