Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbZFPPIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbZFPPIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZFPPHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:07:50 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48493 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZFPPHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:07:48 -0400
Date: Tue, 16 Jun 2009 16:07:50 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090616150750.GF29040@shareable.org>
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090614114613.GC9514@shareable.org> <4A351FA9.1090808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A351FA9.1090808@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco wrote:
> There's the checksum, but the most important feature of this fs is the
> write protection. The page table entries that map the
> backing-store RAM are normally marked read-only. Write operations into
> the filesystem temporarily mark the affected pages as writeable, the
> write operation is carried out with locks held, and then the pte is
> marked read-only again. This feature provides protection against
> filesystem corruption caused by errant writes into the RAM due to
> kernel bugs for instance. I provided a test module for this. When the
> module is loaded tries to do a dirty write in the superblock, at this
> point you should see an error on the write.

Ok.  Random question: does it work with NOMMU? :-)  (I'm biased, my
devices are NOMMU).

Second question: what happens if the system crashing _during_ a write
to a file.  Does it mean that file will fail it's checksum when it's
read at the next boot?

Maybe files aren't so important.  What about when you write a file,
and then rename it over an existing file to replace it.  (E.g. a
config file), and the system crashes _during_ the rename?  At the next
boot, is it guaranteed to see either the old or the new file, or can
the directory be corrupt / fail it's checksum?

> > As you say PRAMFS can work with special SRAMs needing memory
> > protection (and maybe cache coherence?), if you mmap() a file does it
> > need to use the page cache then?  If so, do you have issues with
> > coherency between mmap() and direct read/write?
> 
> See my response above about my concept of protection. However the mmap
> it's a similar approach. I can "mmap" the SRAM and I can write into it
> my data, but I think the possibility to have a fs it's great. We can use
> the device as normal disk, i.e. we can use cp, mv and so on.

I meant when you mmap() a file on the filesystem, like you do when
running an executable, for example.  Does mmap() on a file work or is
it forbidden?  Just curious, I'd guess it's forbidden, and you
wouldn't want _direct_ mappings to the backing SRAM anyway so you can
keep those checksums up to date.

> >> On this point I'd like to hear other embedded guys.
> > 
> > As one, I'd like to say if it can checksum the RAM at boot as well,
> > then I might like to use a small one in ordinary SRAM (at a fixed
> > reserved address) for those occasions when a reboot happens
> > (intentional or not) and I'd like to pass a little data to the next
> > running kernel about why the reboot happened, without touching flash
> > every time.
> > 
> > -- Jamie
> 
> Yeah Jamie, the goal of this fs is exactly that!

Great :-)

-- Jamie
