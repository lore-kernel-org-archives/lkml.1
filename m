Return-Path: <linux-kernel-owner+w=401wt.eu-S934579AbXGKWmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579AbXGKWmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbXGKWmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:42:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbXGKWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:42:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: Linus Torvalds's message of  Wednesday, 11 July 2007 15:17:47 -0700 <alpine.LFD.0.999.0707111513400.20061@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070711224207.48F464D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 15:42:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, that doesn't sound bad. Is the "note" something global for the whole 
> thing, or are there per-object file notes that you can parse (ie can you 
> figure out which modules are linked in some way?)

Usually there is one per final link, so one in vmlinux and one in each .ko.
There is nothing you can figure out from the bitstring except to match it
with known binaries.

> If it's basically just a set of hashes, I won't worry.

It's just one hash.  (Each .ko has one too, but I didn't bother with the
/sys/module/name/notes hack because it was too much trouble.)

> Is there any reason for it to be readable by anybody but the sysadmin? 
> It's not like you're likely to do things like kernel debugging without 
> root privileges?

I do kernel debugging all the time, but I am not usually root.  It's not
that I can't be root any time, of course--I'm usually using a machine where
I can sudo with no password.  But when I was young they taught me not to be
root whenever you don't have to, because I know I'm bound to break
something with a slip of the finger even when I surely ought to know
better.  So I don't run analysis tools as root, just use sudo when I need
to actually change something, or fetch a protected log to look at.

> So if the *common* thing is that normally people have root who really 
> care, and the distro could (if it wants to) just chmod the /sysfs file 
> appropriately, maybe that would allow the best of both worlds? Just 
> default to it being root-readable, but let the distro override it at 
> boot-time?

If distros are prepared for the notion of chmod's in /sys, that sounds
fine.  I presume you would want to uniformly change most of /sys, where
many things in /sys/module and /sys/kernel can be pretty revealing.  Like I
said, I have no special opinions about the permissions.  On all the systems
I use myself, everyone has ready access to the complete source and binaries
anyway (and can run dmesg).


Thanks,
Roland
