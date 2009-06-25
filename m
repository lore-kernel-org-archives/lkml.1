Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZFYAdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZFYAdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbZFYAdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:33:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbZFYAdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:33:37 -0400
Date: Wed, 24 Jun 2009 17:33:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090624173316.a129672d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906241636060.30928@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
	<20090623131239.711d9f83.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231355130.17001@makko.or.mcafeemobile.com>
	<20090623142511.c9068655.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231423490.17001@makko.or.mcafeemobile.com>
	<20090623144416.04c34268.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231538280.17001@makko.or.mcafeemobile.com>
	<20090623161852.660cab78.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906241546380.30928@makko.or.mcafeemobile.com>
	<20090624161240.3efdbbfa.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906241636060.30928@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 16:52:06 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> > umm, yes please, I believe the patches should be split.  And I'm still
> > not seeing the justification for forcing CONFIG_EVENTFD onto all
> > CONFIG_AIO users!
> 
> Eventfd notifications became part of the AIO API (it's not even delivered 
> through a new syscall, from the AIO side - same existing aiocb struct and 
> io_submit syscall) once we merged it,

That was a regression for existing embedded AIO users ;)

> so IMHO (AIO && !EVENTFD) would be 
> similar to split AIO in AIO_READ and AIO_WRITE and have (AIO && !AIO_WRITE).
> Considering that the kernel config, once you unleash the CONFIG_EMBEDDED 
> pandora box, allows you to select (AIO && !EVENTFD) w/out even a warning 
> about possible userspace breakages, this makes it rather a confusing 
> configuration if you ask me.

Sure.  But we do assume that one someone sets CONFIG_EMBEDDED, they
know what they're doing.  We prefer to give them maximum flexibility
and foot-shooting ability.  As long as the maintenance cost of doing so
in each case is reasonable, of course.

> It's not a biggie from the kernel side, just a few ugly errors wrappers 
> around functions. For me AIO (or whatever userspace visible kernel 
> subsystem) should select all the components that are part of the userspace 
> API, but my argument ends here.

Sure, it's not a biggie either way.  Doubtful if many tiny systems are
using AIO anyway.  Heck, lots of them are running 2.4.18...

But from the general this-is-the-way-we-do-things POV, it's preferred
that the two features be separable under CONFIG_EMBEDDED if poss.


