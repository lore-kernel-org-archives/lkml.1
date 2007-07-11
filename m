Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbXGKWEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbXGKWEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbXGKWEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:04:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759171AbXGKWE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:04:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: Linus Torvalds's message of  Wednesday, 11 July 2007 14:45:51 -0700 <alpine.LFD.0.999.0707111443180.20061@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Windows: even not doing anything would have been better than nothing.
Message-Id: <20070711220423.98F324D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 15:04:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, we've made that mistake before, and I'm not saying we are perfect 
> here, but if we make this world-readable, I think it needs to guarantee it 
> doesn't really give any rootkit people any new information.

It will give them at least as reliable an identification of the kernel
binary as the "uname -rv" info if they have access to a set of candidate
known binaries to select from.  It's of no direct help at all in getting
anything like kernel addresses.  In practice, it is probably no easier for
a rootkit to use than "uname -rv" to pick an exploit for a particular known
distro kernel binary, just easier for legitimate debugging tools.  I think
it's not only more harmless than what you might call "past mistakes", but
is actually just plain harmless.  But I'm not really one to talk a man out
of his paranoia.

> And yes, I do think normal people shouldn't be able to read the vmlinuz 
> binary, the same way they are generally not allowed to read /etc/grub.conf 
> etc.

I have no special opinions about that, but I haven't seen an install where
the /boot files were not readable anyway.  But certainly in a chroot or
such, you won't have /boot at all but might have /proc and /sys.

All in all, this seems like a question of local policy.  Ideally the modes
would be flexibly chosen by admins, or else constrained more precisely by
SELinux policy or suchlike.  But I have no axe to grind on the subject with
this particular change.  I care more that the feature gets in and at least
root can use it, than about the permissions question.


Thanks,
Roland
