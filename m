Return-Path: <linux-kernel-owner+w=401wt.eu-S934379AbXGQRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379AbXGQRvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXGQRvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:51:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759515AbXGQRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:51:08 -0400
Date: Tue, 17 Jul 2007 10:49:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Olaf Kirch <olaf.kirch@oracle.com>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
In-Reply-To: <20070717085748.GA32114@elte.hu>
Message-ID: <alpine.LFD.0.999.0707171047200.19166@woody.linux-foundation.org>
References: <20070716091236.GA10718@elte.hu> <20070717061458.GB1640@ff.dom.local>
 <200707170955.38536.olaf.kirch@oracle.com> <200707171028.36451.olaf.kirch@oracle.com>
 <20070717085748.GA32114@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Ingo Molnar wrote:
> 
> i've got a new observation: changing CONFIG_HZ from 250 to 1000 makes 
> the problem go away. So it's somehow also related to jiffies.

No, I suspect it's just related to timing: you need to hit that window 
when the LIST_FROZEN bit is set, and since it was so reliable for you 
before (and others didn't see it), your timing probably happened to hit it 
exactly. And changing HZ probably just changed some timeout or softirq 
getting called, and you didn't hit the bug any more.

		Linus
