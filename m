Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXFOQQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXFOQQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXFOQQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:16:39 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:61306 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbXFOQQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:16:38 -0400
Date: Fri, 15 Jun 2007 18:16:44 +0200
From: DervishD <lkml@dervishd.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070615161644.GB2373@DervishD>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org> <20070614201714.GC1928@DervishD> <20070614203800.GG31984@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614203800.GG31984@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jörn :)

 * Jörn Engel <joern@logfs.org> dixit:
> On Thu, 14 June 2007 22:17:14 +0200, DervishD wrote:
> >  * Jörn Engel <joern@logfs.org> dixit:
> > > 2. Wear leveling
> > > 
> > > Wear leveling happens implicitly by picking a different physical block
> > > from the spares on each write.  However, some blocks are never used.  If
> > > a physical block is mapped to a logical block that never gets written,
> > > it is out of the rotation.  Two seperate 1024-block areas have their
> > > internal wear leveling each, but nothing is spreading high wear from one
> > > area to another.
> > 
> >     I thought that wear leveling wasn't local to a group of blocks. This
> > means that you can destroy a flash memory by writing to the same
> > positions... which is a very common usage pattern.
> 
> That is correct.  Noticing this will take a while, though.  Even the
> worst chips sold today seem to have a manufacturer guarantee of 10.000
> erases per block.  Across a 16MB area, that means you have to write
> 160GB of data to that one area before you enter the danger zone.
> Significantly less with static data around, but still a lot.

    Yes, I understand. That's worse than I thought. I was right now
thinking about "PortableApps", a set of free software applications that
are a little bit modified to work from a pendrive in Windows. Very
useful, because you can carry your OpenOffice (or AbiWord) and Firefox,
for example, to any Windows you're doomed to use. This applications
write repeteadly to the pendrive (specially Firefox...), and I think
they may wear the drive prematurely if used extensively.
 
> And even when that happens, the chips doesn't suddenly explode on the
> 10.001st erase.  Your chances of getting correctable or uncorrectable
> errors will increase, though.

    So you have a zone which is unusable. Decent filesystems allow you
to mark some blocks as "dontuse" (ext2, for example). Does FAT allow
this?

> For the majority of use cases, such a behaviour is good enough.  It
> beats floppies hands down.  You will never wear them out with your
> digital camera or mp3 player.  Using it instead of a hard disk in your
> notebook may be a little risky, though.

    Yes, I know. I wasn't aware of the local wear leveling. Thanks a lot
for explaining, I will be much more gentle with my pendrives O:))

> 
> > > 4. FAT requirement
> > > 
> > > When I claimed there was nothing more to smartmedia, I was actually
> > > lying.  Smartmedia has the odd requirement that only FAT is supported as
> > > a filesystem.  In fact, the specifications describe FAT in great detail.
> > 
> >     Right, but I've seen many people using their pendrives with ext2
> > with no problems (e.g. for SLAX). So, what do you mean by "supported"?
> > If a filesystem can be used with the memory, do you mean that wear
> > leveling and other characteristics of the flash memory are tailored for
> > FAT? or do you mean you cannot use reliably (read: you will lose data)
> > other filesystems?
> 
> It doesn't matter much what I mean.  The question is how the
> manufacturer of your device interpreted it.  Most likely ext2 will work
> just fine within the limitations I've outlined.
> 
> What changes is the failure mode.  Floppies died from storing them in a
> dark and cool place.  Some were sold brand-new and dead.  Disks die from
> random, mostly mechanical, failures at a rate of 7% per years in a
> Google setup.  Flash usually dies from writing to it, the more you write
> the faster it dies.
> 
> So as long as you rarely write, pick any filesystem you like.  The
> choice only matters when you write a lot.

    I think I will be writing the pendrive, almost fully, once a week
(enough for an image of my home directory). That means less than 1GiB
written each week. That means 50-100 (in the worst case, making two
backups a week instead of one) writings each year in each block.

> > > a) Do wear leveling!
> > > 
> > > Smartmedia wear leveling is limited to within areas.  Any cross-device
> > > wear leveling must be done by the filesystem.  FAT does that fairly
> > > well.  The Ext family doesn't.
> > 
> >     Cross-device wear leveling? I don't understand, sorry O:)
> 
> Wear leveling across the whole device, not just one area.

    Oh, sorry, now I understand :))
 
> >     Thanks for your explanation, it has been very educational :)
> 
> No worries!

    That's the kind of information you never want anywhere when
investigating, so I'm very grateful for that, really :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
