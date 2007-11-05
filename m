Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbXKEAXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbXKEAXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXKEAXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:23:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47117 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbXKEAXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:23:40 -0500
Date: Sun, 4 Nov 2007 16:23:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
In-Reply-To: <alpine.LFD.0.999.0711041600280.15101@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0711041615380.15101@woody.linux-foundation.org>
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se> <472E50C5.5020201@goop.org>
 <472E5AB6.40509@zytor.com>
 <alpine.LFD.0.999.0711041600280.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, Linus Torvalds wrote:
> 
> So I'd suggest having both jumps back-to-back, but realistically, the 
> first regular short jump is actually the one that is more important. 
> That's the one that really matters on i386/i486 class machines, and later 
> CPU's will generally do the right thing even with _neither_ jump there.

That's obviously badly phrased.

The far jump is obviously required on all CPU's in order for us to 
actually finally get to 32-bit protected mode and reload CS, but what I 
*meant* was that we certainly also know that "unreal mode" works and is 
used by various strange DOS extenders, and that not doing the far jump 
isn't really required for having a "working setup" - it's just going to be 
a rather limited mode.

So the short jump is required for the code to *work*. The long jump is 
required only to get us the 32-bit mode we *want* and out of the odd 
"half-way" state. Two different issues.

		Linus
