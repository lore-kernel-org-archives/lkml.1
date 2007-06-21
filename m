Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXFUQqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXFUQqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXFUQqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:46:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXFUQqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:46:19 -0400
Message-ID: <467AAB04.2070409@redhat.com>
Date: Thu, 21 Jun 2007 12:44:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu>
In-Reply-To: <20070621160817.GA22897@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2007 12:08 PM, Ingo Molnar wrote:
> yeah - i'm not at all arguing in favor of the BTRL patch i did: i always 
> liked the 'nicer' inner loop of spinlocks, which could btw also easily 
> use MONITOR/MWAIT.

The "nice" inner loop is necessary or else it would generate huge amounts
of bus traffic while spinning.

> So it seems the problem was that if a core kept _truly_ modifying a 
> cacheline via atomics in a high enough frequency, it could artificially 
> starve the other core. (which would keep waiting for the cacheline to be 
> released one day, and which kept the first core from ever making any 
> progress) To me that looks like a real problem on the hardware side - 
> shouldnt cacheline ownership be arbitrated a bit better than that?
> 

A while ago I showed that spinlocks were a lot more fair when doing
unlock with the xchg instruction on x86. Probably the arbitration is all
screwed up because we use a mov instruction, which while atomic is not
locked.

