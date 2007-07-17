Return-Path: <linux-kernel-owner+w=401wt.eu-S936487AbXGQVlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936487AbXGQVlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXGQVk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:40:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44164
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbXGQVk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:40:57 -0400
Date: Tue, 17 Jul 2007 14:40:42 -0700 (PDT)
Message-Id: <20070717.144042.41636155.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       avi@qumranet.com
Subject: Re: [PATCH] smp_call_function_single() should be a macro on UP
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070717212946.GP21668@ftp.linux.org.uk>
References: <20070717212946.GP21668@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 22:29:46 +0100

> ... or we end up with header include order problems from hell.
> E.g. on m68k this is 100% fatal - local_irq_enable() there
> wants preempt_count(), which wants task_struct fields, which
> we won't have when we are in smp.h pulled from sched.h.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>

I was going to fix the sparc64/UP build fallout by
adding linux/kernel.h include to linux/smp.h but that
definitely would not handle this m68k case at all.

