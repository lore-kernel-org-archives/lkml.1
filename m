Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbZCAVHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbZCAVHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 16:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZCAVHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 16:07:41 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:54173 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZCAVHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 16:07:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=OtGXlzhvewCnCJL4IY4NnslXca+fRDcqL7g3AMukvo46H5nUFlPoFV47AAclFVraQR
         QIKYQnHpTEQhrmRLVfXcu2bZqfSyMMDDIEqnkjTQM8o1Ndu07N2/NeZTdKk5mwNI3S9+
         f0PJpf7CDERwxHfHWipAQKc5ICEe7Fp2y/G5o=
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Question regarding concurrent accesses through block device and fs
References: <m2hc2yulrw.fsf@gmail.com>
	<200902231458.32911.nickpiggin@yahoo.com.au>
	<m2ab85nw28.fsf@gmail.com>
	<200903020232.48311.nickpiggin@yahoo.com.au>
From: Francis Moreau <francis.moro@gmail.com>
Date: Sun, 01 Mar 2009 22:07:30 +0100
In-Reply-To: <200903020232.48311.nickpiggin@yahoo.com.au> (Nick Piggin's message of "Mon\, 2 Mar 2009 02\:32\:48 +1100")
Message-ID: <m2y6vplzot.fsf@gmail.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Monday 02 March 2009 01:42:55 Francis Moreau wrote:

[...]

> OK, the "buffercache", the cache of block device contents, is normally
> thought of as metadata when it is being used by the filesystem (eg.
> usually via bread() etc), or data when it is being read/written from
> userspace via /dev/<blockdevice>.
>
> In the former case, the buffer.c/filesystem code together know when a
> metadata buffer is unused (because the filesystem has deallocated it),
> so unmap_underlying_metadata will work there.
>
> And it is insane to have a mounted filesystem and have userspace working
> on the same block device, so unmap_underlying_metadata doesn't have to
> care about that case. (IIRC some filesystem tools can do this, but there
> are obviously a lot of tricks to it)

Thanks for clarifying this.

[...]

> Depends on the filesystem. Many do just use the buffercache as a
> writeback cache for their metadata, and are happy to just let the
> dirty page flushers write it out when it suits them

I guess you're talking about the pdflush threads here.

This is the case where I can't find when the metadata are actually
written back to the disk by the flushers. I looked at
writback_inodes() but I fail to find this out.

Could you point out the place in the code where this happen ?

> (or when there are explicit sync instructions given).

yes I see where this happens in these cases.

> Most of the time, these filesystems don't really know or care when
> exactly their metadata is under writeback.

This sounds very weird to me but I need to learn how things work
before doing any serious comments.

thanks
-- 
Francis
