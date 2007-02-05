Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXBEAwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXBEAwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 19:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXBEAwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 19:52:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53488
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbXBEAwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 19:52:35 -0500
Date: Sun, 04 Feb 2007 16:52:35 -0800 (PST)
Message-Id: <20070204.165235.26305735.davem@davemloft.net>
To: dkabs@mobotix.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with unix sockets: SOCK_DGRAM ignores MSG_TRUNC
From: David Miller <davem@davemloft.net>
In-Reply-To: <200701291259.50155.dkabs@mobotix.com>
References: <200701291259.50155.dkabs@mobotix.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kabs <dkabs@mobotix.com>
Date: Mon, 29 Jan 2007 12:59:49 +0100

> I use unix domain datagram sockets for IPC, e.g. I receive messages by 
> calling recv().
> 
> "man 2 recv" tells me about the flags argument to a recv() call, namely:
> 
>  MSG_TRUNC
>       Return  the  real  length of the packet, even when it was longer
>       than the passed buffer. Only valid for packet sockets.
> 
> Thus I used recv() with flags MSG_TRUNC|MSG_PEEK in order to detect 
> message truncation due to insufficient buffer size.

What part of "Only valid for packet sockets" from the manual page
escapes you?  :-))

It's a feature which only was meant to be valid for AF_PACKET sockets.

What UDP is doing is different, it's returning the full packet length
when the packet is larger then the given buffer size, but it does this
irregardless of whether you set MSG_TRUNC in the recvmsg() passed-in
flags.  UDP itself sets the MSG_TRUNC flag when it detects this
situation.

I checked the history and our AF_UNIX sockets have always behaved like
this.
