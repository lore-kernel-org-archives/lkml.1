Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZG1W5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZG1W5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZG1W5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:57:16 -0400
Received: from thunk.org ([69.25.196.29]:32951 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbZG1W5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:57:16 -0400
Date: Tue, 28 Jul 2009 18:56:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <kyle@moffetthome.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Zachary Amsden <zamsden@redhat.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
Message-ID: <20090728225635.GK31679@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Kyle Moffett <kyle@moffetthome.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Zachary Amsden <zamsden@redhat.com>, Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
	Paul.Clements@steeleye.com, miklos <miklos@szeredi.hu>
References: <4A6D79F6.3050509@redhat.com> <1248699365.6987.1628.camel@twins> <20090727142536.465799aa@lxorguk.ukuu.org.uk> <4A6E529B.9030104@kernel.org> <4A6E764E.80805@redhat.com> <20090728112734.5a75752d@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280851360.3186@localhost.localdomain> <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com> <87d47kh9kh.fsf@basil.nowhere.org> <alpine.LFD.2.01.0907281333490.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907281333490.3186@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 01:50:56PM -0700, Linus Torvalds wrote:
> 
> Filesystems long ago _used_ to index things by device number and block - 
> and that meant that re-reading partition tables was _really_ dangerous, 
> because the "device number" would just magically mean something else for a 
> mounted filesystem. But we've indexed things by bdev for a longish time 
> now, and most (all?) filesystems use "sb_bread()" instead of bread etc.

Filesystems don't, but some userspace programs do depend on the dev_t
returned by stat to uniquely identify a mounted filesystem.  (And it's
guaranteed by POSIX).  So what this means is that if we're going to
allow re-reading the partition table, we should (a) avoid changing the
dev_t used by any mounted filesystem, and (b) we should either assign
a new dev_t for any new partitions, or we should disallow mounting a
filesystem with a new dev_t already in use by an already mounted
filesystem with the same dev_t before the partition table was
reorganized.

						- Ted
