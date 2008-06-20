Return-Path: <linux-kernel-owner+w=401wt.eu-S933657AbYFTUs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbYFTUs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765642AbYFTUh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:37:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59602
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758919AbYFTUhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:37:22 -0400
Date: Fri, 20 Jun 2008 13:37:21 -0700 (PDT)
Message-Id: <20080620.133721.95818057.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806201624280.3668@engineering.redhat.com>
References: <Pine.LNX.4.64.0806201143110.8789@engineering.redhat.com>
	<20080620.102601.06998427.davem@davemloft.net>
	<Pine.LNX.4.64.0806201624280.3668@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 20 Jun 2008 16:34:23 -0400 (EDT)

> And what if network softirq happened here? How much stack does it consume?
> 
> The whole overflowed stack trace has 75 functions, I was able to get rid 
> of 9 by avoiding bio_endio recursion and 10 by turning simple functions 
> into inlines. --- so is it enough or not enough for possible networking 
> calls?

It should be OK, because the minimum stack of a (75 - 19) depth call
chain is under 11K and within safe limits I believe.

> Maybe a good thing would be to add a check for stack size to __do_softirq 
> and handing the softirq to ksoftirqd if there's not enough space.

I'd rather it spit out a WARN_ON() message and a backtrace.

Otherwise it will be considered a feature and people won't fix
these deep call chains.
