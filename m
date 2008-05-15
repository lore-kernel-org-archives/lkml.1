Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbYEOQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbYEOQJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYEOQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:09:39 -0400
Received: from stinky.trash.net ([213.144.137.162]:46285 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbYEOQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:09:38 -0400
Message-ID: <482C6040.9030808@trash.net>
Date: Thu, 15 May 2008 18:09:36 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Kingsley Foreman <kingsley@internode.com.au>
CC: Jarek Poplawski <jarkao2@gmail.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk>
In-Reply-To: <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kingsley Foreman wrote:
> i just rolled back the kernel to 2.6.24 and im seeing the same thing,
> 
> I was using 2.6.22 before and didn't see the problem, txqueuelen on the 
> bond0 interface is 0 (the default)

That might explain things, although it shouldn't have worked before
either.

CBQ creates default pfifo qdiscs for its leaves, these use a limit
of txqueuelen or 1 if it is zero. So even small bursts will cause
drops. Do things improve if you set txqueuelen to a larger value
*before* configuring the qdiscs?

Another thing is that CBQ on bond will probably not work properly
at all, it needs a real device since it measures the timing between
dequeue events for idle time estimation. On software devices this
doesn't work.
