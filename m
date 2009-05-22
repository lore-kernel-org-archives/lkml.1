Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZEVHpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZEVHpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 03:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZEVHpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 03:45:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40629 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbZEVHpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 03:45:43 -0400
Date: Fri, 22 May 2009 09:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH V2 0/3] Introduce and use DO_ONCE statement expression
	macro
Message-ID: <20090522074449.GA23810@elte.hu>
References: <cover.1242965306.git.joe@perches.com> <20090522052652.GX8633@ZenIV.linux.org.uk> <1242970756.3284.18.camel@Joe-Laptop.home> <20090522070111.GZ8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522070111.GZ8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, May 21, 2009 at 10:39:16PM -0700, Joe Perches wrote:
> > On Fri, 2009-05-22 at 06:26 +0100, Al Viro wrote:
> > > Your DO_ONCE(....) parses as "what the fuck is that?" followed by
> > > grepping for definition, and the cost is much higher.
> > 
> > So what do you suggest?
> > 
> > #define pr_info_once(fmt, args...)	printk_once(KERN_INFO pr_fmt(fmt), ##args)
> > #define pr_warning_once(fmt, args...)	printk_once(KERN_WARNING pr_fmt(fmt), ##args)
> > etc
> 
> That would be much saner.

Agreed.

The *_once() namespace meme is intuitive and easily understood, and 
we use it in a couple of places in the kernel and extend it on an 
as-needed basis for reoccuring (and boring and distracting) 
once-flag C code spam. We apply it to 'boring to begin with' 
constructs: printing a message or a warning, etc. So if a kernel 
coder sees a _once() or _ONCE() construct it can be assumed almost 
straight away that the code there is largely uninteresting from a 
code logic POV.

DO_ONCE() on the other hand is non-intuitive as it is a control 
structure that can be applied to _any_ code construct - interesting 
and uninteresting alike. For anything truly interesting that is not 
a kernel library/facility i dont want it to be hidden and abstracted 
away in 98% of the cases, i want to see the raw C form of it.

Otherwise we might as well write the kernel in C++.

	Ingo
