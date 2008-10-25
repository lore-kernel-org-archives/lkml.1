Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYJYIPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYJYIPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 04:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYJYIPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 04:15:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYJYIO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 04:14:59 -0400
Subject: Re: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
From: David Woodhouse <dwmw2@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1224890002.3248.71.camel@calx>
References: <1224879959.3248.32.camel@calx>
	 <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz>
	 <1224890002.3248.71.camel@calx>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 09:14:52 +0100
Message-Id: <1224922492.18031.12.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 18:13 -0500, Matt Mackall wrote:
> On Sat, 2008-10-25 at 00:15 +0200, Jiri Kosina wrote:
> > On Fri, 24 Oct 2008, Matt Mackall wrote:
> > 
> > > We've added 12k of new initdata to allnoconfig builds for i8042 DMI
> > > lookup tables:
> > > 
> > > http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/drivers
> > > 
> > > It looks like each table entry is > 320 bytes as we reserve four 80-byte
> > > slots in each for DMI match strings. 
> > 
> > Umm, and what is the actual problem with that, really?
> 
> The actual problem is that if the kernel grows by 12k every time a
> developer says "what's the big deal?" the kernel will become very large
> indeed.
> 
> > OK, we can remove it from .init, but then it will be rotting in memory 
> > forever, which is quite sub-optimal, when this kind of DMI information is 
> > needed only during initialization.
> 
> I wasn't complaining that they were in init, but rather that they were
> 12k. For something like 37 entries. The entry size is ridiculous and
> looks to have grown by a factor of 10 since 2.6.27. What, as they say,
> is up with that?
> 
> It looks like David Woodhouse is to blame:
> 
> commit d945b697d0eea5a811ec299c5f1a25889bb0242b
> Automatic MODULE_ALIAS() for DMI match tables.
> 
> This is probably also responsible for most of the growth in x86 I
> mentioned elsewhere, so it's about 25-30k damage in total. David?

There's an assessment of this in the commit comment which you omitted.

It compresses well, and it's __initdata. So it takes up very little
space in the bzImage, and is dropped fairly quickly during boot. So the
amount of time it's _actually_ taking up any noticeable amount of memory
is really quite small.

But if someone wants to extend modpost so that it can handle relocations
and we can use string _pointers_ in the dmi tables, that would be good.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

