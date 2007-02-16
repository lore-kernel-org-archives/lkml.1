Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXBPRTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXBPRTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXBPRTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:19:37 -0500
Received: from gw.goop.org ([64.81.55.164]:53344 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbXBPRTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:19:36 -0500
Message-ID: <45D5E7A7.3090400@goop.org>
Date: Fri, 16 Feb 2007 09:19:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 07/21] Xen-paravirt: remove ctor for pgd cache
References: <20070216022449.739760547@goop.org>	 <20070216022531.047039320@goop.org> <84144f020702160039y11fb1f4dl7b77d4358cc189ee@mail.gmail.com> <45D57738.9030907@yahoo.com.au>
In-Reply-To: <45D57738.9030907@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Pekka Enberg wrote:
>> On 2/16/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>> Remove the ctor for the pgd cache.  There's no point in having the
>>> cache machinery do this via an indirect call when all pgd are freed in
>>> the one place anyway.
>>
>>
>> The reason we have slab constructors and destructors is to _avoid_
>> reinitializing every time we allocate an object. AFAICT your changing
>> the code now to do _more_ work than before, so is there some other
>> reason why you want to do this than avoiding an indirect call?
>
> Sometimes  it is better for the caches to initialise an object
> immediately, but in this case I think it is better to use the
> slab ctor because it is very unlikely to use many cachelines
> immediately anyway.
>
> It would be nice to put the "why" in the changelogs, rather than
> "what". Not everyone wants to go through the whole patchset to
> decipher why Xen possibly needs something.

Hm, I think I was mislead by looking at kmem_cache_alloc in slob.c
rather than the one that's actually used in slab.c.  There's no
particular Xen reason for this patch, so I can drop it.

    J

