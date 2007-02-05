Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbXBEVkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbXBEVkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933480AbXBEVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:40:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37158 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbXBEVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:40:10 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 21:39:47 +0000
Message-Id: <1170711587.29759.909.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 13:28 -0800, Linus Torvalds wrote:
> Right. Because for MOST scsi drivers, it's obvious that they are SCSI to 
> the user.

Really? Including the 'Scanner driver' card which arrived with my
scanner?

Is that like the 'RAID' card which is obviously RAID to the user, and
not at all IDE?

> But if you cannot see that this is something TOTALLY DIFFERENT from USB 
> storage, you're either being obtuse on purpose, or just incapable of 
> understanding humans.
> 
> We should NEVER have had "USB_STORAGE" depending on SCSI. It'sa BUG. It's 
> a _stupid_ bug.
>
> We should have done what is sane:
>  - make CONFIG_SCSI (as a "support the SCSI layer" be invisible to users, 
>    because it's not a user decision.
>  - have a CONFIG_SCSI_DRIVER question for "do you want to be asked about 
>    SCSI drivers" (and which also does "select SCSI" for you)
>  - make USB_STORAGE _also_ do the "select SCSI" thing.

Crap. What we should have done is fix the tools so that when you go to
enable USB_STORAGE, it either prompts you or automatically turns on
SCSI. I saw versions of our tcl xconfig a _decade_ ago which were
capable of this, but we never cared enough to merge it -- although I
_thought_ our new xconfig could do it these days.

> In other words, you seem to be totally unable to grasp my argument. You 
> are arguing on TOTALLY IRRELEVANT TECHNICAL GROUNDS. That's not what the 
> Kconfig language is about. The Kconfig language and rules are about HUMAN 
> interaction.

Well that's a shame, because any sane person would realise that most
humans interact with kernel configuration only through a distribution.

> So next time you say something about Kconfig, ask yourself: "What question 
> would a user want to see".
> 
> Any other question is pretty much totally irrelevant, and your "don't use 
> select" rule comes from your confusion that thinks that it's somehow about 
> machines and technical issues. It's not.

No, really. Eric's Aunt Tillie can go screw herself backwards with a
chainsaw. I care about _my_ use of configuration, and mostly my
requirement is that I want to turn something _off_ either because it
doesn't work, or I want it modular so I can hack on it, or because I'm
trying to cut down kernel size and I don't want it.

The proliferation of 'select' has made that a _complete_ pain in the
wossname, apparently for the benefit of some hypothetical relative of a
gun nut, who doesn't actually care because in general she doesn't
configure her own kernel anyway.

Russell is right -- using 'select' just turns the problem backwards,
pessimising it for the _common_ case.

-- 
dwmw2

