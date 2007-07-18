Return-Path: <linux-kernel-owner+w=401wt.eu-S935668AbXGRAZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbXGRAZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761053AbXGRAZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:25:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760031AbXGRAZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:25:09 -0400
Date: Tue, 17 Jul 2007 17:24:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com
Subject: Re: [PATCH 0/2] SELinux Netlabel updates
In-Reply-To: <Line.LNX.4.64.0707171945430.10858@d.namei>
Message-ID: <alpine.LFD.0.999.0707171719320.27353@woody.linux-foundation.org>
References: <Line.LNX.4.64.0707171945430.10858@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, James Morris wrote:
> 
> These are updated Netlabel/SELinux changes from Paul, reworked so that 
> they don't break userspace.  Michal says they work for him.  Please apply 
> for 2.6.23.

They don't work AT ALL for me:

	security/selinux/ss/sidtab.o: In function `netlbl_enabled':
	sidtab.c:(.text+0x0): multiple definition of `netlbl_enabled'
	security/selinux/ss/ebitmap.o:ebitmap.c:(.text+0x0): first defined here

Tssk.

That dummy "netlbl_enabled()" should be "static inline", methinks.

Also, that <net/netlabel.h> file has two blocks after each other of

	#ifdef CONFIG_NETLABEL
	..
	#else
	..
	#endif

	#ifdef CONFIG_NETLABEL
	..
	#else
	..
	#endif

which might as well be cleaned up at the same time (and might have avoided 
this bug, since then the people involved would have seen the _correct_ 
example in the first version)

Please fix up and ask me to pull again. Preferably by actually fixing up 
the commit itself, so that we don't unnecessarily have revisions that 
don't even compile and thus potentially screw up git-bisect attempts.

			Linus
