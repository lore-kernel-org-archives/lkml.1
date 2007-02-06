Return-Path: <linux-kernel-owner+w=401wt.eu-S1030559AbXBFX2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030559AbXBFX2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030567AbXBFX2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:28:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55224 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030559AbXBFX2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:28:32 -0500
Date: Tue, 6 Feb 2007 15:28:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170803515.29759.1032.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
 <1170803515.29759.1032.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, David Woodhouse wrote:
> 
> The other possibility which comes to mind, and which I _have_ seen
> implemented, is not to hide the disabled option but to _show_ it, and
> represent its dependencies right there next to it somehow. 

That would probably work, especially if you had some way to "warp" to the 
other options (so that if you see "depends on SCSI" you could say "ok, go 
to SCSI then".

However, I have this suspicion that you'd just drown in options that you 
really don't want to see.

> Well one option, as you suggest, is just that if you go into the
> graphical tool and enable USB_STORAGE, you get SCSI turned on
> automatically.

Yes. That basically is what "select" means, though. The difference is, 
indeed, largely about visibility.

If everything was always visible, there really wouldn't be much of a 
difference between "depends on" and "select". In both cases, when you 
click on something that depends on or selects something else, the config 
tool would obviously select it.

So yes, you can make "depends on" and "select" mean _exactly_ the same 
thing. But basically only by always showing everything. Which I don't 
think you want. If I say I don't want IPv6, I really am not interested in 
seeing some IPv6-only questions. But on the other hand, maybe there is 
something that _needs_ IPv6 to work, and then maybe I'd like it enabled..

(Example: I don't want to see IPV6 questions if IPV6 is off, BUT I might 
still want to be able to see the question about NFSv8.1, which only works 
on top of IPV6. I might not even *know* I want IPV6, but I know my company 
uses NFSv8.1, so I say "yes").

And I realize that was a contrieved example, but there are *real* examples 
of this in the kernel today. I may well know that I want 802.11 WEP 
encryption, for example, but I sure as hell had *no* clue that it requires 
ARC4.

See the problem? I may be a well-educated user who doesn't even *know* 
that I actually want an encrytion algorithm that I've never heard of. For 
all I knew, the 802.11 WEP stuff was done inside the wireless cards by 
hardware..

Does that mean that if I don't have CRYPTO_ARC4 enabled (which in turn 
would need CRYPTO_ALGAPI enabled too) I'd not even get the choice of WEP? 
Obviously that is broken. 

And yes, if you *always* get the choice of *everyting*, then it all boils 
down to the same thing. I just don't think you do..

		Linus
