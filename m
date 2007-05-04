Return-Path: <linux-kernel-owner+w=401wt.eu-S1767680AbXEDFac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767680AbXEDFac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767692AbXEDFac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:30:32 -0400
Received: from 1wt.eu ([62.212.114.60]:2486 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767680AbXEDFab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:30:31 -0400
Date: Fri, 4 May 2007 07:30:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Message-ID: <20070504053027.GA32604@1wt.eu>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com> <20070503205341.GB943@1wt.eu> <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr> <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com> <20070503222334.GD943@1wt.eu> <d20c3b7d0705032048l8c10d11i98a13881b1c8b3f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d20c3b7d0705032048l8c10d11i98a13881b1c8b3f3@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 05:48:18AM +0200, Øyvind Vågen Jægtnes wrote:
> Hi again :)
> 
> On 5/4/07, Willy Tarreau <w@1wt.eu> wrote:
> >On Thu, May 03, 2007 at 11:12:09PM +0200, Øyvind Vågen Jægtnes wrote:
> >> On 5/3/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> >> >
> >> >On May 3 2007 22:53, Willy Tarreau wrote:
> >> >>> For the rest all we see in the arp cache is (incomplete)
> >> >>
> >> >>I suspect that your arp cache is full (128 entries by default).
> >> >>Check /proc/sys/net/ipv4/neigh/gc_thresh1 (128 for me). You can
> >> >>set it as high as gc_thresh2 (512 for me), and I don't know what
> >> >>happens above.
> >> >
> >> >Above, you will perhaps need the not-so-elegant userspace arpd :-/
> >>
> >> Yes, i was suspecting that the arp cache got full, but i will try
> >> increasing it :)
> >> Would there be any huge bugs if i change these lines in arp.c:
> >>
> >>        .gc_thresh1 =   128,
> >>        .gc_thresh2 =   512,
> >>
> >> to
> >>
> >>        .gc_thresh1 =   700,
> >>        .gc_thresh2 =   700,
> >>
> >> under the definition for struct arp_tbl?
> >
> >I don't think it could cause a problem, but network people will surely
> >correct me if I'm wrong.
> 
> System is up and running perfectly now, it is routing everything at
> about 200 mbps now with only 5% load avg with the above changes to
> arp.c
> 
> So the real question now is, why is this number so low by default?
> It would probably be much better if this could be handled dynamically
> in the kernel.

I remember I read an argument against this a long time ago, but I
don't remember where. I think it was some arbitrary decision that
people using more than X ARP entries will need arpd. Most probably
the code path in the ARP updates is/was not much optimized to handle
large number of entries. Think about cable operators who may have
10-20000 entries !

> Its a Juniper M7i
> It comes default with a 5400 rpm laptop 2.5" harddrive but now we
> bought a more robust "server" 2.5" harddrive.

The "server" ones are not necessarily more robust, often they are faster.

> It still barfs on the OS
> install, so the linux is doing all the job now. Will get a juniper guy
> to come and fix :)
> 
> As a side note, i'm starting to wonder if it was worth the $20k when i
> could just have a linux machine to do the job with a clone for backup
> ;)

That's often how linux penetrates the enterprise ;-)

Willy

