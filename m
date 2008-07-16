Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYGPNb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYGPNb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbYGPNbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:31:19 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48434 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033AbYGPNbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:31:19 -0400
Date: Wed, 16 Jul 2008 16:31:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jkacur <jkacur@gmail.com>
Cc: akpm@linux-foundation.org, Jan Engelhardt <jengelh@medozas.de>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: Make the git URL match usage
Message-ID: <20080716133108.GC25557@cs181140183.pp.htv.fi>
References: <200807161500.08500.jkacur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807161500.08500.jkacur@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 03:00:08PM +0200, jkacur wrote:
> This time, in order to test that the URL was correct, I started a git clone
> (and broke it off of course) on EVERY SINGLE git URL listed in the
> MAINTAINERS file, even the ones that I didn't have to modify.

Thanks for doing this work!

> I believe that this patch is ready to be ACKed and applied, however
> I made some observations that I will follow up on: Here is a summary.

An alternative solution would be to drop the trees from MAINTAINERS and 
instead point to
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=blob;f=Next/Trees 
which is always kept up-to-date.

It does not completely match what's currently in MAINTAINERS, but as 
you've obsserved the information in MAINTAINERS is quite stale.

> 1. Why is the testing and release tree the same?
> HARDWARE MONITORING
> P:	Mark M. Hoffman
> M:	mhoffman@lightlink.com
> L:	lm-sensors@lm-sensors.org
> W:	http://www.lm-sensors.org/
> T:	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git testing
> T:	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release
> S:	Maintained

These are not different trees, "testing" and "release" are branches of 
this tree.

> 2. Required me to change powerpc.git to powerpc-4xx.git
> P:	Josh Boyer
> M:	jwboyer@linux.vnet.ibm.com
> P:	Matt Porter
> M:	mporter@kernel.crashing.org
> W:	http://www.penguinppc.org/
> L:	linuxppc-dev@ozlabs.org
> T:	git://git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc-4xx.git
> S:	Maintained

That's not the correct tree, please ask the powerpc maintainers.

> 3. This one seems to require password authentication to fetch, howcome?
> MIPS
> P:	Ralf Baechle
> M:	ralf@linux-mips.org
> W:	http://www.linux-mips.org/
> L:	linux-mips@linux-mips.org
> T:	git www.linux-mips.org:/pub/scm/linux.git
> S:	Supported

That's most likely git://git.linux-mips.org/pub/scm/linux

Please ask the maintainer.

> 4. The following 3 drivers are all maintained by the same person
> in the same git repository, but fail when I attempt git clone
> 
> ADM8211 WIRELESS DRIVER
> P:	Michael Wu
> M:	flamingice@sourmilk.net
> L:	linux-wireless@vger.kernel.org
> W:	http://linuxwireless.org/
> T:	git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
> S:	Maintained
>...
> The failure looks like this
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
> Initialized empty Git repository in /home/jkacur/git-trees/mac80211-drivers/.git/
> fatal: The remote end hung up unexpectedly
> fetch-pack from 'git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git' failed.
>...

http://git.kernel.org shows all available trees at git.kernel.org and 
their contents.

More interesting is that there is no recent contents, which makes 
listing the trees anyway pointless.

> Finally, more a curiosity than anything, the following 3 repositories do NOT end in .git
> but this does not seem to be a problem either.
> 
> grep git:// MAINTAINERS | grep -v "\.git"
> T:      git://git.qlogic.com/ipath-linux-2.6
> T:      git://opensource.wolfsonmicro.com/linux-2.6-asoc
> T:      git://opensource.wolfsonmicro.com/linux-2.6-touch
>...

With the default git-daemon configuration it doesn't matter whether or 
not you specify a .git postfix.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

