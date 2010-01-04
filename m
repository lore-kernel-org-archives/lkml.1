Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591Ab0ADQlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0ADQlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557Ab0ADQlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:41:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543Ab0ADQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:41:49 -0500
Date: Mon, 4 Jan 2010 08:40:49 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: mbreuer@majjas.com, akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: make sure ethernet header is in transmit skb
Message-ID: <20100104084049.4d9cd0e4@nehalam>
In-Reply-To: <20100103.213258.263977883.davem@davemloft.net>
References: <20091226140544.5600b3d1@nehalam>
	<20091226.194418.229766965.davem@davemloft.net>
	<20091226.201107.35060733.davem@davemloft.net>
	<20100103.213258.263977883.davem@davemloft.net>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Jan 2010 21:32:58 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Sat, 26 Dec 2009 20:11:07 -0800 (PST)
> 
> > From: David Miller <davem@davemloft.net>
> > Date: Sat, 26 Dec 2009 19:44:18 -0800 (PST)
> > 
> >> From: Stephen Hemminger <shemminger@linux-foundation.org>
> >> Date: Sat, 26 Dec 2009 14:05:44 -0800
> >> 
> >>> Other drivers may have same problem, I really think this ought
> >>> to be done at higher level.
> >> 
> >> I tend to agree with you, and I thought we had handled all
> >> cases.  Let's simply make AF_PACKET linearize the link
> >> level header before sending things out to the transmit path.
> >> 
> >> I can work on this if you want.
> > 
> > Actually Stephen, I took a look and I can't see how AF_PACKET
> > can create this situation.
> > 
> > It always copies into the linear area of the SKB it allocates
> > for sendmsg() processing.  Whether the data comes from sendmsg
> > data or the mmap() ring buffer.
> 
> Stephen can you get a backtrace of the code path which triggers
> this?  I want to fix it at a higher level too, but I can't
> do that until I know where it actually happens.

Ignore it, the problem is outside the sky2 driver in some other
place causing corrupt skb's. I never reproduced this (with added BUG_ON
and WARN_ON), only seen by Michael.
