Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbYD2IQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbYD2IQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYD2IQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:16:34 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57291 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbYD2IQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:16:33 -0400
Date: Tue, 29 Apr 2008 10:17:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
Message-ID: <20080429081705.GA3552@uranus.ravnborg.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153831.GC2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org> <20080429080631.GB28059@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429080631.GB28059@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:06:31AM +0300, Adrian Bunk wrote:
> On Mon, Apr 28, 2008 at 05:41:11PM -0700, Linus Torvalds wrote:
> >...
> > > -inline struct block_device *I_BDEV(struct inode *inode)
> > > +struct block_device *I_BDEV(struct inode *inode)
> > >  {
> > >  	return &BDEV_I(inode)->bdev;
> > >  }
> > 
> > There is NO WAY IN HELL this function shouldn't be inlined,
> >...
> 
> Then CONFIG_OPTIMIZE_INLINING already broke it in your tree.

Can you please help me here.
Previously we said: gcc shall inline
Now we say: hi gcc - it is a good idea to inline this

But even without any inline annotation we would expect gcc
to inline it based on normal heuristics simply due to the
small size/footprint of the function.

So I cannot see how the CONFIG_OPTIMIZE_INLINING have any
effect here.
It all smells like a gcc bug to me.


	Sam
