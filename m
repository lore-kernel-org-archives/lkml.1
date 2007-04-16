Return-Path: <linux-kernel-owner+w=401wt.eu-S1030984AbXDPV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030984AbXDPV4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030989AbXDPV4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:56:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56481 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030985AbXDPV4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:56:18 -0400
Date: Mon, 16 Apr 2007 22:57:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [AppArmor 31/41] Fix __d_path() for lazy unmounts and make it
 unambiguous; exclude unreachable mount points from /proc/mounts
Message-ID: <20070416225748.3e5d3003@the-village.bc.nu>
In-Reply-To: <200704151940.22528.agruen@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090846.670863000@suse.de>
	<20070412105825.15f4df39@the-village.bc.nu>
	<200704151940.22528.agruen@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > That is a fairly significant and sudden change to the existing
> > kernel/user interface.
> 
> Well, this is not meant for 2.6.21. I hope it is possible to change it in 
> early 2.6.22; otherwise if we can't fix mistakes from the past we are pretty 
> doomed.

I don't believe the existing behaviour _IS_ a mistake.

> > This is untrue. The process can get there (via fd passing with another
> > task)
> 
> Process can access file descriptors which are unreachable via path name just 
> fine indeed, but those fds still don't have a valid path in the context of 
> that process.

Which while problematic to your name based security is just fine to
everything else. 

> We are only talking about mount points unreachable by a particular process; 
> this does not mean that the mount point isn't reachable by other processes. 
> Human operators can choose the context from which they are looking 
> at /proc/mounts. If they are looking form the "real" root, the will see all 
> mounts that any process can reach (in that namespace).

Ok, providing the "real" root sees them all it isn't so bad, but to
assume you can filter based upon what the task can see is dodgy as an
assumption.
