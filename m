Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935891Ab0BZM0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:26:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32976
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0BZM0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:26:17 -0500
Date: Fri, 26 Feb 2010 04:26:35 -0800 (PST)
Message-Id: <20100226.042635.15450499.davem@davemloft.net>
To: anton@samba.org
Cc: arun@linux.vnet.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ migration of TCP ack timers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100218052820.GD24270@kryten>
References: <20100218052820.GD24270@kryten>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>
Date: Thu, 18 Feb 2010 16:28:20 +1100

> I think the problem is the CPU is most likely to be idle when an rx networking
> interrupt comes in. It seems the wrong thing to do to migrate any ack timers
> off the current cpu taking the interrupt, and with enough networks we train
> wreck transferring everyones ack timers to the nohz load balancer cpu. 

This migration against the very design of all of the TCP timers in the
tree currently.

For TCP, even when the timer is no longer needed, we don't cancel the
timer.  We do this in order to avoid touching the timer for the cancel
from a cpu other than the one the timer was scheduled on.

The timer therefore is always accessed, cache hot, locally to the cpu
where it was scheduled.
