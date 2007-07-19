Return-Path: <linux-kernel-owner+w=401wt.eu-S935976AbXGSBvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935976AbXGSBvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbXGSBuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:50:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbXGSBuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:50:50 -0400
Date: Wed, 18 Jul 2007 18:50:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [git patches] two warning fixes
In-Reply-To: <20070718184101.1d31db9c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707181848060.27353@woody.linux-foundation.org>
References: <20070718235504.GA9601@havoc.gtf.org> <200707190159.22654.ak@suse.de>
 <469EAABD.4010504@garzik.org> <1184807945.25235.289.camel@localhost.localdomain>
 <20070718184101.1d31db9c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Andrew Morton wrote:
> 
> The only reason why the sysfs creation would fail is a kernel bug,
> so the consequence of your proposal is in fact unfixed kernel bugs.

Well, the thing is, I suspect we have created way more bugs by having that 
stupid "you must check the return value even if you don't care", than by 
just letting it go.

> Now, we can talk about making those sysfs core functions generate warnings
> themselves, and we can talk about generating new wrappers around them which
> generate warnings and which return void, then migrating code over to use
> those.

If the only valid reason to fail is a kernel bug, it damn well should be 
that sysfs function itself that should complain. It's the only thing that 
knows and cares.

> And we can also talk about blithely ignoring these errors and not telling
> anyone about our bugs, but nobody should listen to such scandalous ideas.

Here's a question: do you always check the return value of "printf()"?

Nobody does. It's not worth it. Trying to do so just creates messy code, 
and MORE BUGS.

So yes, I think we should ignore return values when they have absolutely 
zero interest level to us.

		Linus
