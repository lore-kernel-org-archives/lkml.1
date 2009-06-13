Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZFMOU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZFMOU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZFMOUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:20:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:35914 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZFMOUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PFFDu/jjU0M3SIklhT3jjnXBTjjNIKXCPz2/09TKXKJkv346wfDP8LkEW6tOcrVoiQ
         mq36zYO5Ju3QX6AV2y2XQ2MPivumVqTzN3WnoKnjTNRKWK36J75R+1RsBLsgPu8QtcLr
         9kWIdgB5vgMWRi3wOledXFWn5HOU9j6teN7BY=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906131456090.5069@sister.anvils>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> 
	<Pine.LNX.4.64.0906131456090.5069@sister.anvils>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 10:20:02 -0400
Message-ID: <8bd0f97a0906130720o6aac732ax2b1c65ae6915b2d2@mail.gmail.com>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 10:15, Hugh Dickins wrote:
> On Sat, 13 Jun 2009, Mike Frysinger wrote:
>> On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
>> fail when tmpfs options are used.  This is because tmpfs creates a small
>> wrapper around ramfs which rejects unknown options, and ramfs itself only
>> supports a tiny subset of what tmpfs supports.  This makes it pretty hard
>> to use the same userspace systems across different configuration systems.
>> As such, ramfs should ignore the tmpfs options when tmpfs is merely a
>> wrapper around ramfs.
>
> Yes, indeed, thanks a lot for reporting this.
>
> But I'm uneasy with making ramfs behaviour differ with CONFIG_SHMEM
> (perhaps that's silly: certainly tmpfs behaviour differs with it),
> and uneasy with coding a list of options we need to remember to keep
> in synch with mm/shmem.c.  It's easier to justify ignoring all options,
> than rejecting some while ignoring others yet not respecting them.

agreed

>> This used to work before commit c3b1b1cbf0 as previously, ramfs would
>> ignore all options.  But now, we get:
>> ramfs: bad mount option: size=10M
>> mount: mounting mdev on /dev failed: Invalid argument
>
> I rather think the correct response to bugzilla #12843 should have
> been to say, either use chmod 1777 yourself, or use CONFIG_SHMEM=y.
> I fear we'll now get a line of requests for support of uid, gid, ...
> in ramfs; whereas ramfs is about blind simplicity, not feature bloat.
> However, that mode= feature is now in, so I guess we ride with it.

i thought the bug report a bit odd in more than just this regard.
glad to see i'm not the only one ;).

>> another option might be to restore the previous behavior where ramfs simply
>> ignored all unknown mount options ...
>
> Yes, that would be my preference, return to the blind simplicity, with
> that one exception for mode=.  Alternative patch suggested at the bottom,
> let's see if Cc's added feel strongly about it one way or another.

i'm OK with either approach, thanks !
-mike
