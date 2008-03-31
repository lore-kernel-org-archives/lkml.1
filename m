Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYCaSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYCaSfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYCaSfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:35:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38623 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYCaSfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:35:33 -0400
Date: Mon, 31 Mar 2008 11:34:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stefan Hellermann <stefan@the2masters.de>, linux-kernel@vger.kernel.org
Subject: Re: make O=dir fails with current git
Message-Id: <20080331113432.b9a153b9.randy.dunlap@oracle.com>
In-Reply-To: <20080331180022.GA4833@uranus.ravnborg.org>
References: <47EE8829.10409@the2masters.de>
	<20080331180022.GA4833@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 20:00:22 +0200 Sam Ravnborg wrote:

> On Sat, Mar 29, 2008 at 07:19:21PM +0100, Stefan Hellermann wrote:
> > Hi,
> > 
> > I'm using "make O=machinename" for building different kernels from one tree. About 15 days
> > ago it was okay, with current git it fails:
> > $ make O=client1
> > scripts/kconfig/conf -s arch/x86/Kconfig
> >   Using /srv/devel/kernel as source for kernel
> >   /srv/devel/kernel is not clean, please run 'make mrproper'
> >   in the '/srv/devel/kernel' directory.
> > make[1]: *** [prepare3] Error 1
> > make: *** [sub-make] Error 2
> > 
> > running "make mrproper" (without O=dir) doesn't help.
> > I've not changed anything, I only made a "git-pull".
> > Now I'm at home, tried "mkdir test; make O=test defconfig all" with current git-head, it
> > doesn't work too.
> 
> I tried to reproduce this here without luck.
> The tests performed by kbuild to dertermine if the
> source directory is clean are very basic.
> If the file .config exist or the directory
> include/config exists then the source tree is considered clean.
> Otherwise you get the above message.
> 
> Can you please try to run: make mrproper
> and then manually check if the .config file
> or the include/config directory exists.
> 
> If they exists after make mrproper then
> check your permissions.
> 
> In any case let me know the result.

I have no trouble reproducing it.

mkdir X64
make O=X64 ARCH=x86_64 defconfig all

and it prints:
make[2]: Nothing to be done for `/tester/linsrc/linux-2.6.25-rc7-git6/Makefile'.
make[1]: Nothing to be done for `all'.

before it does the defconfig part.

There is no $topdir/.config or $topdir/include/config.
Those do exist in the O=X64 directory, however.

---
~Randy
