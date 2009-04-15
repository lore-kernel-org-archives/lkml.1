Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZDOW7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZDOW7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZDOW6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:58:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:7468 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbZDOW6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z6fbYT4tT5Ov4va0MpPQgoq69fGRsTa1DpqKls6uBqbUQ7QiVMRGPs+rdfenKqlhD/
         yuaKoFgNW3RMztmO7b4BG6fUxAFoi1u81ueIEvi3r50uzhO3aHqPPweFqoLG6CBa2Fsp
         BX6HYa/Hc+yU0gU/u+wPu7/AC7UT4wyKanAAE=
MIME-Version: 1.0
In-Reply-To: <20090414090146.GH27003@elte.hu>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
	 <20090414045109.GA26908@orion> <20090414090146.GH27003@elte.hu>
Date: Thu, 16 Apr 2009 02:58:44 +0400
Message-ID: <a4423d670904151558r4252c7eamd115793fb36a9163@mail.gmail.com>
Subject: Re: [tree] latest kill-the-BKL tree, v12
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/14 Ingo Molnar <mingo@elte.hu>:
>
> * Alexander Beregalov <a.beregalov@gmail.com> wrote:
>
>> On Tue, Apr 14, 2009 at 05:34:22AM +0200, Frederic Weisbecker wrote:
>> > Ingo,
>> >
>> > This small patchset fixes some deadlocks I've faced after trying
>> > some pressures with dbench on a reiserfs partition.
>> >
>> > There is still some work pending such as adding some checks to ensure we
>> > _always_ release the lock before sleeping, as you suggested.
>> > Also I have to fix a lockdep warning reported by Alessio Igor Bogani.
>> > And also some optimizations....
>> >
>> > Thanks,
>> > Frederic.
>> >
>> > Frederic Weisbecker (3):
>> >   kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
>> >   kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
>> >   kill-the-BKL/reiserfs: only acquire the write lock once in
>> >     reiserfs_dirty_inode
>> >
>> >  fs/reiserfs/inode.c         |   10 +++++++---
>> >  fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
>> >  fs/reiserfs/super.c         |   15 +++++++++------
>> >  include/linux/reiserfs_fs.h |    2 ++
>> >  4 files changed, 44 insertions(+), 9 deletions(-)
>> >
>>
>> Hi
>>
>> The same test - dbench on reiserfs on loop on sparc64.
>>
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.30-rc1-00457-gb21597d-dirty #2
>
> I'm wondering ... your version hash suggests you used vanilla
> upstream as a base for your test. There's a string of other fixes
> from Frederic in tip:core/kill-the-BKL branch, have you picked them
> all up when you did your testing?
>
> The most coherent way to test this would be to pick up the latest
> core/kill-the-BKL git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL
>

I did not know about this branch, now I am testing it and
there is no more problem with that testcase (dbench).

I will continue testing.

Thanks.
