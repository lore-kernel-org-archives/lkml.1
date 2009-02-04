Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbZBDWR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbZBDWR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbZBDWRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:17:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759558AbZBDWRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:17:11 -0500
Date: Wed, 4 Feb 2009 14:16:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
In-Reply-To: <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902041412420.3247@localhost.localdomain>
References: <20090204192551.GA19539@elte.hu> <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Linus Torvalds wrote:
> 
> Either cast the result of the subtract to "s32" (or "int", whatever), or 
> cast _both_ of them to (s32) so that the subtract is done in a signed 
> type, and then the expansion to (long) will still be right - but 
> unnecessary - in the sign.

Btw, doing it with a nice helper macro or function is also perhaps a good 
idea, at least if these "compare hpet values" things happen more than 
once. 

Look at "time_after()" in <linux/jiffies.h> to see how to do these kinds 
of "comparisons of things that may overflow" really carefully. You 
absolutely need to do the compare in a size that is no larger than the 
size of the actual values (and in the case of HPET, it's 32-bit, at least 
the way we do things now - I guess HPET's _could_ be 64-bit, but we don't 
read more than 32 bits or whatever).

So <linux/jiffies.h> does the cast to "(long)", but it does so because the 
incoming values really have type "unsigned long" and are valid in all 
bits.

			Linus
