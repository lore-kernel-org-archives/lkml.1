Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZDNI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZDNI4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZDNI4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:56:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36012
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbZDNI4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:56:00 -0400
Date: Tue, 14 Apr 2009 01:55:51 -0700 (PDT)
Message-Id: <20090414.015551.220726058.davem@davemloft.net>
To: sachinp@in.ibm.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       linux-s390@vger.kernel.org
Subject: Re: Next 14: s390x defconfig build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <49E44C15.4050208@in.ibm.com>
References: <20090414160809.e92d9d3e.sfr@canb.auug.org.au>
	<49E44C15.4050208@in.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Sant <sachinp@in.ibm.com>
Date: Tue, 14 Apr 2009 14:10:53 +0530

> Today's next tree build (defconfig s390x ) failed with following
> error.
> 
> In file included from kernel/panic.c:11:
> include/linux/debug_locks.h: In function __debug_locks_off:
> include/linux/debug_locks.h:15: error: implicit declaration of
> function xchg
> 
> Probably because of commit 9eeba6138cefc0435695463ddadb0d95e0a6bcd2.

I see that Stephen fixed this by adding a asm/system.h include
to asm/atomic.h on sparc.

I don't agree with this, and now we have yet another platform
broken in the same way.

If debug_locks.h needs xchg() I think it should include asm/system.h
which was always the traditional location from which to include that
declaration.

It is even the case on x86.

We get it via asm/atomic.h by accident on x86 and other platforms, not
because that's the canonical location from which to get xchg().
