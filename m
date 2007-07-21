Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbXGUVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbXGUVtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762493AbXGUVtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:49:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762335AbXGUVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:49:13 -0400
Date: Sat, 21 Jul 2007 14:48:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Latchesar Ionkov <lucho@ionkov.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CTL_UNNUMBERED (Re: [PATCH] 9p: Don't use binary sysctl
 numbers.)
Message-Id: <20070721144822.66afb65b.akpm@linux-foundation.org>
In-Reply-To: <20070721205709.GB5772@martell.zuzino.mipt.ru>
References: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com>
	<20070721205709.GB5772@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 00:57:09 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sat, Jul 21, 2007 at 12:53:19PM -0600, Eric W. Biederman wrote:
> > The recent 9p commit: bd238fb431f31989898423c8b6496bc8c4204a86
> > that supposedly only moved files also introduced a new 9p sysctl
> > interface that did not properly register it's sysctl binary numbers,
> > and since it was only for debugging clearly did not need a binary fast
> > path in any case.  So this patch just remove the binary numbers.
> >
> > See Documentation/sysctl/ctl_unnumbered.txt for more details.
> >
> > While I was at it I cleaned up the sysctl initializers a little as
> > well so there is less to read.
> 
> > --- a/net/9p/sysctl.c
> > +++ b/net/9p/sysctl.c
> > @@ -28,15 +28,10 @@
> 
> > -enum {
> > -	P9_SYSCTL_NET = 487,
> > -	P9_SYSCTL_DEBUG = 1,
> > -};
> > -
> > -static ctl_table p9_table[] = {
> > +static struct ctl_table p9_table[] = {
> >  #ifdef CONFIG_NET_9P_DEBUG
> >  	{
> > -		.ctl_name       = P9_SYSCTL_DEBUG,
> > +		.ctl_name       = CTL_UNNUMBERED,
> 
> That's separate patch but CTL_UNNUMBERED must die, because it's totally
> unneeded. If you don't want sysctl(2) interface just SKIP ->ctl_name
> initialization and save one line for something useful.
> 
> 	{
> 		.procname       = "prove_locking",
> 		.data		= &prove_locking,
> 		.maxlen		= sizeof(int),
> 		.mode		= 0644,
> 		.proc_handler	= &proc_dointvec,
> 	},
> 
> Or too late for -rc1?

It might be too late for -rc1 but it isn't too late for 2.6.23.

This affects a userspace interface.  Let's get it right please,
no rush.
