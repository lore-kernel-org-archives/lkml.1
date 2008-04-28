Return-Path: <linux-kernel-owner+w=401wt.eu-S936708AbYD1Qs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936708AbYD1Qs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936626AbYD1Qso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:48:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53430 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936630AbYD1Qsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:48:42 -0400
Date: Mon, 28 Apr 2008 19:48:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/buffer.c:init_buffer() mustn't be inline
Message-ID: <20080428164807.GW2813@cs181133002.pp.htv.fi>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153829.GB2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804280901130.3119@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0804280901130.3119@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:01:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 28 Apr 2008, Adrian Bunk wrote:
> <
> > This patch fixes the following build error with UML and gcc 4.3:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      fs/buffer.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c: In function ‘init_page_buffers’:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c:51: sorry, unimplemented: inlining failed in call to ‘init_buffer’: function body not available
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c:1007: sorry, unimplemented: called from here
> > make[2]: *** [fs/buffer.o] Error 1
> 
> Can somebody tell why this is not a gcc bug?

It is a gcc bug.

But having a global function marked as extern was already questionable, 
and all assumptions an "inline" would always inline the code are anyway 
now broken in your tree.

So let's work around a gcc bug by fixing the kernel...

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

