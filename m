Return-Path: <linux-kernel-owner+w=401wt.eu-S1031313AbXEHTLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031313AbXEHTLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031288AbXEHTLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:11:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53986 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031298AbXEHTLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:11:45 -0400
Date: Tue, 8 May 2007 20:49:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@outflux.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kbuild: complain about missing system calls.
Message-ID: <20070508184954.GA31736@uranus.ravnborg.org>
References: <20070508182424.GA31516@uranus.ravnborg.org> <617E1C2C70743745A92448908E030B2A01719AFB@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A01719AFB@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 11:35:27AM -0700, Luck, Tony wrote:
> Looks more complex than necessary.  Why do you want to execute
> an arch specific script to list the __IGNORE symbols?  That would
> allow an arch to generate a list with sed/perl/etc. but that
> looks like overkill.
> 
> If you just have an arch specific file with the right defines.
> E.g. for x86_64 in include/asm-x86_64/ignore_syscalls:
> 
> #include __IGNORE_getcpu
> 
> Then the checksyscalls.sh changes would just be something like
> (do I need a ${srctree} before the include??):
Much better - thanks.

Yes. For "make O=..." builds we need to refer to the file in
the srctree. include/asm/... is not pointing back to the original tree.
So I had to use:

if [ -f ${srctree}/include/asm-${ARCH}/ignore_syscalls ]; then
	cat ${srctree}/include/asm-${ARCH}/ignore_syscalls
fi

To make it work.
I will push this change out during the weekend I hope.

	Sam
