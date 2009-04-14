Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZDNI5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZDNI5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZDNI5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:57:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53510
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbZDNI5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:57:36 -0400
Date: Tue, 14 Apr 2009 01:57:27 -0700 (PDT)
Message-Id: <20090414.015727.173707436.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: linux-next: origin tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090414144317.026498df.sfr@canb.auug.org.au>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 14 Apr 2009 14:43:17 +1000

> Dave, arch/sparc/include/asm/atomic_32.h should really include
> asm/system.h since xchg is used in there.

That's true.

But atomic.h is not the proper place to obtain xchg() from, which is
asm/system.h, and that's what debug_locks.h needs to include if it
needs to use xchg().

This is why the s390 build broke in precisely the same way.
