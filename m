Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbXHFRo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbXHFRo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbXHFRoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:44:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbXHFRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:44:10 -0400
Message-ID: <46B75DD4.5080709@redhat.com>
Date: Mon, 06 Aug 2007 13:43:48 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?TWFyY2luIMWabHVzYXJ6?= <marcin.slusarz@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
References: <1185322771.4175.102.camel@chaos> <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com> <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731132037.GC1046@ff.dom.local> <4bacf17f0708060000n5a00bb77i74adc3b4b28ac42b@mail.gmail.com> <20070806070300.GA4509@elte.hu>
In-Reply-To: <20070806070300.GA4509@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2007 03:03 AM, Ingo Molnar wrote:
> 
> But, since level types don't need this retriggers too much I think
> this "don't mask interrupts by default" idea should be rethinked:
> is there enough gain to risk such hard to diagnose errors?
>   
> 

I reverted those masking changes in Fedora and the baffling problem
with 3Com 3C905 network adapters went away.

Before, they would print:

eth0: transmit timed out, tx_status 00 status e601.
  diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
eth0: Interrupt posted but not delivered -- IRQ blocked by another device?
  Flags; bus-master 1, dirty 295757(13) current 295757(13)
  Transmit list 00000000 vs. f7150a20.
  0: @f7150200  length 80000070 status 0c010070
  1: @f71502a0  length 80000070 status 0c010070
  2: @f7150340  length 8000005c status 0c01005c

Now they just work, apparently...

So why not just revert the change?

