Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYDOT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYDOT5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760844AbYDOT5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:57:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:62915 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526AbYDOT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S8Dl5oq/cVT7EJCM/RfVOUzf93HkjD/kF1vpDgJnRCYxAHMYAIQvsGkzvOHi7JquyiYmakMpWTClGVt4dbld7ZKAbtD0kzAkGK1pSaunPOWvzGtrFkL5O2MpM8m0HU2FwS6FOX71i9HfHp+KFLRRshgQ55sldRFCwdtlOauwpxQ=
Message-ID: <86802c440804151257m735bdac6xb7d0b1b155274e2d@mail.gmail.com>
Date: Tue, 15 Apr 2008 12:57:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <87r6d6hp6y.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	 <20080412225850.704752615@symbol.fehenstaub.lan>
	 <87lk3hwv52.fsf@basil.nowhere.org>
	 <20080414232308.ffa4e269.akpm@linux-foundation.org>
	 <48045D6C.1010508@firstfloor.org> <87skxnibb1.fsf@saeurebad.de>
	 <86802c440804151144l7497dae3nb3b07374fd71a282@mail.gmail.com>
	 <87r6d6hp6y.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:51 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
>
>  "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>  > On Tue, Apr 15, 2008 at 4:53 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>  >>
>  >> Andi Kleen <andi@firstfloor.org> writes:
>  >>
>  >>  > Andrew Morton wrote:
>  >>  >> On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>  >>  >>
>  >>  >>> Johannes Weiner <hannes@saeurebad.de> writes:
>  >>  >>>
>  >>  >>>> Make free_bootmem() look up the node holding the specified address
>  >>  >>>> range which lets it work transparently on single-node and multi-node
>  >>  >>>> configurations.
>  >>  >>> Acked-by: Andi Kleen <andi@firstfloor.org>
>  >>  >>>
>  >>  >>> This is far better than the original change it replaces and which
>  >>  >>> I also objected to in review.
>  >>  >>>
>  >>  >>
>  >>  >> So...  do we think these two patches are sufficiently safe and important for
>  >>  >> 2.6.25?
>  >>  >
>  >>  > It's only strictly needed for .26 I think for some (also slightly
>  >>  > dubious) changes queued in git-x86.
>  >>
>  >>  Does anything yet rely on this new free_bootmem() behaviour?  If not,
>  >>  the safest thing would be to just revert the original patch in mainline
>  >>  and drop the second patch completely.
>  >
>  > 1. free_bootmem(ramdisk_image, ramdisk_size) in setup_arch of x86_64
>  > need that
>  > 2. another patch in x86.git need that.
>
>  Ok, to avoid confusion: we are talking about free_bootmem() iterating
>  over nodes and looking up an area WITHIN a node or free_bootmem()
>  freeing an area ACROSS nodes?
>
>  The first is what my patch does _only_.

Yes, your patch for free_bootmem only can free blocks in the same node.

but the free_bootmem(ramdisk_image,...) in setup_arch could cross
node... , and some other via reserve_early...

for example two nodes, every node have 2G, and in case use
memmap=NN$SS to execlude some memory on node1. the ramdisk could sit
cross the boundary.

YH
