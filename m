Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936282Ab0B0Vdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:33:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933964Ab0B0Vdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:33:44 -0500
Date: Sat, 27 Feb 2010 13:33:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@redhat.com>
cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] notification: including fanotify
In-Reply-To: <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002271331570.4513@localhost.localdomain>
References: <1267218869.10582.12.camel@localhost> <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 27 Feb 2010, Linus Torvalds wrote:
>
>  (b) the compile has obviously never been tested with any modern gcc 
>      version. I get tons of warnings after the pull, like

In fact, this seems to be due to a commit that explicitly says:

				I do not add -Wpointer-sign to the fsnotify
    code as there are still issues with kstrdup and strlen which would pop
    out needless warnings.

but then the patch actually has

	--- a/fs/notify/Makefile
	+++ b/fs/notify/Makefile
	@@ -1,3 +1,5 @@
	+EXTRA_CFLAGS   += -Wpointer-sign
	+

WTF? Which part of this was tested AT ALL? Clearly there was not even a 
compile test going on.

			Linus
