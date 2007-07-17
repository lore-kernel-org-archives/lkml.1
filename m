Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXGQJEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXGQJEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbXGQJD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:03:59 -0400
Received: from mx10.go2.pl ([193.17.41.74]:54194 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756295AbXGQJD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:03:58 -0400
Date: Tue, 17 Jul 2007 11:12:53 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717091253.GA2049@ff.dom.local>
References: <20070716091236.GA10718@elte.hu> <20070717061458.GB1640@ff.dom.local> <200707170955.38536.olaf.kirch@oracle.com> <200707171028.36451.olaf.kirch@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707171028.36451.olaf.kirch@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:28:34AM +0200, Olaf Kirch wrote:
> On Tuesday 17 July 2007 09:55, Olaf Kirch wrote:
> > What I find more problematic about this portion of code though
> > is that once a net_device is over quota, net_rx_action will
> > loop for up to one jiffy, even if there's just this one device on
> > the poll_list.
> 
> Duh, wrong. For every loop, it'll add dev->weight to dev->quota,
> so it'll be fine very soon.

After your patch only two things can be different here: dev->poll_list
and this flag. Since Ingo offered testing it should be easy to check
after moving the check of "your" flag to __netif_rx_complete, and
skipping only list_del on true.

Jarek P.
