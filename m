Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbXIPRPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbXIPRPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXIPRPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:15:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbXIPRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:15:33 -0400
Date: Sun, 16 Sep 2007 10:14:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
In-Reply-To: <20070916094001.d87ed0f0.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
 <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com>
 <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
 <46EC6F2A.5090008@oracle.com> <alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
 <20070916094001.d87ed0f0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Sep 2007, Randy Dunlap wrote:
> 
> I'll apply this patch today, but I haven't done so yet (for the 2
> bug reports below).

Actually, it's probably better that you don't change your situation 
unnecessarily, in case the bug goes away.

Since you are triggering the problem even *without* the patch, whatever 
crashme is doing now for you is the interesting case.

I suspect NX just isn't active for you, so the mprotect doesn't matter, 
but if it *does* matter, that's interesting in itself.

> Then I'll back up more, prior to 2.6.22 (which got the Huh? message and 
> kept going).

Ahh, ok, so this is not a new thing, and it happened in 2.6.22 too.

I'm really starting to suspect some early EM64T bug, and I also suspect 
that it's harmless but that we should just do the trivial patch to say "if 
the register state is in user mode, we don't care if the CPU says it was a 
kernel access".

			Linus
