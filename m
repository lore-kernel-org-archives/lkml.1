Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYHOMZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYHOMZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYHOMZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:25:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46667 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbYHOMZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:25:28 -0400
Date: Fri, 15 Aug 2008 14:25:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: jmerkey@wolfmountaingroup.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com
Subject: Re: [PATCH 2.6.27-rc3 26/29] mdb: export task_curr
Message-ID: <20080815122510.GF20442@elte.hu>
References: <200808140614.m7E6EcDS006264@wolfmountaingroup.com> <84144f020808140139v691e6590idd79995168af4e9e@mail.gmail.com> <44303.166.70.238.45.1218724556.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44303.166.70.238.45.1218724556.squirrel@webmail.wolfmountaingroup.com>
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


* jmerkey@wolfmountaingroup.com <jmerkey@wolfmountaingroup.com> wrote:

> > On Thu, Aug 14, 2008 at 9:14 AM,  <jmerkey@wolfmountaingroup.com> wrote:
> >> export the task_curr function to the module based kernel debugger to
> >> enable
> >> process back tracing and state display.
> >>
> >> Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)
> >>
> >> --- a/kernel/sched.c    2008-08-13 14:22:32.000000000 -0600
> >> +++ b/kernel/sched.c    2008-08-13 11:56:03.000000000 -0600
> >> @@ -1736,6 +1736,9 @@
> >>  {
> >>        return cpu_curr(task_cpu(p)) == p;
> >>  }
> >> +#if defined(CONFIG_MDB_MODULE)
> >> +EXPORT_SYMBOL_GPL(task_curr);
> >> +#endif
> >
> > We usually don't export symbols conditionally, especially in core kernel
> > code.
> >
> 
> Well,then please suggest how a kernel debugger can be module based and 
> still be able to get this information some other way that's generic 
> and minimal impact.

FYI, there's a built-in kernel debugger in the upstream kernel already: 
kernel/kgdb.c - and it does not need that export.

So if you are interested in kernel debuggers i'd suggest to work with 
the KGDB folks to extend it with whatever feature-set is missing.

They are friendly, very easy to work with and are open to the 
thousands-of-years-old scientific method of not duplicating effort, 
working together, going forward gradually, etc.

	Ingo
