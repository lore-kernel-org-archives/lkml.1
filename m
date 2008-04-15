Return-Path: <linux-kernel-owner+w=401wt.eu-S1765503AbYDOTvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765503AbYDOTvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbYDOTvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:51:36 -0400
Received: from saeurebad.de ([85.214.36.134]:38628 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbYDOTvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:51:36 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	<20080412225850.704752615@symbol.fehenstaub.lan>
	<87lk3hwv52.fsf@basil.nowhere.org>
	<20080414232308.ffa4e269.akpm@linux-foundation.org>
	<48045D6C.1010508@firstfloor.org> <87skxnibb1.fsf@saeurebad.de>
	<86802c440804151144l7497dae3nb3b07374fd71a282@mail.gmail.com>
Date: Tue, 15 Apr 2008 21:51:17 +0200
In-Reply-To: <86802c440804151144l7497dae3nb3b07374fd71a282@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 15 Apr 2008 11:44:30 -0700")
Message-ID: <87r6d6hp6y.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Tue, Apr 15, 2008 at 4:53 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>>
>> Andi Kleen <andi@firstfloor.org> writes:
>>
>>  > Andrew Morton wrote:
>>  >> On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>>  >>
>>  >>> Johannes Weiner <hannes@saeurebad.de> writes:
>>  >>>
>>  >>>> Make free_bootmem() look up the node holding the specified address
>>  >>>> range which lets it work transparently on single-node and multi-node
>>  >>>> configurations.
>>  >>> Acked-by: Andi Kleen <andi@firstfloor.org>
>>  >>>
>>  >>> This is far better than the original change it replaces and which
>>  >>> I also objected to in review.
>>  >>>
>>  >>
>>  >> So...  do we think these two patches are sufficiently safe and important for
>>  >> 2.6.25?
>>  >
>>  > It's only strictly needed for .26 I think for some (also slightly
>>  > dubious) changes queued in git-x86.
>>
>>  Does anything yet rely on this new free_bootmem() behaviour?  If not,
>>  the safest thing would be to just revert the original patch in mainline
>>  and drop the second patch completely.
>
> 1. free_bootmem(ramdisk_image, ramdisk_size) in setup_arch of x86_64
> need that
> 2. another patch in x86.git need that.

Ok, to avoid confusion: we are talking about free_bootmem() iterating
over nodes and looking up an area WITHIN a node or free_bootmem()
freeing an area ACROSS nodes?

The first is what my patch does _only_.

	Hannes
