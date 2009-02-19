Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZBSUrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZBSUrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZBSUrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:47:05 -0500
Received: from gw.goop.org ([64.81.55.164]:60014 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZBSUrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:47:04 -0500
Message-ID: <499DC545.2030402@goop.org>
Date: Thu, 19 Feb 2009 12:47:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Petr Tesarik <ptesarik@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
References: <1235068713.15053.99.camel@nathan.suse.cz> <20090219185935.GA21820@elte.hu> <499DB8BA.3050708@zytor.com>
In-Reply-To: <499DB8BA.3050708@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> For that to happen, it would have to move the asm volatile relative to 
> the __builtin_trap(), which seems slightly unlikely -- are there any 
> cases at which this has been known to happen, or is that conjecture on 
> your part?

There's no reason to expect an "asm volatile" to stay put; the 
"volatile" has nothing to do with preventing code motion.  The only way 
to make an asm stick in one place is with data dependencies, and I'm not 
sure what the dependency for __builtin_trap might be.  I'm guessing its 
a "memory" clobber, but that's pure guesswork.

> It would be more of a "right thing" to do this with a label on the 
> __builtin_trap(), but the problem with that labels have function scope 
> even if they occur inside a block.

No, you can declare them local (__label__ foo).  But gcc will happily do 
crazy/crappy things with them if you don't actually end up gotoing them 
(even indirectly).  I've had a couple of go-rounds with the fine helpful 
gcc folks on this very issue...

It would be worth checking the archives from about the time I did the 
generic BUG stuff; around dec-jan 2006-7, I think.

    J
