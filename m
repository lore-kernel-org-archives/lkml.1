Return-Path: <linux-kernel-owner+w=401wt.eu-S1761780AbZJIXVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761780AbZJIXVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761642AbZJIXV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:21:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50217
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761603AbZJIXVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:21:25 -0400
Date: Fri, 09 Oct 2009 16:21:20 -0700 (PDT)
Message-Id: <20091009.162120.164441279.davem@davemloft.net>
To: heyongli@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux guest domain with two vnets bound to the same vswitch
 experiences hung in bootup (sun_netraT5220)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091009.150829.218507309.davem@davemloft.net>
References: <505766fa0909230040m13e3dc34x2ceb83848767d825@mail.gmail.com>
	<505766fa0909231903t2fe2f7b6y26d2681d6d38ef0e@mail.gmail.com>
	<20091009.150829.218507309.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 09 Oct 2009 15:08:29 -0700 (PDT)

> Thank you for this bug report and patch, I am looking at
> it now.

I'm trying to figure out how the deadlock can even occur,
and I've failed so far, please help me :-)

See, we always take the VIO and LDC locks in the same order
(VIO then LDC) and always with interrupts disabled, so it is
not possible to deadlock.

The only way we could deadlock is if:

1) There is some path that takes the LDC lock before the VIO one.

2) There is some path that takes either lock with interrupts
   enabled.

And I cannot find any such case.

It might help if you run your test case with lockdep enabled.  It will
find such deadlocks and report them precisely to the kernel logs.

Thank you!
