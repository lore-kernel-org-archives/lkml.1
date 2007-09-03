Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXICJeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXICJeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXICJeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:34:09 -0400
Received: from styx.suse.cz ([82.119.242.94]:46566 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753355AbXICJeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:34:08 -0400
Date: Mon, 3 Sep 2007 11:34:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
In-Reply-To: <20070902132847.5fc968b1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709031130000.16753@jikos.suse.cz>
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>
 <8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>
 <Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>
 <8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>
 <Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
 <20070830180538.b52b802d.akpm@linux-foundation.org> <46D9C935.3000701@gmail.com>
 <20070902132847.5fc968b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Andrew Morton wrote:

> > What about using a weak function in that case ? It actually gives a 
> > default implementation in _one_ place and can be changed easily from a 
> > nop to something more complex later.
> Yeah, weak functions are by far the cleanest way of doing this - they're
> most elegant.  But they do add the overhead of an empty call/return, so
> some thought needs to go into the tradeoff.

Hi,

the problem I am seeing with __weak functions is that as far as I can see, 
gcc 4.1.0 optimizes the empty __weak function away with -O2, so it is not 
later properly overridden by the other non-weak function, as the callsite 
already doesn't have the corresponding call. (when I stick a printk() into 
the __weak function, everything works fine - it is not optimized away and 
non-weak version of the function gets called).

I persume this is a bug in gcc (4.1.1 doesn't seem to expose this 
behavior). I will look at it a little bit more.

Thanks,

-- 
Jiri Kosina
SUSE Labs
