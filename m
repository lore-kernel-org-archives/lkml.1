Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZH1IiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZH1IiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZH1IiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:38:21 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43777 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZH1IiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Aq3JN/v406UOBEVSYjbmF/094KBNNmg2MgJ/N1cvXp7ZojuyZq5ybn04NRoTB2kOHt
         1bPZ0g6LHGQPFREosrQZl6/cXpD8nK4Ss+ovJNP+gAHhfh0HCIoOSo3kHAPvupRdBTxm
         1OltGNEFuvL/jrbeETfinIqIESLQl8LvgSRqA=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0908272348370.2888@localhost.localdomain>
References: <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	 <1251302598.18584.31.camel@twins>
	 <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	 <20090826180407.GA13632@elte.hu>
	 <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
	 <20090826193252.GA14721@elte.hu>
	 <alpine.DEB.1.10.0908261627110.5554@gentwo.org>
	 <20090826135041.e6169d18.akpm@linux-foundation.org>
	 <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz>
	 <4A96B997.1070001@nortel.com> <1251408785.3700.22.camel@raz>
	 <alpine.LFD.2.00.0908272348370.2888@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 11:38:17 +0300
Message-Id: <1251448697.3872.15.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-08-28 at 00:05 +0200, Thomas Gleixner wrote:
> On Fri, 28 Aug 2009, raz ben yehuda wrote:
> > On Thu, 2009-08-27 at 10:51 -0600, Chris Friesen wrote:
> > > On 08/26/2009 03:37 PM, raz ben yehuda wrote:
> > > > 
> > > > On Wed, 2009-08-26 at 15:15 -0600, Chris Friesen wrote:
> > > 
> > > >> We gave it as close to a whole cpu as we could using cpu and irq
> > > >> affinity and we used message queues in shared memory to allow another
> > > >> cpu to handle I/O.  In our case we still had kernel threads running on
> > > >> the app cpu, but if we'd had a straightforward way to avoid them we
> > > >> would have used it.
> > > 
> > > > Chris. I offer myself to help anyone wishes to apply OFFSCHED.
> > > 
> > > I just went and read the docs.  One of the things I noticed is that it
> > > says that the offlined cpu cannot run userspace tasks.  For our
> > > situation that's a showstopper, unfortunately.
> >
> > Given that your entire software is T size , and T' is the amount of real
> > time size, what is the relation T'/T ?
> > If T'/T << 1 then dissect it, and put the T' in OFFSCHED. 
> > My software T's is about 100MB while the real time section is about 60K.
> 
> Chris was stating that your offlined cpu cannot run userspace
> tasks. How is your answer connected to Chris' statement ? Please stop
> useless marketing. LKML is about technical problems not advertisement.
> 
> > They communicate through a simple ioctls.  
> 
> This is totally irrelevant and we all know how communication channels
> between Linux and whatever hackery (RT-Linux, RTAI, ... OFFLINE)
> works.
Why are you referring to the above projects as hacks ? What is a hack ?
> >               CPU isolation example: a transmission engine.
> > 
> > In the image bellow, I am presenting 4 streaming engines, over 4 Intels
> > 82598EB 10Gbps. A streaming engine is actually a Xeon E5420 2.5GHz.
> > Each engine has ***full control*** over its own interface. So you can:
> > 
> > 1. fully control the processor's usage.
> 
> By disabling the OS control over the CPU resource. How innovative.
I must say when a john doe like me receives this kind of response from names like Thomas Gleixner
it aches. 
> > 2. know **exactly*** how much each single packet transmission costs. for
> > example, in this case in processor 3 a single packet average
> > transmission is 1974tscs, which is ~700ns.
> > 
> > 3. know how many packets fails to transmit right **on time** ( the Lates
> > counter) . and on time in this case means within the 122us jitter. 
> 
> Are those statistics a crucial property of your OFFLINE thing ?
yes. latency is a crucial property. 
> > 4. There are 8 cores in this machine. The rest 4 OS cores are ~95% idle.
> > The only resource these cores share is the bus. 
> 
> That does not change the problem that you cannot run ordinary user
> space tasks on your offlined CPUs and you are simply hacking round the
> real problem which I outlined in my previous mail.
OFFSCHED is not just about RT. it is about assigning assignments to another resource 
outside the operating system. very much like GPUs, network processors,
and so on, but just with software that is accessible to the OS.
> Thanks,
> 
> 	tglx

