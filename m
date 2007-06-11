Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbXFKOFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbXFKOFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXFKOF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:05:27 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:31902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXFKOFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sFLhsEEO8xXDhm0nuN6ejLBvfN/s47qVgk7gvcmD3UO93pyRG0KiKpwNYQ1pslej17lt6Jeh1c2AOjM3MXHZ3c1ZUOmQ67YWxJ1STqQyGxM/+j9J80kyzPD5JJryNcLSMohK1KliodFRlYC5ekR5w2so2SoTJDywmxaiTxOjd0k=
Message-ID: <f9be06770706110705l59f878buf4c0e16cf081dc6d@mail.gmail.com>
Date: Mon, 11 Jun 2007 10:05:24 -0400
From: "Karl Pickett" <karl.pickett@gmail.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: Kernel BUG when using corrupted ext3 fs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070611114109.GC26561@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f9be06770706080751y4bbb60d0q3a2286d8e2b576f6@mail.gmail.com>
	 <f9be06770706080753m41959da2m2034e428854c1c0b@mail.gmail.com>
	 <20070611114109.GC26561@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
> > I had to hard shutdown a fc6 machine due to vmware and nvidia doing
> > ridiculous things to my screen resolution and locking up.  ugh.
> > Anyway, upon reboot it recovers the journal and mounts / rw fine.
> > Then rc.sysinit tries to delete various things from /tmp (.ICE-unix,
> > .font stuff, etc), kernel shows a BUG, and boot stops.  Booting from a
> > fc7 live cd and trying to mount /dev/sda2 rw and delete /tmp/* also
> > causes a BUG.  This dump is from fc7:
> >
> >
> > eth0: no IPv6 routers present
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on sda2, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev sda2, type ext3), uses xattr
> > inode_doinit_with_dentry:  getxattr returned 5 for dev=sda2 ino=13271075
> > EXT3-fs warning (device sda2): ext3_unlink: Deleting nonexistent file
> > (13271075), 0
>   Obviously, ext3 was not consistent after replaying the journal which
> should never happen. Do you have somewhere available the original
> filesystem image or at least messages from fsck when fixing the
> filesystem?

Unfortunately, no.  I did not think of logging the fsck output :(  I
recall hitting 'y' to fix about 30 things, with the last fixes being
something like superblocks not matching each other which I hadn't seen
before.  This machine had also been hard powered off at least 5 times
before in the last few months (due to nvidia lockups).

-- 
Karl Pickett
