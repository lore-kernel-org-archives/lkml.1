Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbZLFV1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbZLFV1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934221AbZLFV1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:27:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:64194 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934186AbZLFV1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:27:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nPWwALAskBqw7inWJi7446cIhYcZF055JGagFT/inAt7lGRAqMqMQCRvKW8NUh9bVc
         3B6qDK5kV+47Ds3gRcKFWg3NxdLNAnmxcUs8CSrV/54k+rLHsX1I0BYCukIT4aSmxqjm
         HpfuMAgFGOq9HUk2vnWSM7p75fzCrYn2AjP0A=
Subject: Re: XD/smartmedia - how to implement it right?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alex Dubov <oakad@yahoo.com>, J?rn Engel <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, arnd <arnd@arndb.de>
In-Reply-To: <20091205190913.GA1309@ucw.cz>
References: <109361.10237.qm@web37604.mail.mud.yahoo.com>
	 <1259589517.13049.31.camel@maxim-laptop>  <20091205190913.GA1309@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 23:27:00 +0200
Message-ID: <1260134820.23100.23.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-05 at 20:09 +0100, Pavel Machek wrote: 
> > > > First of all, thank you very much for your contributions.
> > > > Could you explain, why we need an asynchronous mtd driver?
> > > 
> > > Because it's the future. ;-)
> > Although I like the xD format, it has no future,
> > Everyone migrated to SD now.
> > 
> > Reasons are very simple:
> > 
> > 1 - xD hardcodes device sizes, thus if somebody makes say 8GB card, many
> > readers couldn't use it.
> > I know that windows driver I was dealing with supports sizes up to 2GB
> > 
> > 
> > 2 - xD is a nand card, but with 8-bit bus.
> > Newer nand chips seem to favor 16 bit bus or more.
> > Obviously, if they were to implement that it would be physically
> > incompatible.
> > 
> > 3 - embedded cpus are cheap dirt now, and allow to use their, always
> > 'better' FTL strategy, and also hide inner working of the chip.
> 
> XDs are still used by at least olympus digital cameras. Ouch.
Well, at least according to wikipedia, Olympus phased out XD support, as
well as Fuji.
This doesn't mean that there will be no users of XD in five following
years, thats why I am writing the driver in first place.


> 
> If you have onboard embedded cpu, you can bet it will not work
> correctly over powerfail. If you do FTL on host, you have at least
> chance to get it right.
Thats correct. In fact we are both right here.
Your viewpoint is based on a view of an user of a sane operation system.
Sure, the whole idea of FTL is evil, the perfect place for wear leveling
is in the filesystem itself, and in addition to that, there are several
technologies that imply finite write cycle count, and that reason
justifies such filesystem even more.

I also use the same sane operation system, so for me its quite nice to
have XD^WNAND removable chip support, and in my eyes the raw access to
flash is very nice advantage.

However, due to limitations of other less sane operation systems,
hardware makers have to support wear leveling ether in the driver or in
the hardware.
This is yet another example, about why some operation systems 'just
work'...
Not that these operation systems are better, but that hardware makers do
everything possible to patch all problems these operation systems have.
Same is true for software generally.


Supporting wear leveling in hardware is easier, because this way, they
can be sure it works well, and not depend on each and every driver
implementation to do that right.

Small hint, you know how the windows driver for my controller handles
COW?
Very simple, every 512 bytes write (only accepts such) turns into whole
erase/write cycle of whole block (32 KB usually).

So, if you write a 32K or larger file , and no matter how clever the OS
is, it will still end in 64 erase cycles...


Best regards,
Maxim Levitsky

