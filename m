Return-Path: <linux-kernel-owner+w=401wt.eu-S1764732AbYBZVSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764732AbYBZVSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYBZVSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:18:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30485 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYBZVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:18:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=m9w8mWvz92iR/zVdkXcRwAafLWpyXToiAqtuxQAQ9nJ6W+tAPcVEo/iZZz9V58Trf
	DaLyL/gNYf+bduBB4ymMg==
Date: Tue, 26 Feb 2008 13:17:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
In-Reply-To: <20080226114417.c8948b61.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802261306110.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com> <20080226114417.c8948b61.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Paul Jackson wrote:

> Perhaps I missed it, but could you elaborate on what sort of testing
> these patches for MPOL_F_RELATIVE_NODES and MPOL_F_STATIC_NODES have
> received?
> 

Both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES only really change the 
implementation when a new mempolicy is created and on rebind.

So it's possible to test both of these areas by booting with numa=fake=8, 
setting up a cpuset, hacking numactl to allow |static or |relative options 
to be passed, changing the cpuset's mems, and checking the result.  Then 
you can repeat that process with a different set of initial cpuset mems 
and a different syscall nodemask.

	# mount -t cpuset none /dev/cpuset
	# mkdir /dev/cpuset/test
	# cd /dev/cpuset/test
	# echo 0-3 > cpus
	# echo 1-3 > mems
	# echo $$ > tasks
	# numactl --interleave|static=2-4 bash
	# numactl --show
	[should be interleave over 2-3]
	# echo 4-6 > mems
	[should be "interleave" over 4]
	# numactl --show

> In particular, do we know that Oracle works with this?  At least in
> years past, when Andi was the primary developer here, he had some
> good and detailed awareness of what it took to keep Oracle happy
> with this NUMA memory policy apparatus.  I don't know if we still
> have that awareness.
> 

I don't understand what Oracle has to do with anything here, it is up to 
the programmer to determine whether he wants to use MPOL_F_STATIC_NODES or 
MPOL_F_RELATIVE_NODES for the benefit of his or her application.  There's 
now a method for doing that, specifically with optional mempolicy mode 
flags.

If you have any examples of unexpected behavior after applying my 
patchset, please post it and I'll fix it rather quickly.

		David
