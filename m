Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbXGAWOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbXGAWOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXGAWOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:14:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53396 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbXGAWOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:14:35 -0400
Date: Sun, 1 Jul 2007 15:14:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
In-Reply-To: <200707012329.52918.ak@suse.de>
Message-ID: <alpine.LFD.0.98.0707011511120.3323@woody.linux-foundation.org>
References: <20070701125035.3f54d8b0@oldman>
 <alpine.LFD.0.98.0707011106030.1172@woody.linux-foundation.org>
 <200707012329.52918.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jul 2007, Andi Kleen wrote:
> 
> What is so bad with it? Note it's a debugging facility and used 
> for kcrash kernels where the video output doesn't work. But they
> normally only run a few minutes to dump the previous state to disk
> and then reboot. 

It has been a total disaster from beginning to end.

It wastes power.

It hangs machines when it tries to blink.

To quote an earlier thread:

  "The driver uses panic_blink - something that we expect to work after 
   panic. It rapidly polls KBC status register to detect when it accepted 
   led command and does it without taking i8042_lock (because it may have 
   been taken before kernel panicked) so it is quite possible that that 
   interferes with atkbd operation."

and it has been confirmed to render unusable at least some thinkpads. I 
think it was Pavel who reported it last.

> But then I don't think it hurts anybody.  It's main problem
> is that it won't blink for people with USB keyboard.

No, its main problem is that PEOPLE SHOULD NOT USE IT, but it sounds cool, 
so people end up configuring the damn thing even though they shouldn't.

Which is why I think it should be marked broken.

And yes, it *does* hurt people.

		Linus
