Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbZL0ELL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbZL0ELL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 23:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZL0ELJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 23:11:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34464
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbZL0ELF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 23:11:05 -0500
Date: Sat, 26 Dec 2009 20:11:07 -0800 (PST)
Message-Id: <20091226.201107.35060733.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: mbreuer@majjas.com, akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: make sure ethernet header is in transmit skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091226.194418.229766965.davem@davemloft.net>
References: <4B367409.5060202@majjas.com>
	<20091226140544.5600b3d1@nehalam>
	<20091226.194418.229766965.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 26 Dec 2009 19:44:18 -0800 (PST)

> From: Stephen Hemminger <shemminger@linux-foundation.org>
> Date: Sat, 26 Dec 2009 14:05:44 -0800
> 
>> Other drivers may have same problem, I really think this ought
>> to be done at higher level.
> 
> I tend to agree with you, and I thought we had handled all
> cases.  Let's simply make AF_PACKET linearize the link
> level header before sending things out to the transmit path.
> 
> I can work on this if you want.

Actually Stephen, I took a look and I can't see how AF_PACKET
can create this situation.

It always copies into the linear area of the SKB it allocates
for sendmsg() processing.  Whether the data comes from sendmsg
data or the mmap() ring buffer.

