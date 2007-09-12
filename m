Return-Path: <linux-kernel-owner+w=401wt.eu-S934207AbXILLvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbXILLvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbXILLv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:51:29 -0400
Received: from main.gmane.org ([80.91.229.2]:49691 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbXILLv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:51:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: irq load balancing
Date: Wed, 12 Sep 2007 13:51:56 +0200
Organization: Linux Foundation
Message-ID: <20070912135156.09e47d50@oldman>
References: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 213.144.15.9
In-Reply-To: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 16:18:15 -0700
"Venkat Subbiah" <venkats@cranite.com> wrote:

> Most of the load in my system is triggered by a single ethernet IRQ. Essentially the IRQ schedules a tasklet and most of the work is done in the taskelet which is scheduled in the IRQ. From what I read looks like the tasklet would be executed on the same CPU on which it was scheduled. So this means even in an SMP system it will be one processor which is overloaded.

The network device should use NAPI and process many packets per IRQ.
What device driver is it?

> So will using the user space IRQ loadbalancer really help? What I am doubtful about is that the user space load balance comes along and changes the affinity once in a while. But really what I need is every interrupt to go to a different CPU in a round robin fashion.

Userspace IRQ balancer detects network devices and intentionally does
not balance them. See: http://irqbalance.org/documentation.php

> Looks like the APIC  can distribute IRQ's dynamically? Is this supported in the kernel and any config or proc interface to turn this on/off.

Network device IRQ distribution usually is bad, because it causes cache
thrashing.
> 
> Thx,
> Venkat
> 

