Return-Path: <linux-kernel-owner+w=401wt.eu-S968915AbXEHWwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968915AbXEHWwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032587AbXEHWvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:51:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36758 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032579AbXEHWvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:51:53 -0400
Date: Tue, 8 May 2007 15:52:53 -0700
From: Greg KH <greg@kroah.com>
To: J??rn Engel <joern@lazybastard.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070508225253.GA2689@kroah.com>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <20070508163226.GA22443@lazybastard.org> <84144f020705081215t73f2c0fq8ecb677423329cd8@mail.gmail.com> <20070508205827.GC23056@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508205827.GC23056@lazybastard.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 10:58:27PM +0200, J??rn Engel wrote:
> On Tue, 8 May 2007 22:15:18 +0300, Pekka Enberg wrote:
> > On 5/8/07, J??rn Engel <joern@lazybastard.org> wrote:
> > >> > +typedef __be16 be16;
> > >> > +typedef __be32 be32;
> > >> > +typedef __be64 be64;
> > >>
> > >> Why are those typedefs necessary ?
> > >
> > >Not strictly.  I tend to use the be* types fairly often in the code and
> > >simply grew weary of seeing the underscores.
> > >
> > >Any objections if I seperate out the userspace headers and keep the
> > >shorthands for kernel code only?
> > 
> > Not sure what you mean but I would prefer you drop the typedefs completely.
> 
> Basically I prefer be64 over __be64 for similar reasons that most people
> prefer u64 over __u64.  Others prefer uint64_t over both, but C99 hasn't
> defined beint64_t yet.

There is a difference between "u64" and "__u64", so don't confuse the
two, they are used for different things.

Same thing for your typedef above, you are confusing the usage of these
types of variables, please do not do that.

In short, if the variable is going to cross the userspace/kernelspace
boundry, use the "__" version, otherwise use the non-"--" version.

And please don't use uint64_t in the kernel, I don't want to see that
long flame-war again, read the archives for why those kinds of types
don't matter for us in the kernel tree.

So please drop all typedefs from your filesystem, you should not be
creating any new ones, that's the incorrect style guidelines.

thanks,

greg k-h
