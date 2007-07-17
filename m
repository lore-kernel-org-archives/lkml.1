Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXGQH5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXGQH5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXGQH5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:57:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21446 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762249AbXGQH5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:57:44 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Tue, 17 Jul 2007 09:55:37 +0200
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <20070717054639.GA1640@ff.dom.local> <20070717061458.GB1640@ff.dom.local>
In-Reply-To: <20070717061458.GB1640@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707170955.38536.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 08:14, Jarek Poplawski wrote:
> > If after poll_napi dev->quota <= 0 dev->poll is not run and
> > __LINK_STATE_RX_SCHED bit (plus dev->poll_list) stays uncleared.
> 
> Or, more precisely dev->poll_list will be cleared just after this,
> and net_rx_action returns with __LINK_STATE_RX_SCHED bit set.

I don't think so. dev will remain on poll_list.

What I find more problematic about this portion of code though
is that once a net_device is over quota, net_rx_action will
loop for up to one jiffy, even if there's just this one device on
the poll_list.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
