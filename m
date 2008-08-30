Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYH3JMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYH3JMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYH3JM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:12:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:55465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYH3JM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:12:26 -0400
Message-ID: <48B90E81.5060905@kernel.org>
Date: Sat, 30 Aug 2008 11:10:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: Re: linux-next: Tree for August 27
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <48B7C361.9070008@kernel.org> <20080829094249.GQ20055@kernel.dk> <200808292123.07246.bzolnier@gmail.com>
In-Reply-To: <200808292123.07246.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 Aug 2008 09:11:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bartlomiej Zolnierkiewicz wrote:
>>> Hmmm... it broke booting?  Bart, can you please elaborate a bit what got
>>> broken?  Did it fail to locate the root partition or were you using
>>> static device nodes?
>> It works fine for me, fwiw.
> 
> It fails to locate the root partition if you are using the default root
> device on x86 (the one hard-wired into bzImage, it uses hard-coded 8-bit
> major/minor numbers).

Right.  That would break it too.

> Now I see that the issue is easily fixed by passing the root device name
> with "root=" (since it will figure out the actual major/minor numbers
> later) and that the default root device is said to be deprecated according
> to Documentation/x86/boot.txt (OTOH there is no warning at all that it is
> deprecated and that you should be using "root=" so I'm not convinced that
> I'm the only one who would hit the unfortunate combination).

Yeap, in retrospect, enabling BLOCK_EXT_DEVT by default seems too
disruptive.  There also are people running off static /dev.  I hope
distros enable it during their alphas and betas tho so that they can
spot problems in configuration utilities and stuff early.

> Actually it seems that CONFIG_DEBUG_BLOCK_EXT_DEVT introduction (which I
> think is a nice step forward) is a good oportunity to put the deprecation
> of the default root device further, i.e. it may be worth to hook the
> default root device check and/or CONFIG_DEBUG_BLOCK_EXT_DEVT one into
> mount_block_root().

Maybe we can add a warning there if BLOCK_EXT_DEVT is enabled or do
you have something else on mind?

Thanks.

-- 
tejun
