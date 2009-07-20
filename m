Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZGTSQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZGTSQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZGTSQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:16:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbZGTSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:16:31 -0400
Date: Mon, 20 Jul 2009 11:16:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Damien Wyart <damien.wyart@free.fr>
cc: Greg KH <gregkh@suse.de>, Wolfgang Walter <wolfgang.walter@stwm.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
In-Reply-To: <20090720180333.GA2905@brouette>
Message-ID: <alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de> <20090720150916.GB10015@suse.de> <20090720180333.GA2905@brouette>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Damien Wyart wrote:
> 
> I am seeing a similar problem (no hang but an immediate reboot) on the
> same distro. I tried to bisect but got no good kernel in the end.
> 
> To clarify things I recompiled again 2.6.30.1 with the orginial .config
> and it also failed to boot (I was happy to have renamed it so the
> working kernel was still available). I suspected a recent gcc 4.3
> upgrade so downgraded gcc, but no luck, still getting the same problem.
> So for now I am quite stuck, but there is clearly a bad problem
> somewhere...

Hmm. So you _had_ a working self-compiled 2.6.30 kernel at some point?

One thing to look out for is that a compiler upgrade/downgrade will be 
invisible to the kernel build system, so if you downgrade the compiler and 
recompile, you may not actually recompile things at all.

The kernel build system _should_ notice when the build flags change, but 
gcc versions changing under it, not so much. So you might want to do a 
"make clean" to be sure.

And quite frankly, I'm not 100% sure even that will always do it.

Why? Many distro's use ccache, and so you may actually get a cached object 
file from a previous compile (with a previous compiler). Now, ccache is 
pretty good at noticing when things change, and I can well imagine that it 
also checks the compiler version (in addition to checking the hash of the 
preprocessed output and build flags etc), but I haven't double-checked.

So to make doubly sure that you really don't end up using cached object 
files, you might want to run "ccache -C".

			Linus
