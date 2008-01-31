Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbYAaMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbYAaMvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763581AbYAaMvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:51:11 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:42696 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761300AbYAaMvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:51:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jh/eUmQv9t168gZ/siwoqz8AJVODXp9d69+JRI+sa44lQCNZmaiZd+x4589LTO2wwtXaK/9cc+mbFlzr1T7qsrnTS4hP4Avvlta+8LxaHEPbH6hhDp6ZGrPFw1OfnYT0R1k86qn8f59Gg4gbCJ/YI2+vVMh2QFUfe6D86LKkvRY=  ;
X-YMail-OSG: j6GXlUAVM1mX35gDznDtaOBmpugNlwNIHox3TQ1qKQEWYUbyYxh5PSWmmK.Vi4o2qXqYh2Zr8g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Date: Thu, 31 Jan 2008 04:51:03 -0800
User-Agent: KMail/1.9.6
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       Francis Moreau <francis.moro@gmail.com>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com> <200801310027.25516.david-b@pacbell.net> <20080131084433.GA14160@linux-sh.org>
In-Reply-To: <20080131084433.GA14160@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801310451.03966.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008, Paul Mundt wrote:
> On Thu, Jan 31, 2008 at 12:27:24AM -0800, David Brownell wrote:
> > On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > > So basically, you're asking for maximum flexibility with minimum
> > > overhead.
> >
> > That's always a goal, but that's not what I said.  I was pointing out
> > one scenario I ran into ... where starting with the simple solution
> > ran into product issues which were unfixable without using some of the
> > more advanced (and nonportable!!) hardware mechanisms.
> >
> >
> > > I agree that should be the ultimate goal, but wouldn't it 
> > > be better to start with something more basic?
> > 
> > Where you start is often NOT where you end up!  You should make sure
> > that a wants-to-be-generic slave interface can accomodate a variety of
> > non-basic mechanisms, without getting bloated.  :)
> 
> I agree with Haavard here. The original dmaengine code was sparse at best
> and for a very specific type of workload, evolving that in to something
> that can be used by far more people with minimal pain is a good first
> step. Trying to overengineer it from the beginning to accomodate fringe
> controllers that already have an established API 

Which is not at all what I suggested.  When you want to set up a
straw man to argue against, please don't involve me!

First steps are after all followed by second steps, and often
by third steps.  It's not "overengineering" to recognize when
those steps necessarily have a direction.

In this case, that direction is "working on more hardware", so
evaluating the interface proposal against several types of
hardware is a good way to review it.  The hardware I referenced
doesn't seem "fringe" to me; it's used on more Linux systems
and by more users than the Synopsys design.  And I've seen some
of the same issues on other DMA controllers:  priority, options
for synchronization (e.g. after DMAREQ is signaled), and more.

In that vein, doesn't SuperH have DMA controllers to fit into this
proposed interface?  I don't know about such "fringe" hardware
myself, but it'd be good to know if this proposal is sufficient
for the needs of drivers there.

- Dave
