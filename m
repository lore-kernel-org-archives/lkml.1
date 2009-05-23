Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZEWQvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZEWQvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZEWQvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:51:23 -0400
Received: from bu3sch.de ([62.75.166.246]:56255 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbZEWQvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:51:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
Date: Sat, 23 May 2009 18:50:14 +0200
User-Agent: KMail/1.9.9
Cc: Michael Riepe <michael.riepe@googlemail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       Michael =?utf-8?q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <4A182066.9030201@googlemail.com> <1243097173.4217.7.camel@obelisk.thedillows.org>
In-Reply-To: <1243097173.4217.7.camel@obelisk.thedillows.org>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905231850.14725.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009 18:46:13 David Dillow wrote:
> On Sat, 2009-05-23 at 18:12 +0200, Michael Riepe wrote:
> > If I use two connections (iperf -P2) and nail iperf to both threads of a
> > single core with taskset (the program is multi-threaded, just in case
> > you wonder), I get this:
> > 
> > CPU 0+2:  0.0-60.0 sec  4.65 GBytes    665 Mbits/sec
> > CPU 1+3:  0.0-60.0 sec  6.43 GBytes    920 Mbits/sec
> > 
> > That's quite a difference, isn't it?
> > 
> > Now I wonder what CPU 0 is doing...
> 
> Where does /proc/interrupts say the irqs are going?
> 
> 
> 

For me it looks like this:
 24:   52606581          0          0          0   PCI-MSI-edge      eth0

So as I have the same CPU as Michael Riepe, I think CPU0 (core0) servicing
interrupts is related to the issue.

I'm wondering however, if this is expected behavior. iperf and interrupts will
pretty much saturate a core of the atom330. So it looks like a plain CPU bottleneck.

-- 
Greetings, Michael.
