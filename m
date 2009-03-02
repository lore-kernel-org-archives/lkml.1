Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZCBNab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZCBNab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZCBNaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:30:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:17611 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCBNaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:30:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UW4CQcnSDQTrGcz1Kt8/hCwwQQ3rHURnCrs8gUX3vfL5fGitxw7F8Tu/tyMoo1RBV6
         tNWxTKi+y8SP3fxxFcMhbMYfVQBs+m/kLKM646vmXooadeK98eWtmnZnlEmPGnXcu+Jb
         MOnGoGMHgCnwLXLSsfEhQNzZP45b4z/lAaxss=
MIME-Version: 1.0
In-Reply-To: <200903021811.43653.nickpiggin@yahoo.com.au>
References: <m2hc2yulrw.fsf@gmail.com>
	 <200903020232.48311.nickpiggin@yahoo.com.au>
	 <m2y6vplzot.fsf@gmail.com>
	 <200903021811.43653.nickpiggin@yahoo.com.au>
Date: Mon, 2 Mar 2009 14:30:18 +0100
Message-ID: <38b2ab8a0903020530j18921202r32f73382ff5f0aa@mail.gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and 
	fs
From: Francis Moreau <francis.moro@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Monday 02 March 2009 08:07:30 Francis Moreau wrote:
>> This is the case where I can't find when the metadata are actually
>> written back to the disk by the flushers. I looked at
>> writback_inodes() but I fail to find this out.
>>
>> Could you point out the place in the code where this happen ?
>
> I guess it picks them up via their block device inodes.

Probably but I don't find the actual place.

I looked at the place where page are normally written back to disk (ie
in background_writeout()) but I can see only the writeback of data, not
metadata...

>> This sounds very weird to me but I need to learn how things work
>> before doing any serious comments.
>
> Why would they? They just operate on their metadata, and the buffer
> cache is basically a transparent writeback cache to them.

Well the fact that metadata are written back to disk at an unknown point
in the time means that we don't know in which order metadata and data
are written. So it means that data can be written before or after
metadata or they can be mixed up.

And this sounds just weird to me. But as I said I'm just a noob so I
need to think and study more on this area and I really have to see where
the actual writes of metadata happen in the code.

> In the same way, an application doesn't really know or care when
> exactly its data is under writeback.

Except when dealing with metadata of the fs, we can corrupt the whole
thing, I think.

> unmap_underlying_metadata is the important exception because Linux
> pagecache otherwise doesn't have a good way to keep pagecache of
> different mappings coherent. So if a block switches from buffercache
> to file mapping, it needs to be made coherent.
>
> When switching back the other way, the truncate code actually makes
> sure of this, that there won't be blocks under writeout after
> being deallocated.
>
> Things do get more complicated with journalling file systems.
>

I think I'll just forget about them, things are currently enough
complicated to make them more obscure ;)

thanks
-- 
Francis
