Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZE3EXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZE3EXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 00:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZE3EXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 00:23:44 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:49103 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZE3EXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 00:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PYZeA3S03DclNLn2OV8fIdzQ5o2vH6uz5qZ3ZjKdyOePqwEggvyUjTajRkwycF89BF
         BrbSfnjAkFLn9whP9hhwDheXSwGZLGZaA8traGDgxA7k/bspxIoHmK9W5VIEmD0NGBWX
         hr/PyXv9v1kN9t9kMYQBKc01IoyJ4g5o04DFE=
MIME-Version: 1.0
In-Reply-To: <20090530032253.GA5999@nowhere>
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
	 <1242496922-6330-2-git-send-email-fweisbec@gmail.com>
	 <9b1675090905292005p2b53de7dy9e36f84368d76f01@mail.gmail.com>
	 <20090530032253.GA5999@nowhere>
Date: Fri, 29 May 2009 22:23:44 -0600
Message-ID: <9b1675090905292123l7c3de4b6w897e153d60e5a469@mail.gmail.com>
Subject: Re: [PATCH 1/2] kill-the-bkl/reiserfs: acquire the inode mutex safely
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 9:22 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, May 29, 2009 at 09:05:31PM -0600, Trenton D. Adams wrote:
>> On Sat, May 16, 2009 at 12:02 PM, Frederic Weisbecker
>> <fweisbec@gmail.com> wrote:
>> > While searching a pathname, an inode mutex can be acquired
>> > in do_lookup() which calls reiserfs_lookup() which in turn
>> > acquires the write lock.
>> >
>> > On the other side reiserfs_fill_super() can acquire the write_lock
>> > and then call reiserfs_lookup_privroot() which can acquire an
>> > inode mutex (the root of the mount point).
>> >
>> > So we theoretically risk an AB - BA lock inversion that could lead
>> > to a deadlock.
>> >
>> > As for other lock dependencies found since the bkl to mutex
>> > conversion, the fix is to use reiserfs_mutex_lock_safe() which
>> > drops the lock dependency to the write lock.
>> >
>>
>> I'm curious, did this get applied, and is it related to the following?
>>  I was having these in 2.6.30-rc3.  I am now on 2.6.30-rc7 as of
>> today.  I haven't seen them today.  But then again, I only seen this
>> happen one time.
>
>
> Hi,
>
> No, may be it will come for 2.6.31 but for now it is not merged so
> it's not related.
>
> If you see such warning anymore, don't hesitate to tell about
> it!
>
> Thanks!
>

I was trying to imply that the patch might fix the problem I saw, not
that it was the cause.  I only though that because it mentioned a
potential deadlock, and it seems like that is what the problem I saw
was.
