Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0BASls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:41:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687Ab0BASlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:41:47 -0500
Date: Mon, 1 Feb 2010 10:41:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jason Wessel <jason.wessel@windriver.com>
cc: Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions -
 221af7f87b97431e3ee21ce4b0e77d5411cf1549
In-Reply-To: <4B671865.5030705@windriver.com>
Message-ID: <alpine.LFD.2.00.1002011036540.4206@localhost.localdomain>
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain> <4B671865.5030705@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Jason Wessel wrote:
> 
> Add to the afflicted architecture list a ppc64 kernel running 32 bit
> user space apps such as a dynamically linked busybox:

The ppc issue was known - I informed the ppc people before committing, as 
they were actually using the same insane trick (along with sparc) that x86 
had to work around the bad calling conventions.

So x86, sparc and ppc were actually the main targets of the cleanup, the 
powerpc patch just wasn't ready in time. But it's merged now (got a pull 
request today), so powerpc should be ok now too (commit 94f28da84: 
"powerpc: TIF_ABI_PENDING bit removal").

The microblaze thing is different, exactly because microblaze does _not_ 
have any of that insane 32-vs-64-bit executable fiddling that this cleanup 
was all about. So microblaze I'd have expected to be totally unaffected, 
and must be about something else.

				Linus
