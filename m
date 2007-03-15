Return-Path: <linux-kernel-owner+w=401wt.eu-S1422968AbXCOQ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422968AbXCOQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422971AbXCOQ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:58:25 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:53655 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422968AbXCOQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:58:24 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <1173977264.7922.24.camel@localhost.localdomain>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu>
	 <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
	 <45F96B57.10206@mbligh.org>
	 <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
	 <20070315160648.GA11812@one.firstfloor.org>
	 <1173977264.7922.24.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 12:57:19 -0400
Message-Id: <1173977839.7922.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 12:47 -0400, Steven Rostedt wrote:
> On Thu, 2007-03-15 at 17:06 +0100, Andi Kleen wrote:
> 
> > Well I just see a lot of pain from these patches but I doubt 
> > they will avoid any bugs. If people don't compile test both
> > archs they will always likely break on another. There are lots
> > of subtle dependencies that are not expressed in the pathname
> > even after this intrusive operation (e.g. in the includes).

[...]

> With the proposed patch set, what can break i386 by modifying something
> in arch/x86_64, or what can break x86_64 by modifying something in
> arch/i386? (not counting the unfinished pci shared code).

Oops, sorry, you did say "in the includes".  Yeah, that holds the same
crap that I'm talking about. 

$ cat include/asm-i386/stacktrace.h
#include <asm-x86_64/stacktrace.h>

Which isn't something that I would like to stay either. So it's just
something else that needs to be fixed. Not something that will
circumvent what the current patch set is trying to do.

-- Steve


