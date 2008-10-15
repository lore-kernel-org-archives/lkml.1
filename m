Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYJOAF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYJOAF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYJOAFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:05:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42903 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753867AbYJOAFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:05:43 -0400
Date: Wed, 15 Oct 2008 01:05:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20081015000541.GA22570@opensource.wolfsonmicro.com>
References: <20081015095916.f30c0979.sfr@canb.auug.org.au> <alpine.LFD.2.00.0810141637210.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810141637210.3288@nehalem.linux-foundation.org>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 04:43:12PM -0700, Linus Torvalds wrote:

> I assume that broken driver is some ARM-specific thing. I certainly don't 
> want to see NO_IRQ in any general drivers. So instead of having that 
> NO_IRQ insanity spread any more, I'd much rather see the driver either 
> fixed to not use it, or just marked ARM-only.

It's not ARM-specific, though the overwhelming majority of users will be
ARM systems (it's an embedded PMIC) - I'll post a patch tomorrow
changing it to check for non-zero IRQ instead.  That makes other bits of
the driver easier, anyway.

> The proper way to test for whether an interrupt is valid or not is to do

> 	if (dev->irq) {
> 		...

> and no other. There is no spoon. That NO_IRQ was insane. And architectures 
> or drivers that still think otherwise should fix themselves.

That would be people on the ARM list.  Unless I misremember I first
heard about using NO_IRQ from the ARM list in connection with another
(much less ARM-specific) driver only within the past six months.
