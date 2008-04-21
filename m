Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYDUBp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYDUBp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYDUBps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:45:48 -0400
Received: from smtp.enter.net ([216.193.128.24]:1179 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYDUBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:45:47 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: x86: 4kstacks default
Date: Sun, 20 Apr 2008 21:45:44 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <200804201643.35830.dhazelton@enter.net> <480BB85A.6020508@firstfloor.org>
In-Reply-To: <480BB85A.6020508@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804202145.45146.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 17:40:42 Andi Kleen wrote:
> Daniel Hazelton wrote:
> > At 12 threads per request it'd only take about 4200 outstanding requests.
> > That is high, but I can see it happening.
>
> If it happens it just won't work on 32bit.

No, it won't. Which is what I was pointing out. You're hitting a different 
wall there.

> > Just makes you sound foolish. Run the numbers yourself and you'll see
> > that it is easy for a machine running highly threaded code to easily hit
> > 50K threads.
>
> I ran the numbers and the numbers showed that you need > 1.5GB of lowmem
> with a somewhat realistic scenario (32K per thread) at 50k threads. And
> subtracting 4k from that 32k number won't make any significant
> difference (still 1.3GB)
>
> If you claim that works on a 32bit system with typically 300-600MB
> lowmem available (which is also shared by other subsystem) I know who
> sounds foolish.

Never said it worked on a 32bit system. I was pointing out that there can be 
workloads that do reach that 50K thread-count that you seem to be 
calling "stupid". 

As I pointed out later in the message, I *HAVE* run into lowmem starvation on 
a 32bit x86 system. You thoughtfully removed this, perhaps because you felt 
it damaged your argument. The machine in question is an old P3 box with less 
than 1G of memory in it. (Phys+Swap on that machine is only about 1.4G)

So yes, on a 32bit machine you run into problems at much, much less of a 
workload and a much lower thread-count than the magic 50K you are so fond of 
talking about. If I had been running 4K stacks on that machine I probably 
would have survived the mis-configuration without the reboot it took to make 
the machine functional again - I probably would still have reconfigured 
Apache and MySQL, though - the machine still would have gone largely 
unresponsive.

DRH

--
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
