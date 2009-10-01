Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZJAWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZJAWW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZJAWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:22:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbZJAWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:22:25 -0400
Date: Thu, 1 Oct 2009 15:21:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: eric.dumazet@gmail.com, jgunthorpe@obsidianresearch.com, vl@samba.org,
       opurdila@ixiacom.com, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SPLICE_F_NONBLOCK semantics...
In-Reply-To: <20091001.151102.09812927.davem@davemloft.net>
Message-ID: <alpine.LFD.2.01.0910011516390.6996@localhost.localdomain>
References: <20091001.151102.09812927.davem@davemloft.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, David Miller wrote:
> 
> It depends upon our interpretation of how you intended the
> SPLICE_F_NONBLOCK flag to work when you added it way back
> when.
> 
> Linus introduced  SPLICE_F_NONBLOCK in commit 29e350944fdc2dfca102500790d8ad6d6ff4f69d
> (splice: add SPLICE_F_NONBLOCK flag )
> 
>   It doesn't make the splice itself necessarily nonblocking (because the
>   actual file descriptors that are spliced from/to may block unless they
>   have the O_NONBLOCK flag set), but it makes the splice pipe operations
>   nonblocking.
> 
> Linus intention was clear : let SPLICE_F_NONBLOCK control the splice pipe mode only

Ack. The original intent was for the flag to affect the buffering, not the 
end points.

> splice(socket,0,pipe,0,128*1024,SPLICE_F_MOVE | SPLICE_F_NONBLOCK ); 
> 
> to block on data coming from socket (if file is in blocking mode),
> and not block on pipe output (to avoid deadlock)

Yes. Sounds correct. Although the more I think about it, the more I 
suspect that the whole NONBLOCK thing should probably have been two bits, 
and simply been about "nonblocking input" vs "nonblocking output" (so that 
you could control both sides on a call-by-call basis).

But I think that your patch is fundamentally correct with the semantics 
as-is.

		Linus
