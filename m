Return-Path: <linux-kernel-owner+w=401wt.eu-S1032812AbXEHXOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032812AbXEHXOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032221AbXEHXO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:14:28 -0400
Received: from lazybastard.de ([212.112.238.170]:41720 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031736AbXEHXO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:14:27 -0400
Date: Wed, 9 May 2007 01:10:09 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070508231009.GB25920@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <20070508163226.GA22443@lazybastard.org> <84144f020705081215t73f2c0fq8ecb677423329cd8@mail.gmail.com> <20070508205827.GC23056@lazybastard.org> <20070508225253.GA2689@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070508225253.GA2689@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 15:52:53 -0700, Greg KH wrote:
> On Tue, May 08, 2007 at 10:58:27PM +0200, J??rn Engel wrote:
> > 
> > Basically I prefer be64 over __be64 for similar reasons that most people
> > prefer u64 over __u64.  Others prefer uint64_t over both, but C99 hasn't
> > defined beint64_t yet.
> 
> There is a difference between "u64" and "__u64", so don't confuse the
> two, they are used for different things.
> 
> Same thing for your typedef above, you are confusing the usage of these
> types of variables, please do not do that.
> 
> In short, if the variable is going to cross the userspace/kernelspace
> boundry, use the "__" version, otherwise use the non-"--" version.

Complete agreement with one nitbit: there is not "be64" type defined as
of yet.

And in the current patch there is no userspace/kernelspace boundary
either, as both mkfs and fsck live in kernelspace.  When changing this I
will use __be64 and friends in the common header.

The remaining question is how to deal with kernel-only code that uses
be64.  Convert that to __be64 as well?  Or introduce be64 in
include/linix/types.h instead?

> And please don't use uint64_t in the kernel, I don't want to see that
> long flame-war again, read the archives for why those kinds of types
> don't matter for us in the kernel tree.

Trust me, I'm happy there is no beint64_t.  So enough of that.

Jörn

-- 
Eighty percent of success is showing up.
-- Woody Allen
