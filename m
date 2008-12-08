Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYLHBnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYLHBnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 20:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYLHBmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 20:42:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:36164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYLHBmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 20:42:50 -0500
Message-ID: <493C7B70.4090307@kernel.org>
Date: Mon, 08 Dec 2008 10:42:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] Recursive printk
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net> <20081205232016.366765e2.akpm@linux-foundation.org> <20081206083030.GF5957@mail.local.tull.net>
In-Reply-To: <20081206083030.GF5957@mail.local.tull.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Dec 2008 01:42:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Nick Andrew wrote:
>> Tejun had a thing a while ago which was kinda intended to solve the
>> same problem.  iirc his approach added a lot more code (bad), but
>> didn't go and add strange new semantics to printk.
> 
> I'm not trying to solve a huge problem (e.g. as Jason Baron's dynamic
> debug does), just a small problem. Why do tasks have to choose
> between double-buffering their messages and making multiple calls
> to printk?

Yeah, my patch happened to solve about the same problem (and mprintk
proper was ~370 lines, so it wasn't too bad).  Mine went the way of
assembling messages piece-by-piece and most of the complexities came
from buffer management and fallback (e.g. even if kmalloc fails to
allocate messages, messages still get printed out, albeit a bit
uglier).

>> IOW, for this to be halfway as useful as you expect, we need a
>> look-out-for-local-printk-hacks maintainer.
> 
> If my patch makes it in, it will be followed by fixes to all
> those local hacks. We might discover some common element so they
> can be made non-local. Once a better way to interface to printk
> becomes prevalent, it will probably be reused. And if it's not,
> then it affects only the one subsystem.

No matter which mechanism, I'd love to have something to solve this in
kernel.  I face this problem quite often and each and every time I
have to come up with some custom hack to work around it.

FWIW, this was the last take of the mprintk patchset.

  http://thread.gmane.org/gmane.linux.ide/28415

Thanks.

-- 
tejun
