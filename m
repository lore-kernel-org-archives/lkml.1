Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYBZL2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYBZL2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYBZL23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:28:29 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59499 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbYBZL22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:28:28 -0500
Date: Tue, 26 Feb 2008 12:28:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steve Brokenshire <sbrokenshire@xestia.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20080226112840.GA29465@uranus.ravnborg.org>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 09:42:09PM +0000, Steve Brokenshire wrote:
> Hi,
> 
> (I've sent this to the linux-kbuild and linux-kernel lists as this
> patch modifies the Makefile.modinst file. I also don't subscribe to the 
> linux-kbuild and linux-kernel mailing lists so can I have any replies
> CC'ed to me please)
> 
> This patch allows kernel modules to be compressed when 'make
> modules_install' is run after being copied to
> the /lib/module/<version>/<...> directory which is useful if you have
> module-init-tools installed with --enable-zlib. This patch adds an
> option (MODULE_COMPRESS) to the kernel configuration file (specifically
> init/Kconfig) so that the kernel modules will compressed if
> MODULE_COMPRESS is set.
> 
> When MODULE_COMPRESS is set the output of 'make modules_install' will
> go as the following:
> 
> INSTALL  drivers/fs/xfs/xfs.ko
> COMPRESS drivers/fs/xfs/xfs.ko
> INSTALL  drivers/fs/fat/fat.ko
> COMPRESS drivers/fs/fat/fat.ko
> ...
> 
> I've tested my patch on kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
> 2.6.19 and they compile, install and compress into the respective
> module directories without any errors.
> 
> I've also tested this with the uvcvideo (linux-uvc) kernel module (from
> the SVN branch and with kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
> 2.6.19) as that uses Kbuild properly when installing the module and
> after installing the uvcvideo the module is then compressed.
> Unfortunately, I couldn't find any other kernel modules which used the
> Kbuild system for installing their kernel modules. :(
> 
> I've included include/config/auto.conf in Makefile.modinst so that it
> can check if MODULE_COMPRESS is set when installing the kernel modules.

Should we mention this possibility in Documentation/kbuild/modules.txt also?

Otherwise from a quick scan it looks OK.
As module-init-tols are our userspae counterpart we should align the
functionality with that tool.
I assume this gives us a simple choice of compression method and naming.

	Sam
