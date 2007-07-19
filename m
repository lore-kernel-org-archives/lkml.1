Return-Path: <linux-kernel-owner+w=401wt.eu-S1765488AbXGSKkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765488AbXGSKkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbXGSKkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:40:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23821 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXGSKkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:40:22 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 12:37:54 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <200707191144.24434.olaf.kirch@oracle.com> <20070719100135.GA2986@elte.hu>
In-Reply-To: <20070719100135.GA2986@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191237.56455.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 12:01, Ingo Molnar wrote:
>  Calling initcall 0xc0603f55: netpoll_init+0x0/0x39()
>  initcall 0xc0603f55: netpoll_init+0x0/0x39() returned 0.
>  initcall 0xc0603f55 ran for 0 msecs: netpoll_init+0x0/0x39()
>  Calling initcall 0xc0604257: netlink_proto_init+0x0/0x12a()
>  NET: Registered protocol family 16
> 
> and no output ever since - and the box has been up for a few minutes.

Okay, I need to ask a stupid question - did you verify that it's not
spinning on a spinlock?

Specifically, I'm wondering whether the net_rx_action softirq may
be scheduled while we're in poll_napi holding the poll_lock.
net_rx_action would try to take the poll_lock as well, and we'd
be hung for good. The patch with local_bh_disable/enable was
supposed to test that idea (this is the "trickle" patch)

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
