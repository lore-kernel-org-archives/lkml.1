Return-Path: <linux-kernel-owner+w=401wt.eu-S1751874AbZKVGjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbZKVGjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 01:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZKVGjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 01:39:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbZKVGjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 01:39:36 -0500
Date: Sun, 22 Nov 2009 07:39:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091122063926.GA18224@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091121222319.GA3905@swanrl.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Alan and Linus - mail repeated below. eot.)

* Robert Swan <swan.r.l@gmail.com> wrote:

> I posted this to the kernel-newbies list, but have graduated to the
> adults forum:
> 
> ! Two C programs are having a query-response conversation through a
> ! pseudo terminal:
> ! 
> ! A (client) -- forever { send query; read response }
> ! B (server) -- forever { read query; send response }
> ! 
> ! Neither has any I/O apart from the pty conversation, so I'd expect to
> ! see CPU usage at 100%. When I ran it, the CPU was pretty well idle.
> ! After a fair bit of fiddling, it turned out that both sides were
> ! taking about 8ms for their read() calls. At that point it seemed
> ! pretty clear that this was a delay in the kernel, not the code.
> ! 
> [snip]
> 
> 2.6.31-rc2-00205-gb4b21ca good
> 2.6.31-rc2-00206-gd945cb9 bad
> 
> and still bad with the latest: 2.6.32-rc8-00011-ga8a8a66
> 
> the git log says:
> ! commit d945cb9cce20ac7143c2de8d88b187f62db99bdc
> ! Author: Alan Cox <alan@linux.intel.com>
> ! Date:   Tue Jul 7 16:39:41 2009 +0100
> ! 
> !     pty: Rework the pty layer to use the normal buffering logic
> !     
> !     This fixes the ppp problems and various other issues with call locking
> !     caused by one side of a pty called in one locking context trying to match
> !     another with differing rules on the other side. We also get a big slack
> !     space to work with that means we can bury the flow control deadlock case
> !     for any conceivable real world situation.
> !     
> !     Signed-off-by: Alan Cox <alan@linux.intel.com>
> !     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> I can provide reasonably stripped down code which demonstrates the
> problem.  It has been reproduced by one other person, though his delay
> was about 2ms.
> 
> Have fun,
> 
> Rob.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
