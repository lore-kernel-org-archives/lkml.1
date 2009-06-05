Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZFEVm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZFEVm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZFEVmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:42:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZFEVmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:42:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=S53FrziPwvUvfrG/rcInK9brO7tkMUNfrlfnTR2D8qWLupLP+3pnikJSwk7BUTzuF
	Yjjth0zYVvr8egtAH3eRg==
MIME-Version: 1.0
In-Reply-To: <20090605180125.GB6442@mit.edu>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com>
	 <20090605180125.GB6442@mit.edu>
Date: Fri, 5 Jun 2009 14:42:18 -0700
Message-ID: <6601abe90906051442t294c2e79i3c6dc38c1d53e5e0@mail.gmail.com>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
From: Curt Wohlgemuth <curtw@google.com>
To: Theodore Tso <tytso@mit.edu>, Aioanei Rares <krnl.list@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 11:01 AM, Theodore Tso<tytso@mit.edu> wrote:
> On Fri, Jun 05, 2009 at 05:40:33PM +0300, Aioanei Rares wrote:
>>> When I upgrade libc from 2.7 (debian stable) to 2.9 (debian unstable),
>>> the locale breaks every reboot, and I have to repair it by running
>>> locale-gen.  This happened now when I only upgraded libc, in order to
>>> play with signalfd().  It also happened before, when I upgraded the
>>> entire machine to debian unstable (which I later reverted).
>>>
>>> The problem is that /usr/lib/locale/locale-archive gets corrupted when
>>> I reboot.  The exact corruption differs with each reboot (i.e. the
>>> md5sum differs).  Last time, the first ~70K was overwritten with data
>>> from xorg.log and my web browsing history.  I have copies of the
>>> original and corrupted state which I can send, the full file is 1.3
>>> megs, but I can limit it to the first 70K, since that's all that was
>>> corrupted.
>
>> I suspect, although I might be wrong, that this is not a kernel-related
>> problem.
>
> Actually, I suspect it is indeed a kernel-related problem.  The
> problem has been reported before, with a repeatable test case:
>
>        http://bugzilla.kernel.org/show_bug.cgi?id=13292
>
> The problem shows up after you unmount and remount the filesystem.
> Before you the filesystem is unmounted, the locale-archive file has
> the correct md5sum.  After you unmount and remount the filesystem, the
> filesystem is corrupted.  I'm guessing that some data blocks aren't
> getting marked as needing writeback, so the previous contents on disk
> aren't written back.  I was able to show that even though the mounted
> filesystem had the correct information, direct access to the disk
> using debugfs showed the blocks on disk had the contents that would be
> revealed after the filesystem was unmounted and remounted.
>
> The problem only shows up when using ext4 without a journal, and I was
> never able to create a simpler reproduction case.  The last time I
> tried to work on this bug was approximately a month ago.  About two
> weeks ago Frank from Google tried reproducing it, but he wasn't able
> to do so using his 2.6.26-based kernel plus an updated ext4.
> Unfortunately, I haven't had time to look at it since then, or to
> check to see if some of the more recent patches scheduled for the
> 2.6.31 merge window might have changed the behaviour of this bug.

Just FYI: Frank Mayhar has recreated this issue in a recent kernel
(though we're not seeing it with our 2.6.26 kernel + ext4 patches),
and is actively working on it.

Curt

>
>                                           - Ted
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
