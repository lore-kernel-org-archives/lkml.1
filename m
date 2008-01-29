Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYA2FCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYA2FCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYA2FCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:02:14 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47386 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYA2FCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:02:13 -0500
Subject: Re: Problem with ata layer in 2.6.24
From: Kasper Sandberg <lkml@metanurb.dk>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
In-Reply-To: <200801282349.11696.gene.heskett@gmail.com>
References: <200801272122.21823.gene.heskett@gmail.com>
	 <200801281135.14555.gene.heskett@gmail.com>
	 <1201580616.12795.2.camel@localhost>
	 <200801282349.11696.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 06:01:15 +0100
Message-Id: <1201582875.12795.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-28 at 23:49 -0500, Gene Heskett wrote:
> On Monday 28 January 2008, Kasper Sandberg wrote:
>  [...]
<snip>
> >
> >I can invalidate this theory...
> >i helped a guy on irc debug this problem, and he had ati. I tried having
> >him stop using fglrx, and go to r300.. same problem, and same problem
> >even with vesa.. :)
> >
> No Kasper, you are validating it, that it is not nvidia related, which is what 
> I was also saying.
yeah thats what i mean - i can invalidate the theory that all the
affected boxes run nvidia.

> 
> >also, i have this on my fileserver with .20, which doesent even run X,
> >or module support in kernel :)
> 
> That far back?  Although ISTR I saw it happen once only when I was running 
> 2.6.18-somethingorother.

Yes im afraid so.. i will now provide some complete details, as i feel
they are relevant.

the thing is, i run 6x300gb disks, IDE, in raid5.

i have both an onboard via ide controller, and then i bought a promise
pdc 202 new thingie. i had problem however..

after a bit of time, i would get DMA reset error thing, and it all
kindof went NUTS. it was as if all data access were skewed, and as you
might imagine, this made everything fail badly.

i purchased an ITE based controller for the drives on the promise, but
exactly the same thing happened.

the errors i got was:
hdf: dma_intr: bad DMA status (dma_stat=75)
hdf: dma_intr: status=0x50 { DriveReady SeekComplete }
ide: failed opcode was: unknown
---

i then found new hope, when i heard that libata provided much better
error handling, so i upgraded to .20.

this made my box usable.

the error happens once or twice a day, the disk led will turn on
constantly, and all IO freezes for about half a minute, where it returns
PROPERLY(thank you libata!). as far as i can tell, the only side effect
is that i get those messages like described here, and flooded with on
google.

to put some timeline perspective into this.
i believe it was in 2005 i assembled the system, and when i realized it
was faulty, on old ide driver, i stopped using it - that miht have been
in beginning of 2006. then for almost a year i werent using it, hoping
to somehow fix it, but in january 2007 i think it was, atleast in the
very beginning of 2007, i hit upon the idea of trying libata, and ever
since the system has been running 24/7 - doing these errors around 2
times a day.

i have multiple times reported my problems to lkml, but nothing has
happened, i also tried to aproeach jgarzik direcly, but he was not
interested.

i really hope this can be solved now, its a huge problem

my fileserver has an asus k8v motherboard, with via chipset (k8t880 i
think it is, or something like it). currently using the promise
controller again(strangely enough all the timeouts seems to happen here,
and when the ITE was on, there, not the onboard one), in conjunction
with the onboard via.


> >> complaint.  Again, fix the nv driver so it will run my screen & I'll be
<snip>

