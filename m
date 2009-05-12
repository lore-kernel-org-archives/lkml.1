Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZELGp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZELGp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZELGpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:45:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50797 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZELGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:45:49 -0400
Date: Tue, 12 May 2009 08:51:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disable generation of sse3 instructions in kernel build.
Message-ID: <20090512065104.GC19296@one.firstfloor.org>
References: <200905091903.25745.lkml@morethan.org> <87skjbmjb2.fsf@basil.nowhere.org> <200905111847.46187.lkml@morethan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905111847.46187.lkml@morethan.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sending again with linux-kernel cc. Please don't drop cc list like this]

> On Mon May 11 2009, you wrote:
> > "Michael S. Zick" <lkml@morethan.org> writes:
> > 
> > > Ref: 2.6.30-rcX
> > > The option to disable sse3 instructions needs to be added to build system for x86.
> > > Otherwise strange and mysterious things happen (tm).
> > 
> > Can you please expand a little bit? With what compiler version did you        
> > see problems? And in what area did they happen?
> > 
> 
> Sorry about the comment - it was based on the preceding code comment - perhaps now outdated.

It's not outdated. I wrote it originally.

> 
> Once upon a time, the kernel did not touch the co-processor registers (any style of them) on x86 -
> see the preceding code comment and existing contents of the flag line being changed.
> 
> If the kernel now saves/restores the co-processor registers - then only the code comment needs
> to be changed and the existing contents of the flag line be brought into line.           

No the kernel doesn't do that. At least not automatically.

The reason these options are there is that at least some older gcc versions had
corner cases where they could generate instructions to touch MMX or SSE registers
even when the code doesn't use any floating point.  That's why these options
were originally added to make sure this doesn't happen in the kernel,
where it would corrupt user data or crash.

But sse3 is just an extension of sse2 and when sse2 is enabled then
sse3 should be implicitely too. Unless some gcc version is really broken in this
regard, but I hope not. That is why I was asking if you've actually
seen failures from this.

Apparently you did not though. So your patch is not needed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
