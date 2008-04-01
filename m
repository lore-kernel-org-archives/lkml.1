Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbYDAUKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbYDAUKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbYDAUJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:09:56 -0400
Received: from milhouse.binasys.co.uk ([216.12.200.91]:42246 "EHLO
	milhouse.binasys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbYDAUJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:09:56 -0400
X-Greylist: delayed 1219 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 16:09:55 EDT
Date: Tue, 1 Apr 2008 20:42:47 +0100
From: Steve Brokenshire <sbrokenshire@xestia.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-Id: <20080401204247.068aaa22.sbrokenshire@xestia.co.uk>
In-Reply-To: <20080226112840.GA29465@uranus.ravnborg.org>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
	<20080226112840.GA29465@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 12:28:40 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Feb 25, 2008 at 09:42:09PM +0000, Steve Brokenshire wrote:
> > Hi,
> > 
> > (I've sent this to the linux-kbuild and linux-kernel lists as this
> > patch modifies the Makefile.modinst file. I also don't subscribe to the 
> > linux-kbuild and linux-kernel mailing lists so can I have any replies
> > CC'ed to me please)
> > 
> > This patch allows kernel modules to be compressed when 'make
> > modules_install' is run after being copied to
> > the /lib/module/<version>/<...> directory which is useful if you have
> > module-init-tools installed with --enable-zlib. This patch adds an
> > option (MODULE_COMPRESS) to the kernel configuration file (specifically
> > init/Kconfig) so that the kernel modules will compressed if
> > MODULE_COMPRESS is set.
> > 
> > When MODULE_COMPRESS is set the output of 'make modules_install' will
> > go as the following:
> > 
> > INSTALL  drivers/fs/xfs/xfs.ko
> > COMPRESS drivers/fs/xfs/xfs.ko
> > INSTALL  drivers/fs/fat/fat.ko
> > COMPRESS drivers/fs/fat/fat.ko
> > ...
> > 
> > I've tested my patch on kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
> > 2.6.19 and they compile, install and compress into the respective
> > module directories without any errors.
> > 
> > I've also tested this with the uvcvideo (linux-uvc) kernel module (from
> > the SVN branch and with kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
> > 2.6.19) as that uses Kbuild properly when installing the module and
> > after installing the uvcvideo the module is then compressed.
> > Unfortunately, I couldn't find any other kernel modules which used the
> > Kbuild system for installing their kernel modules. :(
> > 
> > I've included include/config/auto.conf in Makefile.modinst so that it
> > can check if MODULE_COMPRESS is set when installing the kernel modules.
> 
> Should we mention this possibility in Documentation/kbuild/modules.txt also?
> 
> Otherwise from a quick scan it looks OK.
> As module-init-tols are our userspae counterpart we should align the
> functionality with that tool.
> I assume this gives us a simple choice of compression method and naming.
> 
> 	Sam

(Sorry for my lazy replying...)

I think it should be mentioned in Documentation/kbuild/modules.txt at
Chapter 2.2. The following should be added to the modules_install
target part:

If MODULES_COMPRESS is set when the modules_install target is run then
the module is compressed after it has been copied to 
/lib/modules/<kernel-version>. Compressed modules require 
module-init-tools installed with --zlib-enabled.

Does that sound right?

Anyway, as it currently is with the patch, MODULE_COMPRESS isn't as scalable as it perhaps could be and I've been thinking I should try and make a better version of the patch which is scalable (So depending on how module-init-tools is updated in the future each option would also give which version of module-init-tools is required to use that compression method in the init/KConfig file)

Steve
