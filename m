Return-Path: <linux-kernel-owner+w=401wt.eu-S965066AbXBEXVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066AbXBEXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965067AbXBEXVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:21:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49386 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965066AbXBEXVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:21:50 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
	 <1170711587.29759.909.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
	 <1170712393.29759.925.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
	 <20070205143110.fca62b57.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 23:21:34 +0000
Message-Id: <1170717694.29759.941.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 15:09 -0800, Linus Torvalds wrote:
> I also feel that a lot of people are "advanced" in one area, but not 
> necessarily in another. The Netfilter example I gave was one such personal 
> gripe of mine. I just feel like I shouldn't need to care! Yeah, I have the 
> knowledge, but I *still* want to be baby-fed with just a simple "anybody 
> can understand it".

The netfilter example is totally irrelevant here, since 'select' is
neither necessary nor sufficient for that. Russell and I have both
pointed that out to you already.

> Why? You could *trivially* have a tool tell you. Make "xconfig" or 
> something just pop up a window saying "sorry, you can't disable SCSI, 
> because you've got ATA enabled, and ATA wants SCSI".
> 
> What's the big deal, here?

Mostly that for the benefit of users who really don't actually configure
their own kernels at all, we're screwing over the people who _do_, and
who want this to work like it always did:

 sed -i -e 's/CONFIG_I2C=.*/# CONFIG_I2C is not set/' .config
 make oldconfig

Not only does that not work like it always did, but it's also _really_
hard to find out why, on occasion. You have to grep all over the tree to
find the offending 'select' statement.

The other reason that a bunch of us are objecting is because we seem to
be doing this for very little real benefit -- if we wanted to pander to
Aunt Tillie, we could have done it in the tools. As I said, that was
working ten years ago. Maybe not merged back into your tree but working
nonetheless. It's not rocket science.

But Alan makes a reasonable suggestion -- we could work around this in
the tools too. I think you're very misguided in optimising for the
people who aren't likely to be configuring their own kernels anyway, but
despite the fact that others seem to agree with me, I don't hold out
much hope of changing your mind. If we can hack up the kconfig library
to work around this bogosity by (optionally) treating all 'select' of
visible symbols as 'depends on' instead, then I think that should
actually work OK.

-- 
dwmw2

