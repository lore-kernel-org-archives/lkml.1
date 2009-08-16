Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZHPPcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZHPPcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZHPPcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:32:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:57256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZHPPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:32:18 -0400
Date: Sun, 16 Aug 2009 08:34:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@suse.de>, Mark Lord <liml@rtr.ca>,
       Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
Message-ID: <20090816083434.2ce69859@infradead.org>
In-Reply-To: <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
References: <200908122007.43522.ngupta@vflare.org>
	<20090813151312.GA13559@linux.intel.com>
	<20090813162621.GB1915@phenom2.trippelsdorf.de>
	<alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	<87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	<alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	<3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>
	<4A85E0DC.9040101@rtr.ca>
	<f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
	<20090814234539.GE27148@parisc-linux.org>
	<f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>
	<1250341176.4159.2.camel@mulgrave.site>
	<4A86B69C.7090001@rtr.ca>
	<1250344518.4159.4.camel@mulgrave.site>
	<20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009 15:05:30 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sat, 15 Aug 2009 08:55:17 -0500
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > On Sat, 2009-08-15 at 09:22 -0400, Mark Lord wrote:
> > > James Bottomley wrote:
> > > >
> > > > This means you have to drain the outstanding NCQ commands
> > > > (stalling the device) before you can send a TRIM.   If we do
> > > > this for every discard, the performance impact will be pretty
> > > > devastating, hence the need to coalesce.  It's nothing really
> > > > to do with device characteristics, it's an ATA protocol problem.
> > > ..
> > > 
> > > I don't think that's really much of an issue -- we already have
> > > to do that for cache-flushes whenever barriers are enabled.  Yes
> > > it costs, but not too much.
> > 
> > That's not really what the enterprise is saying about flush
> > barriers. True, not all the performance problems are NCQ queue
> > drain, but for a steady workload they are significant.
> 
> Flush barriers are nightmare for more than enterprise. You drive
> basically goes for a hike for a bit which trashes interactivity as
> well. If the device can't do trim and the like without a drain I
> don't see much point doing it at all, except maybe to wait for idle
> devices and run a filesystem managed background 'strimmer' thread to
> just weed out now idle blocks that have stayed idle - eg by adding an
> inode of all the deleted untrimmed blocks and giving it an irregular
> empty ?
> 

trim is mostly for ssd's though, and those tend to not have the "goes
for a hike" behavior as much......

I wonder if it's worse to batch stuff up, because then the trim itself
gets bigger and might take longer.....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
