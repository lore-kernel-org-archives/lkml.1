Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXBEV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXBEV3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933436AbXBEV3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:29:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933475AbXBEV3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:29:18 -0500
Date: Mon, 5 Feb 2007 13:28:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170710272.29759.894.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>
  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>
  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> 
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
 <1170710272.29759.894.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, David Woodhouse wrote:
>
> No, you're thinking of something else. The use of 'select' just turns
> the problem backwards -- if _every_ SCSI hostadapter were to 'select
> SCSI' instead of depending on it, then I'd have to say 'n' to every damn
> one of them instead of being able to just say 'n' to SCSI as I can at
> the moment.

Right. Because for MOST scsi drivers, it's obvious that they are SCSI to 
the user.

So we ask "do you want SCSI" in order to not ask a million questions that 
a lot of people know a-priori that they don't want.

But if you cannot see that this is something TOTALLY DIFFERENT from USB 
storage, you're either being obtuse on purpose, or just incapable of 
understanding humans.

We should NEVER have had "USB_STORAGE" depending on SCSI. It'sa BUG. It's 
a _stupid_ bug.

We should have done what is sane:
 - make CONFIG_SCSI (as a "support the SCSI layer" be invisible to users, 
   because it's not a user decision.
 - have a CONFIG_SCSI_DRIVER question for "do you want to be asked about 
   SCSI drivers" (and which also does "select SCSI" for you)
 - make USB_STORAGE _also_ do the "select SCSI" thing.

In other words, you seem to be totally unable to grasp my argument. You 
are arguing on TOTALLY IRRELEVANT TECHNICAL GROUNDS. That's not what the 
Kconfig language is about. The Kconfig language and rules are about HUMAN 
interaction.

So next time you say something about Kconfig, ask yourself: "What question 
would a user want to see".

Any other question is pretty much totally irrelevant, and your "don't use 
select" rule comes from your confusion that thinks that it's somehow about 
machines and technical issues. It's not.

		Linus
