Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbXIZAYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbXIZAYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXIZAX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:23:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52571 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXIZAX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:23:56 -0400
Date: Wed, 26 Sep 2007 01:23:40 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <david@davidnewall.com>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926002340.GL8181@ftp.linux.org.uk>
References: <46F0CD96.9030807@prepere.com> <20070919104018.3a6bcfb1@the-village.bc.nu> <46F16A0A.3070402@tmr.com> <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F9752C.5080807@cfl.rr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 04:53:00PM -0400, Phillip Susi wrote:
> Alan Cox wrote:
> >On Fri, 21 Sep 2007 13:39:34 -0400
> >Phillip Susi <psusi@cfl.rr.com> wrote:
> >
> >>David Newall wrote:
> >>>* In particular, the superuser can escape from a =91chroot jail=92 by d=
> >>>oing=20
> >>>=91mkdir foo; chroot foo; cd ..=92.
> >>No, he can not.
> >
> >The superuser can escape that way - its expected and fine behaviour
> 
> Does not work for me, and that would be the EXACT thing chroot is 
> supposed to prevent.  Maybe you guys are thinking of a program that 
> calls chroot() but leaves cwd outside the chroot still being able to 
> navigate outside of it?

Oh, for fsck sake...  Folks, it's standard-required behaviour.  Ability
to chroot() implies the ability to break out of it.  Could we please
add that (along with reference to SuS) to l-k FAQ and be done with that
nonsense?

If you are within chroot jail and capable of chroot(), you can chdir to
its root, then chroot() to subdirectory and you've got cwd outside of
your new root.  After that you can chdir all way out to original root.

Again, this is standard behaviour.  Changing it will not yield any
security improvements, so kindly give that a rest.
