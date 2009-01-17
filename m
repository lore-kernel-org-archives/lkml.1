Return-Path: <linux-kernel-owner+w=401wt.eu-S1765007AbZAQUEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765007AbZAQUEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZAQUDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:03:51 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:64090 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZAQUDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HoRQ3hWVnZZAzIYdd8OIi61Sj8x5xjOZEgQkSQc2/Vh2NRCBEkfe+HHeCMOzGepHnM
         lF55/x/waZqC1aV4VEUaHuug8M3SxxKAWptIql6mPMD591FPfKAr2mqGE7gfwBDp7l1I
         NWy2djrOgCClJ0UwNmNVKTFSNZ04q1csGBtOY=
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
From: Ben Gamari <bgamari@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <andrea@suse.de>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
In-Reply-To: <20090117162657.GA31965@Krystal>
References: <20090117004439.GA11492@Krystal>
	 <20090117162657.GA31965@Krystal>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 15:03:46 -0500
Message-Id: <1232222626.3666.14.camel@mercury.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 11:26 -0500, Mathieu Desnoyers wrote:
> This patch implements a basic test to make sure we never merge more than 128
> requests into the same request if it is the "last_merge" request. I have not
> been able to trigger the problem again with the fix applied. It might not be in
> a perfect state : there may be better solutions to the problem, but I think it
> helps pointing out where the culprit lays.

Unfortunately, it seems like the patch hasn't really fixed much. After
porting it forward to Linus' master, I haven't exhibited any difference
in real world use cases (e.g. desktop use cases while building a
kernel).

Given Jen's remarks, I suppose this isn't too surprising. Does anyone
else with greater familiarity with the block I/O subsystem have any more
ideas about the source of the slowdown? It seems like the recent patches
incorporating blktrace support into ftrace could be helpful for further
data collection, correct?

- Ben



