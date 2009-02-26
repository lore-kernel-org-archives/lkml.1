Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZBZDNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZBZDNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZBZDNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:13:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZBZDNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:13:14 -0500
Date: Thu, 26 Feb 2009 04:13:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] introduce pr_cont macro
Message-ID: <20090226031301.GE7526@elte.hu>
References: <20090225205920.GA22091@localhost> <20090226030315.GB7526@elte.hu> <1235617541.5610.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235617541.5610.0.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Thu, 2009-02-26 at 04:03 +0100, Ingo Molnar wrote:
> > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > 
> > > We cover all log-levels by pr_... macros except
> > > KERN_CONT one. Add it for convenience.
> > > 
> > > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > > ---
> > > 
> > > I think start printing with some pr_... macro
> > > and continue with printk(KERN_CONT ...) look
> > > not that clear -- better to continue with
> > > same pr_... slogan. Thoughts? I hope I didn't
> > > miss anything.
> > > 
> > >  include/linux/kernel.h |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > Index: linux-2.6.git/include/linux/kernel.h
> > > ===================================================================
> > > --- linux-2.6.git.orig/include/linux/kernel.h
> > > +++ linux-2.6.git/include/linux/kernel.h
> > > @@ -370,6 +370,8 @@ static inline char *pack_hex_byte(char *
> > >          printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> > >  #define pr_info(fmt, ...) \
> > >          printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> > > +#define pr_cont(fmt, ...) \
> > > +        printk(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
> > 
> > Makes sense.
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> > 
> 
> Don't you want to omit the pr_fmt() from the KERN_CONT case?

indeed, good catch. It should be:

#define pr_cont(fmt, ...) \
	printk(KERN_CONT ##__VA_ARGS__)

To not introduce stale subsystem tags in the printout. Perhaps 
it should even be:

#define __pr_cont(fmt, ...) \
	printk(KERN_CONT ##__VA_ARGS__)

To make it stand out more clearly that this is special.

	Ingo
