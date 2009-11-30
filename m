Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZK3XEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZK3XEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZK3XE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:04:27 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56772 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZK3XE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JBVQ9lfyS8eqmVQQ7//TuFLaLRe1/s4Qa1r3A4EKs1dc0AFEhyIRYKKnio8rjwLw4w
         bZZfNPplt7s9tQEvBsK5bruXMEQ/dnkG885/kNWKNCRoJeOeYI21FZY/TB2yDPYfSeRK
         gCNu6dleQ0Zp1f4AozFrv0lhwX0AHuKodtjok=
Subject: Re: XD/smartmedia - how to implement it right?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       tglx@linutonix.de
In-Reply-To: <1259589517.13049.31.camel@maxim-laptop>
References: <109361.10237.qm@web37604.mail.mud.yahoo.com>
	 <1259589517.13049.31.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 01:04:26 +0200
Message-ID: <1259622266.6559.40.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 15:58 +0200, Maxim Levitsky wrote: 
> On Mon, 2009-11-30 at 04:35 -0800, Alex Dubov wrote: 
> > 
> > --- On Sat, 11/28/09, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > > Subject: Re: XD/smartmedia - how to implement it right?
> > > To: "Alex Dubov" <oakad@yahoo.com>
> > > Cc: "Jörn Engel" <joern@logfs.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, arnd@arndb.de, tglx@linutonix.de
> > > Date: Saturday, November 28, 2009, 2:36 AM
> > > On Fri, 2009-11-27 at 23:22 -0800,
> > > Alex Dubov wrote: 
> > > > > 
> > > > > The "mtd uses blocking calls" argument I can
> > > help
> > > > > with.  For some other
> > > > > project I've added non-blocking calls to mtd[1].
> > > > > 
> > > > > Biggest problems I see are a) the userspace
> > > interface and
> > > > > b) allowing
> > > > > both raw flash access through MTD and block
> > > device access
> > > > > with an FTL.
> > > > > 
> > > > > [1] http://lists.infradead.org/pipermail/linux-mtd/2009-November/028065.html
> > > > > 
> > > > > Jörn
> > > > 
> > > > I actually tried several approaches to this problem
> > > and I think, I have a good idea about how to create a fully
> > > asynchronous mtd driver, which can handle different device
> > > models. Unfortunately, I had other commitments so I couldn't
> > > advance my mtd stuff.
> > > > 
> > > > Recently I was going to go back to it, but then I was
> > > asked to implement some additional functionality in rapidio
> > > subsystem, which I'll have to take care of first.
> > > 
> > > Hi, 
> > > 
> > > First of all, thank you very much for your contributions.
> > > Could you explain, why we need an asynchronous mtd driver?
> > 
> > Because it's the future. ;-)
> Although I like the xD format, it has no future,
> Everyone migrated to SD now.
> 
> Reasons are very simple:
> 
> 1 - xD hardcodes device sizes, thus if somebody makes say 8GB card, many
> readers couldn't use it.
> I know that windows driver I was dealing with supports sizes up to 2GB
> 
> 
> 2 - xD is a nand card, but with 8-bit bus.
> Newer nand chips seem to favor 16 bit bus or more.
> Obviously, if they were to implement that it would be physically
> incompatible.
> 
> 3 - embedded cpus are cheap dirt now, and allow to use their, always
> 'better' FTL strategy, and also hide inner working of the chip.
> 
> Memstick pro is also today sort of SD card, but for Sony its their first
> priority to keep proprietary standards even if inferior.
> I won't be surprised though if this format dies too.
> 
> Could you explain why we need an asynchronous interface?
> I understand that filesystem/page cache/block cache/and block layer,
> already provide caches and asynchronous behavior.
> 
> Only maybe reading several pages at time, and writing could benefit, but
> many devices don't support that feature.
> And again, bulk of the time will be spend writing, and only saving will
> be from queuing more work to the device.
> 
> 
> 
> > 
> > > 
> > > Also, as I understand the command interface more and more,
> > > it seems that
> > > 'magically' xD card had same interface as standard NAND
> > > flash chip.
> > > 
> > > I think I can implement the driver for each controller just
> > > like an nand
> > > chip driver.
> > > 
> > 
> > xD spec, first of all, is about flash-based ordinary block devices.
> > All the hard problems are in good r/w FTL implementation, which is
> > currently mostly absent from the MTD.
> 
> Its true, and I will write an r/w FTL for xD devices, in same manner as
> existing FTL implementations.
> It works above the mtd layer btw.


Alex, could you do me a favor, and explain why partial block writes
don't work?
What happens if its done?

the FTL layer of course will do full block writes, but its not easy to
do full block writes in mtd layer.

If I was going to do full block writes, I would need to set
page_size = block size, and then loose many features nand mtd supports.


Best regards,
Maxim Levitsky


