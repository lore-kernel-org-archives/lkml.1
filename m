Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbYKGN3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbYKGN3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYKGN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:29:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKGN3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:29:34 -0500
Date: Fri, 7 Nov 2008 08:29:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Matt Fleming <mjf@gentoo.org>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu
Subject: Re: [PATCH] ftrace: Allow section alignment
In-Reply-To: <1226063896.2697.28.camel@twins>
Message-ID: <alpine.DEB.1.10.0811070825580.27455@gandalf.stny.rr.com>
References: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com> <1226063896.2697.28.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Nov 2008, Peter Zijlstra wrote:

> On Fri, 2008-11-07 at 13:12 +0000, Matt Fleming wrote:
> > Provide a means of aligning the __mcount_loc section.
> 
> Not that I object to the patch, but this changelog needs work.
> 
> Its wrong, it doesn't provide means, it plain does.
> It doesn't tell us why.

Also, please tell us what broke. Did you have a compiler that did
not align it properly?  As long as the alignment is less than or equal to 
the word size, it is fine. If the alignment is larger than the word size, 
then there will be holes in the mcount_loc section and that will break 
ftrace. Heck, an alignment of 1 should work for everyone ;-) All the 
sections are packed together in an aligned space when it is pulled in by 
the linker. If that is not true, then the linker script needs to be fixed.

-- Steve
