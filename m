Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbXGCVlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbXGCVlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbXGCVkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:40:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42046
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbXGCVkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:40:53 -0400
Date: Tue, 03 Jul 2007 14:41:12 -0700 (PDT)
Message-Id: <20070703.144112.24611353.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: mark@mtfhpc.demon.co.uk, linux-mm@kvack.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       clameter@engr.sgi.com, wli@holomorphy.com
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
 sparc32 (sun4c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1183490778.29081.35.camel@shinybook.infradead.org>
References: <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
	<Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
	<1183490778.29081.35.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 03 Jul 2007 15:26:18 -0400

> On Tue, 2007-07-03 at 19:57 +0100, Mark Fortescue wrote:
> > > Commit b46b8f19c9cd435ecac4d9d12b39d78c137ecd66 partially fixed alignment 
> > > issues but does not ensure that all 64bit alignment requirements of sparc32 
> > > are met. Tests have shown that the redzone2 word can become misallignd.
> 
> Oops, sorry about that. I'm not sure about your patch though -- I think
> I'd prefer to keep the redzone misaligned (and hence _right_ next to the
> real data), and just deal with it.
> 
> typedef unsigned long long __aligned__((BYTES_PER_WORD)) redzone_t;

Please don't use get_unaligned() or whatever to fix this, it's
going to generate the byte-at-a-time accesses on sparc64
which doesn't need it since the redzone will be aligned.
