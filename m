Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXHAGso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXHAGso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXHAGse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:48:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXHAGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:48:33 -0400
Date: Wed, 1 Aug 2007 08:48:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: teresa@kvitka.net, CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
Message-ID: <20070801064816.GC10134@elte.hu>
References: <1185827130.26459.16.camel@xtower.fri> <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Hi,
> 
> On 30/07/07, <::.. Teresa_II ..::> <teresa@kvitka.net> wrote:
> > Hi all,
> >
> >
> > first of all i am not sure if its scheduler issue. But i didn't found
> > anything about that in google related to something else.
> >
> > So i tried 2.6.22.1 kernel with new cfs scheduler v19.1 from Ingo page.
> > Previous i used 2.6.22-ck1.
> >
> > After 24 hours running i get strange behavior in Xorg. It act slower
> > with my special keys, like SHIFT, or CTRL. So if i hold SHIFT and press
> > ")" and than will press enter, i release SHIIFT and press ENTER it
> > doesn't create new line. Even if i start write a Sentence or word with
> > "SHIFTed" char it makes next char in high case also.
> > Like this: "HAllo" even if i type "Hallo".
> >
> > It's extremely unusable.
> >
> > It doesn't happen if i am on other kernel.
> >
> > I am ready to provide any requested information to find issue.
> > If its not kernel related thing - i am very sorry, i just don't know
> > where to start to trace whats wrong.
> >
> > I am on gentoo and use latest xorg server. Keyboard driver is "KBD".
> > Mouse use "evdev" driver.
> 
> Ingo, can you take a look at this?

another reaction below in this thread reported kbd problems in vanilla 
2.6.22.1 as well. What is the X versions, etc.? Does the problem go away 
if the X kbd driver selection is tweaked to a simpler model, say:

 Section "InputDevice"
         Identifier  "Keyboard0"
         Driver      "kbd"
         Option      "XkbModel" "pc105"
         Option      "XkbLayout" "us"
         Option      "XkbVariant" "basic"
 EndSection

	Ingo

----------------------->

From: Rene Herman <rene.herman@gmail.com>

On 07/30/2007 10:25 PM, <::.. Teresa_II ..::> wrote:

> first of all i am not sure if its scheduler issue. But i didn't found
> anything about that in google related to something else.
> 
> So i tried 2.6.22.1 kernel with new cfs scheduler v19.1 from Ingo page.
> Previous i used 2.6.22-ck1.
> 
> After 24 hours running i get strange behavior in Xorg. It act slower
> with my special keys, like SHIFT, or CTRL. So if i hold SHIFT and press
> ")" and than will press enter, i release SHIIFT and press ENTER it
> doesn't create new line. Even if i start write a Sentence or word with
> "SHIFTed" char it makes next char in high case also. 
> Like this: "HAllo" even if i type "Hallo".

For a few days now I have been experiencing a "stuck delete" key while 
reading mail -- I run through the mail with "delete" and every once in a 
while it just keeps on deleting messages while I've already released the 
delete key and was trying to read the next message.

Regular unpatched 2.6.22.1 though and I've recently changed too many things 
to be certain of anything. My X is the modular X.org 1.3.0 since not long, 
and the mailer showing the problem is Thunderbird 2.0.0.5, recently switched 
from 1.5.0.12. The problem was on my "I'll get to it" list but seems this 
could be a good thread to report it into. PS/2 keyboard...

> It's extremely unusable.
> 
> It doesn't happen if i am on other kernel.

Very very sure?

> I am ready to provide any requested information to find issue. If its not
> kernel related thing - i am very sorry, i just don't know where to start
> to trace whats wrong.
> 
> I am on gentoo and use latest xorg server. Keyboard driver is "KBD". 
> Mouse use "evdev" driver.

Rene.


-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
