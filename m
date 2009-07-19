Return-Path: <linux-kernel-owner+w=401wt.eu-S1751235AbZGST27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbZGST27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 15:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZGST24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 15:28:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbZGST2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 15:28:55 -0400
Date: Sun, 19 Jul 2009 12:27:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Athanasius <link@miggy.org>
cc: Julien TINNES <jt@cr0.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix PER_CLEAR_ON_SETID
 (CVE-2009-1895)]
In-Reply-To: <20090719122701.GJ6722@miggy.org>
Message-ID: <alpine.LFD.2.01.0907191219230.13838@localhost.localdomain>
References: <20090718202512.GA19587@suse.de> <alpine.LFD.2.01.0907181342500.13838@localhost.localdomain> <20090718212812.GI6722@miggy.org> <4A6278FD.20807@cr0.org> <20090719122701.GJ6722@miggy.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 19 Jul 2009, Athanasius wrote:
> 
>   And it's that "as long as we ..." that still bothers me.  I've *never*
> had any need for any use of this personality feature and this net/tun.c
> exploit has proven there can be security gotchas with it.

I do agree. Some of those features may not be worth the cost.

That said, this particular feature made sense at the time it was 
implemented. Some people really _did_ care about running SVR4 binaries on 
Linux. There was a time when it was seen as a feature, and important 
enough to work with. So that "map a zero page at NULL" was an important 
thing that we wanted such binaries to be able to depend on.

These days? We could probably get rid of that idiotic feature. It's simply 
not important enough any more. Does anybody really care? At the same time, 
over years we've grown _other_ personality flags, and some of them are 
still relevant.

Some binaries are unhappy with address space randomizations. Sometimes 
it's because of outright bugs (that just were hidden by non-randomized VM 
layout) - but that doesn't really help, does it? If you depend on that 
binary, as a user you want the ability to say "run this binary in a mode 
where it works".

Other binaries are unhappy with address space randomization because they 
need to get the absolute maximum contiguous VM space for some big array. 
Ok, so that's less of an issue in 64-bit mode, but there really are 
programs out there that link everything statically and want to run at a 
low virtual address so that they can get 2.5GB of virtual memory for one 
single big allocation. I've written crap like that myself. I'm not _proud_ 
of it, but I could easily see that programs like that could be unhappy if 
the system wiggles mmap's around for security issues.

So I do agree that we can probably get rid of some really dated 
personality bits. But I don't think we can really get rid of the concept. 
Because compatibility is always of paramount importance.

		Linus
