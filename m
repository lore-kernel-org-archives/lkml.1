Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbXCKDnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbXCKDnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbXCKDnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:43:32 -0500
Received: from holomorphy.com ([66.93.40.71]:57755 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853AbXCKDnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:43:31 -0500
Date: Sat, 10 Mar 2007 19:43:27 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Con Kolivas <kernel@kolivas.org>, mpm@selenic.com,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: RSDL-mm 0.28
Message-ID: <20070311034327.GK2986@holomorphy.com>
References: <20070311013506.GD10459@waste.org> <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com> <20070310191614.5ac3cf4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310191614.5ac3cf4b.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007 13:28:22 +1100 "Con Kolivas" <kernel@kolivas.org> wrote:
>> Well... are you advocating we change sched_yield semantics to a
>> gentler form?

On Sat, Mar 10, 2007 at 07:16:14PM -0800, Andrew Morton wrote:
> From a practical POV: our present yield() behaviour is so truly awful that
> it's basically always a bug to use it.  This probably isn't a good thing.
> So yes, I do think that we should have a rethink and try to come up with
> behaviour which is more in accord with what application developers expect
> yield() to do.

ISTR that apps varied wrt. their expectations for yield(). Some,
particularly those using it to implement multi-tiered userspace locks,
really did expect to go all the way to the back of the queue. (Rumor has
it that realtime apps break otherwise.) Others wanted a kinder, gentler,
"mistress, please hit me, but not too hard" opportunity to let someone
else have a little cpu time, particularly when userspace is spinning in
some sort of busywait. In both scenarios something very much against
the latest trends of Linux kernel politics is done by userspace.


On Sat, Mar 10, 2007 at 07:16:14PM -0800, Andrew Morton wrote:
> otoh,
> a) we should have done this five years ago.  Instead, we've spent that
>    time training userspace programmers to not use yield(), so perhaps
>    there's little to be gained in changing it now.
> b) if we _were_ to change yield(), people would use it more, and their
>    applications would of course suck bigtime when run on earlier 2.6
>    kernels.
> Bottom line: we've had a _lot_ of problems with the new yield() semantics. 
> We effectively broke back-compatibility by changing its behaviour a lot,
> and we can't really turn around and blame application developers for that.

My dumb idea would be to break out new syscall. One for the kinder,
gentler version, one for the serious version. Or otherwise pass an
argument indicating the expected behavior. Then a dumb app can be
LD_PRELOAD'd into calling whatever makes it run fastest.


-- wli
