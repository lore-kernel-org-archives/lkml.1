Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbYJZEEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbYJZEEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 00:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbYJZEEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 00:04:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47104
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbYJZEEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 00:04:35 -0400
Date: Sat, 25 Oct 2008 21:04:12 -0700 (PDT)
Message-Id: <20081025.210412.206011121.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: galak@kernel.crashing.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, torvalds@osdl.org, maxk@qualcomm.com,
       tglx@linutronix.de
Subject: Re: [PATCH] genirq: Set initial default irq affinity to just CPU0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224970389.7654.473.camel@pasglop>
References: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org>
	<20081024.161813.193686281.davem@davemloft.net>
	<1224970389.7654.473.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sun, 26 Oct 2008 08:33:09 +1100

> Well, I don't know how you do it but on powerpc, we explicitely fill the
> affinity masks at boot time when we can spread interrupts... Maybe we
> should change it the other way around and limit the mask when we can't ?
> It's hard to tell for sure at this stage.

On sparc64 we look at the cpu mask configured for the interrupt and do
one of two things:

1) If all bits are set, we round robin assign a cpu at IRQ enable time.

2) Else we pick the first bit set in the mask.

One modification I want to make is to make case #1 NUMA aware.

But back to my original wonder, since I've always tipped off of this
generic IRQ layer cpu mask, when was it ever defaulting to zero
and causing the behvaior your powerpc guys actually want? :-)

