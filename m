Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZEIQXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZEIQXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZEIQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:23:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:59338 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbZEIQXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:23:12 -0400
Date: Sat, 9 May 2009 09:19:23 -0700
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090509161923.GA942@suse.de>
References: <20090509143742.GA27663@kroah.com> <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com> <20090509150853.GA32394@suse.de> <20090509082233.32cbb8e4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509082233.32cbb8e4@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 08:22:33AM -0700, Arjan van de Ven wrote:
> On Sat, 9 May 2009 08:08:53 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > > Well, guess you meant the opposite ;-)
> > 
> > Heh, yes, sorry about that.  It makes booting faster :)
> 
> .. and I don't buy that.

Kay posted numbers showing this.

I have bootchart graphics somewhere around here that also shows this.

> The only argument I've heard is "oh but it's hard". No it's not.

No, it's not "hard", it's just reality :)

> The other argument is "but for more partitions we get other device
> numbers"... you know what, that's easy to fix. Just make the 32 bit dev
> number consistent. Few lines of code I bet, and it is benefit for
> everyone to do that....

Huh?  We need to be able to support large number of partitions at boot
time.  We also need to support an initrd, and not a static /dev/ tree at
boot time, as that is what the world requires from a flexible Linux
distro that runs on multiple types of hardware configurations.

Sure, if you can ensure your hardware platform isn't going to change,
and is relativly limited (as Moblin currently does), then you don't need
an initrd and you can get away with a static /dev and save a few
hundred's of a second.  But the distros can't do that, they are stuck
supporting users with tens of partitions and other "wierd"
configurations.

> Beyond that... this is not needed... but at least call it "devfs".. for
> what it is.

It's not a stand-alone filesystem.  It's an in-kernel mknod on top of
tmpfs.  Heck, if it's just a matter of the name change, I'll gladly do
it.  That doesn't stop the fact that it's still a very useful and needed
option for lots of configurations where Linux is used (embedded, rescue
disks, fast boot on flexable distros, etc.)

> (and yes there is very obvious irony)

devfs was removed for a number of other reasons (bad code, maintainer
left, in-kernel policy that was in contrast to the LSB, modprobe from
within the kernel, thousands of lines of code, etc.)  Turns out that the
idea of a devfs is a good one, and here is a simple, and easy to
understand and maintain implementation of such a thing.

I'll be the first to say this, hence it is without irony that I am
proposing it be included.

If there are any technical problems with the proposed patches, please
let us know.

thanks,

greg k-h
