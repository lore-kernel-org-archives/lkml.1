Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXJYEmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXJYEmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXJYEmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:42:07 -0400
Received: from main.gmane.org ([80.91.229.2]:39459 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbXJYEmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:42:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Sky2 Driver Issue
Date: Wed, 24 Oct 2007 21:41:31 -0700
Organization: Linux Foundation
Message-ID: <20071024214131.50f36fee@freepuppy.rosehill>
References: <7b9198260710241058o49a5eb93sf4fa8c22cc037a0e@mail.gmail.com>
	<7b9198260710241106l1c24ef8cgbd56da60ba28122@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <7b9198260710241106l1c24ef8cgbd56da60ba28122@mail.gmail.com>
X-Newsreader: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 19:06:37 +0100
"Tom Spink" <tspink@gmail.com> wrote:

> On 24/10/2007, Tom Spink <tspink@gmail.com> wrote:
> > Hi,
> >
> > A couple of kernels ago, I ran into an issue with the sky2 driver.
> > Basically, I began getting repeated errors on my console of the
> > following:
> >
> > Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0x80000000
> > Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0xc0000000
> >
> > Which eventually led to:
> > Oct 21 16:33:49 holly kernel: printk: 92 messages suppressed.
> >
> > Here is a section of the log that may be useful:
> > Oct 21 16:33:37 holly kernel: sky2 eth1: enabling interface
> > Oct 21 16:33:38 holly dhclient: DHCPDISCOVER on eth1 to
> > 255.255.255.255 port 67 interval 8
> > Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0x80000010
> > Oct 21 16:33:39 holly kernel: sky2 eth1: Link is up at 1000 Mbps, full
> > duplex, flow control both
> > Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0x80000000
> > Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0xc0000000
> > Oct 21 16:33:40 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0x80000000
> > Oct 21 16:33:40 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0xc0000000
> > Oct 21 16:33:41 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0x80000000
> > Oct 21 16:33:41 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0xc0000000
> > Oct 21 16:33:42 holly kernel: sky2 0000:04:00.0: error interrupt
> > status=0x80000000
> >
> > These messages are appearing on all the VTs, and because they keep
> > popping up, I can't reasonably use the consoles to test if the network
> > driver is working.
> >
> > The kernel I've got going at the moment is 2.6.23-rc9 with git
> > revision g804b3f9a, and it's fine.  The error surfaced _sometime_
> > after this.  Attached is my .config.
> >
> > I'll try rebooting and pinging the machine to see if the network
> > driver is working, and this is just (unnecessary?) spew from the
> > kernel.
> >
> > --
> > Regards,
> > Tom Spink
> > University of Edinburgh
> >
> >
> 
> Hi again,
> 
> So it seems the driver and the network card is functioning, but I'm
> getting the 'error interrupt' message plastered over every console.
> 
> I can ping and ssh into the computer, but the message is still
> scrolling everything off my screens.
> 

Your system is not supporting MMCONFIG access to allow driver to turn off
PCI express error value.  It looks like the hw error irq mask doesn't work
as expected either.

What is your kernel config?


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

