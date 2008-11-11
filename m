Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYKKCsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYKKCsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 21:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYKKCsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 21:48:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbYKKCsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 21:48:10 -0500
Date: Mon, 10 Nov 2008 18:47:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andreas Schwab <schwab@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
In-Reply-To: <1226368174.7530.47.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0811101822350.3468@nehalem.linux-foundation.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>  <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>  <jetzafiad4.fsf@sykes.suse.de> <1226353979.7530.8.camel@pasglop>  <jefxlzi2x0.fsf@sykes.suse.de> <1226360094.7530.18.camel@pasglop> 
 <je1vxji1br.fsf@sykes.suse.de> <1226368174.7530.47.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Nov 2008, Benjamin Herrenschmidt wrote:
> 
> In any case, I doesn't seem to be directly related to those radeonfb
> changes, though a clash with X like that is indeed more likely to
> actually happen if radeonfb relies more heavily on acceleration.

Just a silly question, without actually looking at the code - since you 
now do acceleration in radeonfb, do you wait for everything to drain 
before you switch consoles? 

There could be races that depend on timing, where perhaps X is unhappy 
about being entered with the acceleration engine busy, or conversely the 
radeonfb code is unhappy about perhaps some still-in-progress X thing that 
hasn't been synchronously waited for..

Before, radeonfb_imageblit() would always end up doing a 
"radeon_engine_idle()", so in practice, I think just about any fbcon 
access ended up idling the engine. Now, we can probably do a lot more 
without syncronizing - maybe there's insufficient synchronization at the 
switch-over from X to text-mode or vice versa?

		Linus
