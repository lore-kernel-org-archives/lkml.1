Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXCULjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXCULjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXCULjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:39:08 -0400
Received: from lazybastard.de ([212.112.238.170]:37609 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXCULjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:39:07 -0400
Date: Wed, 21 Mar 2007 12:35:23 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070321113523.GD3785@lazybastard.org>
References: <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain> <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174476334.10840.49.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 March 2007 12:25:34 +0100, Thomas Gleixner wrote:
> On Wed, 2007-03-21 at 12:05 +0100, Jörn Engel wrote:
> > 
> > Ok, now we have reached the absurd.  UBI quite fundamentally cannot do
> > wear leveling as good as LogFS can.  Simply because UBI has zero
> > knowledge of the _contents_ of its blocks.  Knowing whether a block is
> > 90% garbage or not makes a great difference.
> > 
> > Also LogFS currently requires erasesizes of 2^n.
> 
> Last time I talked to you about that, you said it would be possible and
> fixable. We talked about several mechanisms, which would allow a
> filesystem or other users to hint such things to UBI.

Note the word "currently".  And yes, we did talk about hints.  Back then
I still believed in UBI.  That has changed and I would like to spare
myself another flamewar, so please leave it at that.

> Even if the LogFS wear levelling is so superior, it CAN'T do across
> device wear levelling.

Correct.  And I don't see any problem with this.  I see two classes of
usecases for flash, with some amount of overlap in between.

1. Small amounts of flash.

Here the flash contains a large ratio of read-only data.  Bootloader,
kernel, etc.  Having wear levelling across the device will gain you
something.  This is what you designed UBI for.

2. Large amounts of flash.

Just to be precise, large can go well into the Terabyte range and
beyond.  I don't mean large as in "the biggest embedded device I worked
on last year" - that is still small.

Even if such flashes still contain a bootloader and a kernel, that will
occupy less than 1% of the device.  Wear leveling across the device is
fairly pointless here.  This is what I designed LogFS for.


There is some middle ground where a combination of UBI and LogFS may
make sense.  LogFS can still make sense for devices as small as 64MiB.
But I'm not too concerned about that because flashes will continue to
grow and the advantages of cross-device wear leveling will continue to
diminish.

Jörn

-- 
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
