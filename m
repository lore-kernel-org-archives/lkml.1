Return-Path: <linux-kernel-owner+w=401wt.eu-S1751617AbXBEQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbXBEQw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXBEQw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:52:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXBEQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:52:28 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702050829360.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702050829360.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 16:52:20 +0000
Message-Id: <1170694340.29759.883.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 08:32 -0800, Linus Torvalds wrote:
> 
> On Mon, 5 Feb 2007, David Woodhouse wrote:
> > 
> > Secondly, please don't _ever_ use 'select'.
> 
> No, David.
> 
> I don't know why you keep repeating this mantra, when it's WRONG.

It may not shock you to find that I repeat it because I disagree.

> Using "select" is a lot more sane and intelligent than assuming that users 
> know what dependencies they want.
>
> The Kconfig files should ask about *end-user* visible features. They 
> should say "do you want to support X".

For the benefit of some, that's useful. Others still want to be able to
turn off entire subsystems when they don't compile or when they want to
quickly build a minimal kernel. It's become very hard to do that though.

> If "X" then needs Y, Z and something else to actually compile, then that 
> Kconfig file should DAMN WELL use "select". Stop claiming anything else!

I agree that the tools should let them do that easily. It doesn't
necessarily follow that we should use 'select' for that purpose.

> The user shouldn't know that they should say that they need some library Y 
> in order to even see the question for "X". It's not a sane thing to ask 
> them to know and care about. They care about the devices or capabilities 
> they want to support, not about the fact that a USB storage device needs 
> the SCSI core layer, for example.

This I agree with. And it's something which the _tools_ have been
capable of for a long time. You don't need 'select'. 

The problem is that the widespread and inconsistent use of 'select' for
Aunt Tillie's benefit causes problems for a _different_ set of people.
To use Ingo's example -- if I want to turn off CONFIG_I2C because it
doesn't build or I want it modular to hack on it, I want to be able to
just _do_ that.

I don't want to find that it's forced to 'Y' because I also happen to be
building support for some esoteric peripheral that I've never heard of.
I want that that peripheral to be turned _off_ when I turn I2C off. I
don't want to have to spend hours grepping _all_ over the tree to find
out what's forcing I2C on again. When it was just dependencies, it was
easy enough to find -- it was right there in the Kconfig file in one
place. Now it's a lot harder.

And I'm sure you aren't seriously suggesting that we should take it all
the way and that, for example, all SCSI host drivers should 'select
SCSI' rather than merely depending on SCSI? If I configure a kernel I
don't _want_ to be asked individually about every leaf option -- I want
to be able to turn stuff off in an orderly fashion; in a tree as Ingo
suggests.

-- 
dwmw2

