Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZGSTzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZGSTzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 15:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZGSTzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 15:55:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51277 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGSTzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 15:55:23 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Athanasius <link@miggy.org>, Julien TINNES <jt@cr0.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix PER_CLEAR_ON_SETID (CVE-2009-1895)]
From: Andi Kleen <andi@firstfloor.org>
References: <20090718202512.GA19587@suse.de>
	<alpine.LFD.2.01.0907181342500.13838@localhost.localdomain>
	<20090718212812.GI6722@miggy.org> <4A6278FD.20807@cr0.org>
	<20090719122701.GJ6722@miggy.org>
	<alpine.LFD.2.01.0907191219230.13838@localhost.localdomain>
Date: Sun, 19 Jul 2009 21:55:19 +0200
In-Reply-To: <alpine.LFD.2.01.0907191219230.13838@localhost.localdomain> (Linus Torvalds's message of "Sun, 19 Jul 2009 12:27:05 -0700 (PDT)")
Message-ID: <87r5wc4fdk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Other binaries are unhappy with address space randomization because they 
> need to get the absolute maximum contiguous VM space for some big array. 
> Ok, so that's less of an issue in 64-bit mode, but there really are 
> programs out there that link everything statically and want to run at a 
> low virtual address so that they can get 2.5GB of virtual memory for one 
> single big allocation. I've written crap like that myself. I'm not _proud_ 
> of it, but I could easily see that programs like that could be unhappy if 
> the system wiggles mmap's around for security issues.

Another common reason for not supporting randomized mappings is
when the program loads a "core file" that has pointers to data
on each boot, as a faster way to initialize data structures. 
That's common with LISP like languages for example, but even
e.g. gcc's pre compiled headers implementation works like this.

> Because compatibility is always of paramount importance.

If you want to give it a security angle: not supporting 
an old application anymore is a very severe DoS attack
for people using it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
