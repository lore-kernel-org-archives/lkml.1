Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYICMNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYICMNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYICMMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:12:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYICMMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:12:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
In-Reply-To: Alexey Dobriyan's message of  Wednesday, 27 August 2008 02:55:19 +0400 <20080826225519.GC27724@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain>
	<20080826220157.397C7154233@magilla.localdomain>
	<20080826225519.GC27724@x200.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080903121127.2B368154228@magilla.localdomain>
Date: Wed,  3 Sep 2008 05:11:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, embed struct utrace directly into task_struct. task_struct
> lifetime rules are way more tested than struct utrace ones.

The most consistent feedback I've seen to all new features is that they
mustn't add overhead when they're not being used.  So I never considered it
an option to bloat task_struct by ~120 bytes.  Of course much more than
that is entailed when a task is actually being traced somehow.  But the
presumption is that most tasks most of the time aren't, and that's what not
to bloat.

The revamp of the API after the first prototype made some of the internals
much simpler to implement, that had been very sticky in the old prototype
code.  But the allocation and freeing of struct utrace is an area I did not
fully revisit.  Buggy is buggy, and sure it needs to be tested and fixed.
I'm still inclined to look into making it right rather than punting.

> Add simple spinlock guarding all accesses (OK, I haven't looked very
> closely if it's possible)

I can't tell what you mean here.  Do you mean something different 
from struct utrace.lock?  If there were no pointer and its allocation
to synchronize, then what other lock would you be adding?

> INIT_RCU_HEAD is not needed, call_rcu() will overwrite rcu head unconditionally.

I see.  Thanks!  At some point, this was in the recommended example uses of
RCU.  This macro is still used in several places around the kernel.
Shouldn't they all be removed?  I wonder why it still exists in rcupdate.h.


Thanks,
Roland
