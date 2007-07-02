Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbXGBPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbXGBPg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXGBPgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:36:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbXGBPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:36:47 -0400
Date: Mon, 2 Jul 2007 08:36:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: why does git perpetually complain about
 include/asm-blackfin/macros.h?
In-Reply-To: <4688EF9B.8020405@garzik.org>
Message-ID: <alpine.LFD.0.98.0707020834310.9434@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>
 <4688EF9B.8020405@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Jul 2007, Jeff Garzik wrote:

> Robert P. J. Day wrote:
> >   for the umpteenth time, after doing a pull, i see this:
> > 
> > $ git diff
> > diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
> > deleted file mode 100644
> > index e69de29..0000000
> > $
> 
> I have the same problem.  git 1.5.0.6 on Fedora Core 5 or 6.
> 
> I even tried a completely fresh clone, but the problem still appears.

Git complains for a very simple reason: that file is an empty file, and 
"make clean" removes all zero-sized files.

So whenever anybody does a "make clean" (maybe it's "make distclean", I 
forget), you will have removed the empty file, and git will show it as a 
diff.

We probably should just remove the file from the kernel archive.

		Linus
