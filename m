Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbXFZKsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbXFZKsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbXFZKrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:47:55 -0400
Received: from mx10.go2.pl ([193.17.41.74]:59961 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752965AbXFZKry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:47:54 -0400
Date: Tue, 26 Jun 2007 12:56:02 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070626105602.GD2691@ff.dom.local>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <4680D162.9050603@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4680D162.9050603@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 06:42:10PM +1000, Nick Piggin wrote:
...
> They should also improve performance in heavily contended case due to
> the nature of how they spin, but I know that's not something you want
> to hear about. And theoretically there should be no reason why xadd is
> any slower than dec and look at the status flags, should there? I never
> implementedit in optimised assembly to test though...
...

BTW, could you explain why the below diagnose doesn't relate
to your solution?

On 06/21/2007 12:08 PM, Ingo Molnar wrote:
...
> So it seems the problem was that if a core kept _truly_ modifying a 
> cacheline via atomics in a high enough frequency, it could artificially 
> starve the other core. (which would keep waiting for the cacheline to be 
> released one day, and which kept the first core from ever making any 
> progress) To me that looks like a real problem on the hardware side - 
> shouldnt cacheline ownership be arbitrated a bit better than that?
> 

Thanks & regards,
Jarek P.
