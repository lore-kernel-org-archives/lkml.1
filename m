Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYIEUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYIEUmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYIEUmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:42:09 -0400
Received: from 1wt.eu ([62.212.114.60]:3214 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYIEUmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:42:08 -0400
Date: Fri, 5 Sep 2008 22:41:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, pageexec@freemail.hu,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905204134.GI19337@1wt.eu>
References: <20080903195122.73905236@infradead.org> <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu> <1220609647.4879.169.camel@pasglop> <48C10EC5.24400.3008276@pageexec.freemail.hu> <1220612231.4879.175.camel@pasglop> <20080905114233.GA27878@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905114233.GA27878@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 01:42:33PM +0200, Ingo Molnar wrote:
> The far better solution would be to insert uncertainty into the picture: 

till there OK :-)

> some sort of low-frequency watchdog [runs once a second or so] that 
> tries to hide itself from the general kernel scope as much as possible, 
> perhaps as ELF-PIC code at some randomized location, triggered by some 
> frequently used and opaque kernel facility that an attacker can not 
> afford to block or fully filter, and which would just check integrity 
> periodically and with little cost.

"can not" above is the unrealistic requirement unfortunately.

> When it finds a problem it immediately triggers a hard to block/filter 
> vector of alert (which can be a silent alarm over the network or to the 
> screen as well).
> 
> that method does not prevent rootkits in general (nothing can), but sure 
> makes their life more risky in practice - and a guaranteed livelihood 
> and risk reduction is what typical criminals are interested in 
> primarily, not whether they can break into a particular house.
> 
> If we implement it then it should not be present in distro .config's, 
> etc. - it should be as invisible as possible - perhaps only be part of 
> the kernel image .init.data section in some unremarkably generic manner. 

Then they will simply proceed like this :
  - patch /boot/vmlinuz
  - sync
  - crash system

=> user says "oh crap" and presses the reset button. Patched kernel boots.
   Game over. Patching vmlinuz for known targetted distros is even easier
   because the attacker just has to embed binary changes for the most
   common distro kernels.

Clearly all this is a waste of developer time, CPU cycles, memory,
reliability and debugging time. All that time would be more efficiently
spent auditing and debugging existing code to reduce the attack surface,
and CPU cycles + memory would be better spent adding double checks to
most sensible functions' entry points and user data processing.

Regards,
Willy

