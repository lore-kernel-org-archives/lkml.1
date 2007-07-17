Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbXGQIac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbXGQIac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXGQIaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:30:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34263 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbXGQIaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:30:22 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Tue, 17 Jul 2007 10:28:34 +0200
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <20070717061458.GB1640@ff.dom.local> <200707170955.38536.olaf.kirch@oracle.com>
In-Reply-To: <200707170955.38536.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171028.36451.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 09:55, Olaf Kirch wrote:
> What I find more problematic about this portion of code though
> is that once a net_device is over quota, net_rx_action will
> loop for up to one jiffy, even if there's just this one device on
> the poll_list.

Duh, wrong. For every loop, it'll add dev->weight to dev->quota,
so it'll be fine very soon.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
