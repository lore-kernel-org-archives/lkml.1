Return-Path: <linux-kernel-owner+w=401wt.eu-S1423326AbXBHUna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423326AbXBHUna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423333AbXBHUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:43:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32883
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423326AbXBHUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:43:29 -0500
Date: Thu, 08 Feb 2007 12:43:28 -0800 (PST)
Message-Id: <20070208.124328.88477956.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: akpm@osdl.org, mingo@elte.hu, ak@suse.de, jan.glauber@de.ibm.com,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070208203210.GB9798@osiris.ibm.com>
References: <20070208203210.GB9798@osiris.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 8 Feb 2007 21:32:10 +0100

> So either all spin_lock_bh's should be converted to spin_lock,
> which would limit smp_call_function()/smp_call_function_single()
> to process context & irqs enabled.
> Or the spin_lock's could be converted to spin_lock_bh which would
> make it possible to call these two functions even if in softirq
> context. AFAICS this should be safe.

Sparc64 does not allow smp_call_function() from software interrupts
either.

Same for powerpc, mips, alpha.

IA-64 has the inconsistency you've spotted between smp_call_function()
and smp_call_function_single().

In short, it's a mess :-)

I think it's logically simpler if we disallow smp_call_function*()
from any kind of asynchronous context.  But I'm sure your driver
has a true need for this for some reason.
