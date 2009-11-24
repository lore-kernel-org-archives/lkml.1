Return-Path: <linux-kernel-owner+w=401wt.eu-S933750AbZKXR4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbZKXR4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933693AbZKXR4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:56:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54038
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933553AbZKXR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:56:45 -0500
Date: Tue, 24 Nov 2009 09:57:03 -0800 (PST)
Message-Id: <20091124.095703.107687163.davem@davemloft.net>
To: tglx@linutronix.de
Cc: peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.jf.intel.com, mingo@elte.hu, yong.zhang0@gmail.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH v2] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0911241151360.24119@localhost.localdomain>
References: <20091124093518.3909.16435.stgit@ppwaskie-hc2.jf.intel.com>
	<alpine.LFD.2.00.0911241151360.24119@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 24 Nov 2009 12:07:35 +0100 (CET)

> And what does the kernel do with this information and why are we not
> using the existing device/numa_node information ?

It's a different problem space Thomas.

If the device lives on NUMA node X, we still end up wanting to
allocate memory resources (RX ring buffers) on other NUMA nodes on a
per-queue basis.

Otherwise a network card's forwarding performance is limited by the
memory bandwidth of a single NUMA node, and on a multiqueue cards we
therefore fare much better by allocating each device RX queue's memory
resources on a different NUMA node.

It is this NUMA usage that PJ is trying to export somehow to userspace
so that irqbalanced and friends can choose the IRQ cpu masks more
intelligently.
