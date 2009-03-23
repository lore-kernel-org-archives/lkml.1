Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZCWUxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZCWUxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZCWUxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:53:10 -0400
Received: from [213.79.90.228] ([213.79.90.228]:48198 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752074AbZCWUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:53:09 -0400
Date: Mon, 23 Mar 2009 23:53:05 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 04/57] microblaze_v7: Open firmware files
Message-ID: <20090323205305.GA10576@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <200903231951.23902.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903231951.23902.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 07:51:23PM +0100, Arnd Bergmann wrote:
> On Wednesday 18 March 2009, monstr@monstr.eu wrote:
> > From: Michal Simek <monstr@monstr.eu>
> > 
> > 
> > Signed-off-by: Michal Simek <monstr@monstr.eu>
> > ---
> >  arch/microblaze/include/asm/of_device.h   |   45 ++
> >  arch/microblaze/include/asm/of_platform.h |   64 ++
> >  arch/microblaze/include/asm/prom.h        |  313 ++++++++
> >  arch/microblaze/kernel/of_device.c        |  115 +++
> >  arch/microblaze/kernel/of_platform.c      |  201 +++++
> >  arch/microblaze/kernel/prom.c             | 1147 +++++++++++++++++++++++++++++
> >  arch/microblaze/kernel/prom_parse.c       | 1025 ++++++++++++++++++++++++++
> >  7 files changed, 2910 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/microblaze/include/asm/of_device.h
> >  create mode 100644 arch/microblaze/include/asm/of_platform.h
> >  create mode 100644 arch/microblaze/include/asm/prom.h
> >  create mode 100644 arch/microblaze/kernel/of_device.c
> >  create mode 100644 arch/microblaze/kernel/of_platform.c
> >  create mode 100644 arch/microblaze/kernel/prom.c
> >  create mode 100644 arch/microblaze/kernel/prom_parse.c
> 
> Since these files are derived from the powerpc versions, what is the
> plan on them? IIRC, you had them in a common directory in an earlier
> version. Are you planning to merge them at some point in the future
> or do you intend to maintain a fork?

Actually, it's trivial to factor out all the common code out of
arch/powerpc/ to drivers/of/.

It took me approx. 4 hours to factor out the code and make a
proof-of-concept FDT support for a little-endian ARM platform. ;-)
(The device tree was only describing a cpu and a nor flash, though.
No support for interrupt- and gpio-controllers. And no support for
U-Boot, I just built the dtb file into the kernel).

I never got around to clean it up and send though, but for sure,
there is absolutely no reason to duplicate the code across the
platforms.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
