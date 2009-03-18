Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZCRXnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZCRXnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 19:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCRXmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 19:42:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbZCRXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 19:42:53 -0400
Date: Wed, 18 Mar 2009 16:36:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ying Han <yinghan@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
In-Reply-To: <604427e00903181618t66020557kda533d37f51d7e7d@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903181634500.17240@localhost.localdomain>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>  <20090318151157.85109100.akpm@linux-foundation.org>  <alpine.LFD.2.00.0903181522570.3082@localhost.localdomain> <604427e00903181618t66020557kda533d37f51d7e7d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Mar 2009, Ying Han wrote:
> >
> > Can you say what filesystem, and what mount-flags you use? Iirc, last time
> > we had MAP_SHARED lost writes it was at least partly triggered by the
> > filesystem doing its own flushing independently of the VM (ie ext3 with
> > "data=journal", I think), so that kind of thing does tend to matter.
> 
> /etc/fstab
> "/dev/hda1 / ext2 defaults 1 0"

Sadly, /etc/fstab is not necessarily accurate for the root filesystem. At 
least Fedora will ignore the flags in it.

What does /proc/mounts say? That should be a more reliable indication of 
what the kernel actually does. 

That said, I assume the ext2 part is accurate. Maybe that's why people 
haven't seen it - I guess most testing was done on ext3. It certainly was 
for me.

> > Ying Han - since you're all set up for testing this and have reproduced it
> > on multiple kernels, can you try it on a few more kernel versions? It
> > would be interesting to both go further back in time (say 2.6.15-ish),
> > _and_ check something like 2.6.21 which had the exact dirty accounting
> > fix. Maybe it's not really an old bug - maybe we re-introduced a bug that
> > was fixed for a while.
> 
> I will give a try.

Thanks,

		Linus
