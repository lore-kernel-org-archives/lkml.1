Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYLCOvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYLCOvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYLCOu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:50:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47249 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYLCOu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:50:56 -0500
To: "wassim dagash" <wassim.dagash@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KSWAPD Algorithm
From: Andi Kleen <andi@firstfloor.org>
References: <cb94e63d0812022302m341fcdf5wffbca0ec12db426b@mail.gmail.com>
Date: Wed, 03 Dec 2008 15:51:11 +0100
In-Reply-To: <cb94e63d0812022302m341fcdf5wffbca0ec12db426b@mail.gmail.com> (wassim dagash's message of "Wed, 3 Dec 2008 09:02:49 +0200")
Message-ID: <87prk9xqg0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"wassim dagash" <wassim.dagash@gmail.com> writes:

> Hi All,
> Description:
> I countered a weird problem with kswapd:
> it runs in some infinite loop trying to swap until order 10 of zone
> highmem is OK, While zone higmem (as I understand) has nothing to do
> with contiguous physical memory (cause there is no 1-1 mapping) which
> means kswapd will continue to try to balance order 10 of zone highmem
> forever (or until someone release a very large chunk of highmem).
> Can anyone please explain me the algorithm of kswapd and why it tries
> to balance order 10 of zone higmem ?

hugetlbfs requires large continuous mappings even in highmem
to map 2MB pages or similar to user space.
However order 10 seems pretty high, normally that's only order 8
on a i386 system.

-Andi

-- 
ak@linux.intel.com
