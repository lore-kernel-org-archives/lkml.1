Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbXJaQAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbXJaQAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbXJaQAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:00:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010AbXJaQAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:00:36 -0400
Date: Wed, 31 Oct 2007 08:59:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
In-Reply-To: <20071031151934.GA19211@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
 <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
 <20071031151934.GA19211@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Oct 2007, Nick Piggin wrote:
> 
> Well the patch is right, in the context of the regression I introduced
> (and so it should probably go into 2.6.23).

Yeah, it probably is fine for -stable.

And if mine (which actually changes behaviour, in that it makes ptrace get 
an access error) causes regressions, I guess we'll have to use that 
compatible-with-old-behaviour one for 2.6.24 too.

But I just rebooted and tested - the cleaned-up patch does seem to work 
fine, and I get "Cannot access memory at address <xyz>" rather than any 
reported problem.

So I think I'll commit my version asap, and see if anybody reports that 
they have a situation where they use ptrace() and expect zero back from a 
shared mapping past the end.. And if there are issues, we can switch back 
to the old broken behaviour with your patch,

		Linus
