Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXFDPGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXFDPGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbXFDPGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:06:23 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:35206 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755278AbXFDPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:06:21 -0400
Date: Mon, 4 Jun 2007 11:06:20 -0400
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Don Fry <pcnet32@verizon.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Strange soft lockup detected message (looks like spin_lock bug in pcnet32)
Message-ID: <20070604150620.GC10008@csclub.uwaterloo.ca>
References: <20070504151934.GA8754@csclub.uwaterloo.ca> <20070504153438.GE24769@slug> <20070504154009.GE8751@csclub.uwaterloo.ca> <20070504174456.GC8753@csclub.uwaterloo.ca> <20070504175017.GD8753@csclub.uwaterloo.ca> <20070504182433.GA11595@verizon.net> <20070504190236.GE8753@csclub.uwaterloo.ca> <20070507140807.GF8753@csclub.uwaterloo.ca> <20070507144837.GA30865@slug> <20070507174511.GL8751@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507174511.GL8751@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 01:45:11PM -0400, Lennart Sorensen wrote:
> Hmm, I thought I saw it on two systems already, but I should go try that
> again.

Hmm, still haven't figured this out.  I just saw this one this morning:

BUG: soft lockup detected on CPU#0!
 [<c0103fc4>] dump_stack+0x24/0x30
 [<c013d36e>] softlockup_tick+0x7e/0xc0
 [<c011eb23>] update_process_times+0x33/0x80
 [<c01062c9>] timer_interrupt+0x39/0x80
 [<c013d6fd>] handle_IRQ_event+0x3d/0x70
 [<c013da59>] __do_IRQ+0xa9/0x150
 [<c0104e55>] do_IRQ+0x25/0x60
 [<c010313a>] common_interrupt+0x1a/0x20
 [<c013d6d8>] handle_IRQ_event+0x18/0x70
 [<c013da59>] __do_IRQ+0xa9/0x150
 [<c0104e55>] do_IRQ+0x25/0x60
 [<c010313a>] common_interrupt+0x1a/0x20
 [<c0119cda>] __do_softirq+0x3a/0xa0
 [<c0119d6d>] do_softirq+0x2d/0x30
 [<c0119fb7>] irq_exit+0x37/0x40
 [<c0104e5a>] do_IRQ+0x2a/0x60
 [<c010313a>] common_interrupt+0x1a/0x20
 [<c013dcee>] setup_irq+0xce/0x1e0
 [<c013de97>] request_irq+0x97/0xb0
 [<d0851f9d>] pcnet32_open+0x4d/0x3d0 [pcnet32]
 [<c023a4f9>] dev_open+0x39/0x80
 [<c0238cea>] dev_change_flags+0xfa/0x130
 [<c027eb9f>] devinet_ioctl+0x4ff/0x6f0
 [<c022dab1>] sock_ioctl+0xf1/0x1f0
 [<c017413c>] do_ioctl+0x2c/0x80
 [<c01741e2>] vfs_ioctl+0x52/0x2f0
 [<c01744ef>] sys_ioctl+0x6f/0x80
 [<c0102ef7>] syscall_call+0x7/0xb
 [<b7f41d04>] 0xb7f41d04

And it is happening on multiple systems.  I am starting to wonder if it
is a bug in the soft lockup detection.  Maybe it really isn't locked up
but just momentarily appears to be.  I will try turning off the soft
lockup detection and see what happens.

--
Len Sorensen
