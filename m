Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYIOQk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYIOQk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYIOQkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:40:17 -0400
Received: from mail2.shareable.org ([80.68.89.115]:52119 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYIOQkP (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:40:15 -0400
Date: Mon, 15 Sep 2008 17:40:12 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Greg Ungerer <gerg@snapgear.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Message-ID: <20080915164012.GB13631@shareable.org>
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org> <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com> <48AE0476.80109@snapgear.com> <20080822181314.GB24179@shareable.org> <6934efce0808221116w76a662b0t954b0922b69d3232@mail.gmail.com> <20080822183713.GC24179@shareable.org> <6934efce0809121317r418c80e8s4755669cc74975c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0809121317r418c80e8s4755669cc74975c4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> > I think the "fast" in "fast synchronous" gives it away :-)
> 
> Yes, I suppose it does.
> 
> > I'm using Spansion MirrorBit S29GL128N, which reads at about 0.6 MByte/s.
> 
> I think you should get more like an order of magnitude higher.... Get
> an expert to look at your timings in the bootloader.  Make sure things
> are cached too.  ioremap_cached()...

Yes, looking at the Spansion datasheet, if it were interfaced properly
it should be quite fast.  (25ns access time for in-page 16-bit reads,
100ns for random reads).

I'll see if ioremap_cached() makes a difference to streaming read
performance.

The BSP suppliers have been quite cautious in places, flushing cache a
bit too often.  (I'm not surprised - we had disk ext3 filesystem
corruption due to insufficient cache flushing in places too.)

> > Oh, and it's a 166MHz ARM, so it's quite capable of decompressing
> > faster than the NOR can deliver.
> 
> Depends on how you are measuring it.   You ought to be able to get at
> least 2 orders of magnitude higher read speeds with a good sync Flash.
>  Some of the newer stuff is even faster.

Thanks.

Oh, how I look forward to the day of working with current kernels and
current hardware.

-- Jamie

