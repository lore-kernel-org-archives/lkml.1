Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZG1QCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZG1QCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZG1QCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:02:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629AbZG1QCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:02:38 -0400
Date: Tue, 28 Jul 2009 09:00:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Zachary Amsden <zamsden@redhat.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
In-Reply-To: <20090728112734.5a75752d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907280851360.3186@localhost.localdomain>
References: <4A6D79F6.3050509@redhat.com> <1248699365.6987.1628.camel@twins> <20090727142536.465799aa@lxorguk.ukuu.org.uk> <4A6E529B.9030104@kernel.org> <4A6E764E.80805@redhat.com> <20090728112734.5a75752d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Alan Cox wrote:
>
> Use device mapper. Really we should shoot all the partition code in the
> kernel but the back compatibility is a bit tricky. We don't actually need
> the partition code any more.

Really, we should _not_ "shoot all the partition code in the kernel". 
Quite the reverse.

You need the kernel to read the disk anyway, you're _much_ better off 
having the kernel know about the partitioning etc. There are absolutely 
zero upsides to making the bootup be dependent on yet another user land 
tool, and then effectively forcing people to use initrd whether they want 
it or not - just in order to find the real root.

The fact that some distributions already go too far, and use DM whether it 
makes sense or not is only inconveniencing real users. It makes things 
like data portability much harder. I have had real-life cases where I 
wanted to move a disk from one machine to another, only to notice that the 
crazy default for the distro I had used was to make it impossible, because 
all the filesystems crossed disks.

I've since learnt to not use DM (and instead doing a very inconvenient 
"partition everything by hand because the install tool doesn't allow for 
any simple automated way to make a sane install"), and to just put /home 
on one disk and / on the other, and then I can way more easily just move 
my /home disk around, for example.

Yes, I realize that MD is convenient for a certain class of users, but a 
_lot_ of distro people seem to totally miss all the inconveniences. 
Possibly because they care more about "enterprise" customers than about 
people who tinker.

				Linus
