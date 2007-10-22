Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXJVTf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXJVTf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXJVTfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:35:20 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:35799 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXJVTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:35:18 -0400
Message-ID: <471CFA9C.7010300@cosmosbay.com>
Date: Mon, 22 Oct 2007 21:31:40 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/ipv4]: fib_seq_show function adjustment to get a
 more sensable output of /proc/net/route
References: <1193077582-4790-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1193077582-4790-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 22 Oct 2007 21:31:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Cheng a écrit :
> the temporary bf[127] char array is redundant, and the specified width 127 make the output of /proc/net/route include many trailing spaces;
> since most terminal's cols are less than 127, this made every fib entry occupy two lines,
> 
> after applied this patch, the output of /proc/net/route is more sensable like this:
> 
> Iface	Destination	Gateway 	Flags	RefCnt	Use	Metric	Mask		MTU	Window	IRTT
> eth0	0001A8C0	00000000	0001	0	0	0	00FFFFFF	0	0	0
> lo	0000007F	00000000	0001	0	0	0	000000FF	0	0	0
> eth0	00000000	0101A8C0	0003	0	0	0	00000000	0	0	0
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Hum... did you test your patch with many routes declared ? (more than 32 on 
i386/x86_64)

127 is not a random value, but chosen as a power of two minus 1.
PAGE_SIZE is garanted to be a multiple of 128 (127 chars + line_feed) on all 
arches.

So each read() on /proc/net/route delivers PAGE_SIZE/128 lines.

With your patch, some lines might be truncated (one every 32 on i386)


