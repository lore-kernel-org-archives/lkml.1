Return-Path: <linux-kernel-owner+w=401wt.eu-S1750787AbZG1EAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750787AbZG1EAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbZG1EAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:00:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZG1EAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:00:16 -0400
Message-ID: <4A6E764E.80805@redhat.com>
Date: Mon, 27 Jul 2009 17:53:50 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090317)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
References: <4A6D79F6.3050509@redhat.com>	<1248699365.6987.1628.camel@twins> <20090727142536.465799aa@lxorguk.ukuu.org.uk> <4A6E529B.9030104@kernel.org>
In-Reply-To: <4A6E529B.9030104@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Alan Cox wrote:
>>> Somehow this made me think of FUSE/CUSE... should this be named aBUSE?
>>> Oh wait it is :-), what I'm after is I guess is, can we share some of
>>> the FUSE/CUSE code?
>> It reminds me of the existing and perfectly functional network block
>> device (nbd) we already have and which has also been present for years.
> 
> Yeah, I think this is the biggest hurdle against (a)BUSE.  Is it
> sufficiently different from nbd?  nbd-like functionality can be
> implemented something via FUSE and maybe it can be said that things
> are cleaner that way but nbd has been in the kernel for a long time
> now and it's definitely much easier to do swap over it when the whole
> thing is in kernel.

The only real difference from this and the nbd is that the nbd is
explicitly connection oriented, while this is intentionally
connectionless.  That was an interesting property, but turned out to be
not to be the best for what I was trying to do.

I'm actually going to go ahead and use nbd instead.  All I need a block
device that supports partitions with a userspace driver.

So maybe someone will find this useful, for now it is preserved in LKML
archives and the patch should continue to apply for some time.

BTW, implementing something like this via FUSE would be extremely
unpleasant.  I'd need another layer on top, probably via the loop
device, to get to the actual partitions of the block devices.

Zach
