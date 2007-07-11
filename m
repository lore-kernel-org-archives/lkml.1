Return-Path: <linux-kernel-owner+w=401wt.eu-S934357AbXGKWSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbXGKWSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765833AbXGKWSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:18:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934249AbXGKWSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:18:39 -0400
Date: Wed, 11 Jul 2007 15:17:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: <20070711220423.98F324D0555@magilla.localdomain>
Message-ID: <alpine.LFD.0.999.0707111513400.20061@woody.linux-foundation.org>
References: <20070711220423.98F324D0555@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Roland McGrath wrote:
> 
> It will give them at least as reliable an identification of the kernel
> binary as the "uname -rv" info if they have access to a set of candidate
> known binaries to select from.

Ok, that doesn't sound bad. Is the "note" something global for the whole 
thing, or are there per-object file notes that you can parse (ie can you 
figure out which modules are linked in some way?)

If it's basically just a set of hashes, I won't worry.

> I have no special opinions about that, but I haven't seen an install where
> the /boot files were not readable anyway.  But certainly in a chroot or
> such, you won't have /boot at all but might have /proc and /sys.

Yah. Not that we generally do perfectly here, but that's the kind of thing 
I'd prefer.

> All in all, this seems like a question of local policy.

Is there any reason for it to be readable by anybody but the sysadmin? 
It's not like you're likely to do things like kernel debugging without 
root privileges?

So if the *common* thing is that normally people have root who really 
care, and the distro could (if it wants to) just chmod the /sysfs file 
appropriately, maybe that would allow the best of both worlds? Just 
default to it being root-readable, but let the distro override it at 
boot-time?

		Linus
