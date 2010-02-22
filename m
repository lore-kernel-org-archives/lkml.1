Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0BVCDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 21:03:41 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46212
	"EHLO grelber.thyrsus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753844Ab0BVCDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 21:03:40 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
Date: Sun, 21 Feb 2010 20:03:35 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-17-generic; KDE/4.2.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, qemu-devel@nongnu.org,
       blauwirbel@gmail.com, pbonzini@redhat.com, atar4qemu@googlemail.com,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <f43fc5581002201359x50aff2b1ofc4f816762bda597@mail.gmail.com> <20100221.155719.226789440.davem@davemloft.net> <201002220128.21067.bzolnier@gmail.com>
In-Reply-To: <201002220128.21067.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002212003.37054.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 February 2010 18:28:20 Bartlomiej Zolnierkiewicz wrote:
> On Monday 22 February 2010 12:57:19 am David Miller wrote:
> > From: Rob Landley <rob@landley.net>
> > Date: Sun, 21 Feb 2010 10:25:09 -0600
> >
> > > 085219f79cad89291699bd2bfb21c9fdabafe65f is first bad commit
> > > commit 085219f79cad89291699bd2bfb21c9fdabafe65f
> > > Author: Sam Ravnborg <sam@ravnborg.org>
> > > Date:   Fri Jan 2 18:47:34 2009 -0800
> > >
> > >     sparc32: use proper types in struct stat
> > >
> > >     Like sparc64 use proper types in struct stat
> > >
> > >     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > >
> > > This commit breaks stat and makes sparc32 essentially unusable.  It
> > > changes the size of the various types in stat.h, and means that if you
> > > "mount -t tmpfs /tmp /tmp" and then try to ls /tmp, ls dies with a
> > > memory allocation error.
> > >
> > > I've confirmed that reverting it fixes the problem.
> >
> > Thanks for tracking this down Rob, I'll work on a fix and
> > push it around.
>
> Looking at how whole sparc32 has been apparently broken for over a year now
> because of a purely cleanup patch I wonder if it would be appropriate to
> make sparc32 into 'legacy only' and provide 'a stability promise' for it?
>
> Just an idea.. ;)

Actually, the problem is that lots of people seem to expect current kernels to 
be broken on non-x86 targets, so they keep using old versions.  (In the case 
of the debian release everybody kept pointing me to on "but it works fine!" 
grounds, a 2.6.18 kernel.)  Lots of them only upgrade once idiots like me have 
gone across the minefield and made it safe. :)

"Current is always broken so nobody uses current" != "nobody uses this 
platform".  More "sparc people use distros rather than building their own 
systems from source, and tend not to be aggressive about upgrading".

Back in 2007 arm was broken for me for two or three releases (according to my 
blog it broke in 2.6.20 and the patch that fixed it ( 
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4454/1 ) was 
not yet in 2.6.22-rc7.  That doesn't mean arm isn't widely used, just that 
nobody with that hardware was seriously trying to use the current version of 
the kernel.

My Firmware LInux project is working on implementing automated regression 
testing under QEMU.  Once I've got a platform working (which sparc wasn't 
until now) I can provide much more prompt breakage reports in future, at least 
for the basic stuff like this...

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
