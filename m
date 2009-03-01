Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbZCAOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbZCAOnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbZCAOnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:43:06 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:45781 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZCAOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:message-id:user-agent
         :mime-version:content-type;
        b=mNV5lZNRJzvbOFZL8tvRN1mCI2ZE0bMDjfaCQs2nkWwQ9SWXoPxoMHil/1fUIljZs2
         dRxypBbqYMhcfccCMTpz7JuuyzpY26HSY5OsUwVgjhxulyMb0NmalSbKlcAFJRhHxX2d
         GKYTfUk7aMNlUERt3DW5yfg+/uu6fL2kJCU80=
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Question regarding concurrent accesses through block device and fs
References: <m2hc2yulrw.fsf@gmail.com>
	<200902200044.48328.nickpiggin@yahoo.com.au>
	<38b2ab8a0902200610i6c91725cjc91adca31042daa9@mail.gmail.com>
	<200902231458.32911.nickpiggin@yahoo.com.au>
From: Francis Moreau <francis.moro@gmail.com>
Date: Sun, 01 Mar 2009 15:42:55 +0100
Message-ID: <m2ab85nw28.fsf@gmail.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Sorry for being long to answer but I was off, I'm slow and there are
  a lot of complex code to dig out ! ]

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Saturday 21 February 2009 01:10:24 Francis Moreau wrote:

[...]

>>   - looking at unmap_underlying_metadata(), there's no code to deal with
>>     meta data buffers. It gets the buffer and unmap it whatever the type of
>>     data it contains.
>
> That's why I say it only really works for buffer cache used by the same
> filesystem that is now known to be unused.
>

hum, I still don't know what you mean by this, sorry to be slow.


[...]

>> What am I missing ?
>
> That we might complete the write of the new buffer before the
> old buffer is finished writing out?

Ah yes actually I realize that I don't know where and when the inode
blocks are effectively written to the disk !

It seems that write_inode(), called after data are commited to the
disk, only marks the inode buffers as dirty but it performs no IO (at
least it looks so for ext2 when its 'do_sync' parameter is 0 which is
the case when this method is called by write_inode()).

Could you enlight me one more time ?

Thanks
-- 
Francis
