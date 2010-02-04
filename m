Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0BDFki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:40:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab0BDFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:40:36 -0500
Date: Wed, 3 Feb 2010 21:39:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ben Hutchings <ben@decadent.org.uk>
cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stable-review@kernel.org
Subject: Re: [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
In-Reply-To: <1265256174.2952.11.camel@localhost>
Message-ID: <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Ben Hutchings wrote:
> 
> I'm using Debian i386 (i.e. 32-bit userland) with a 64-bit kernel.
> After applying commit 221af7f to Debian's kernel source (approximately
> equivalent to 2.6.32.7), the kernel fails to exec init.  After commit
> 7ab02af it can exec init but that immediately segfaults:

It sounds like you have picked individual commits.

But you don't mention commit 05d43ed8a, which is also a required part of 
the series.

So you _should_ have a combination of
 - 221af7f87 ("Split 'flush_old_exec' into two functions")
 - 05d43ed8a ("x86: get rid of the insane TIF_ABI_PENDING bit")
 - 7ab02af42 ("Fix 'flush_old_exec()/setup_new_exec()' split")

(and there are also additional sparc/ppc versions of that TIF_ABI_PENDING 
bit removal, but they shouldn't matter on your system)

		Linus
