Return-Path: <linux-kernel-owner+w=401wt.eu-S933930AbXGSCGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbXGSCGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 22:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbXGSCGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 22:06:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:52139 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXGSCGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 22:06:00 -0400
Subject: Re: [git patches] two warning fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <alpine.LFD.0.999.0707181848060.27353@woody.linux-foundation.org>
References: <20070718235504.GA9601@havoc.gtf.org>
	 <200707190159.22654.ak@suse.de> <469EAABD.4010504@garzik.org>
	 <1184807945.25235.289.camel@localhost.localdomain>
	 <20070718184101.1d31db9c.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0707181848060.27353@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 12:05:34 +1000
Message-Id: <1184810734.25235.299.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 18:50 -0700, Linus Torvalds wrote:
> > Now, we can talk about making those sysfs core functions generate warnings
> > themselves, and we can talk about generating new wrappers around them which
> > generate warnings and which return void, then migrating code over to use
> > those.
> 
> If the only valid reason to fail is a kernel bug, it damn well should be 
> that sysfs function itself that should complain. It's the only thing that 
> knows and cares.

That's pretty much what Paulus and I have been advocating all along.

There -might- be a couple of cases where something has a good reason to
do a call that may fail and want to test the result code. For those few
rare cases (though none comes to mind at the moment), then I suppose we
could provide some kind of _try version of the function (or whatever you
want to call it) that doesn't warn and just returns an error.

But as I said, I can't see any such case out of the blue.

Cheers,
Ben.


