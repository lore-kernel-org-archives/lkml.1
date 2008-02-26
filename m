Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbYBZKW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbYBZKW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYBZKWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:22:19 -0500
Received: from 1wt.eu ([62.212.114.60]:2144 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbYBZKWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:22:18 -0500
Date: Tue, 26 Feb 2008 11:22:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20080226102203.GA21257@1wt.eu>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080225222137.GY8953@1wt.eu> <20080226091455.GA3498@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080226091455.GA3498@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:14:55AM +0200, Adrian Bunk wrote:
> On Mon, Feb 25, 2008 at 11:21:38PM +0100, Willy Tarreau wrote:
> > On Mon, Feb 25, 2008 at 09:42:09PM +0000, Steve Brokenshire wrote:
> > > Hi,
> > > 
> > > (I've sent this to the linux-kbuild and linux-kernel lists as this
> > > patch modifies the Makefile.modinst file. I also don't subscribe to the 
> > > linux-kbuild and linux-kernel mailing lists so can I have any replies
> > > CC'ed to me please)
> > > 
> > > This patch allows kernel modules to be compressed when 'make
> > > modules_install' is run after being copied to
> > > the /lib/module/<version>/<...> directory which is useful if you have
> > > module-init-tools installed with --enable-zlib. This patch adds an
> > > option (MODULE_COMPRESS) to the kernel configuration file (specifically
> > > init/Kconfig) so that the kernel modules will compressed if
> > > MODULE_COMPRESS is set.
> > > 
> > > When MODULE_COMPRESS is set the output of 'make modules_install' will
> > > go as the following:
> > > 
> > > INSTALL  drivers/fs/xfs/xfs.ko
> > > COMPRESS drivers/fs/xfs/xfs.ko
> > > INSTALL  drivers/fs/fat/fat.ko
> > > COMPRESS drivers/fs/fat/fat.ko
> > > ...
> > > 
> > > I've tested my patch on kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
> > > 2.6.19 and they compile, install and compress into the respective
> > > module directories without any errors.
> > > 
> > > I've also tested this with the uvcvideo (linux-uvc) kernel module (from
> > > the SVN branch and with kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
> > > 2.6.19) as that uses Kbuild properly when installing the module and
> > > after installing the uvcvideo the module is then compressed.
> > > Unfortunately, I couldn't find any other kernel modules which used the
> > > Kbuild system for installing their kernel modules. :(
> > > 
> > > I've included include/config/auto.conf in Makefile.modinst so that it
> > > can check if MODULE_COMPRESS is set when installing the kernel modules.
> > > 
> > > Unfortunately when I ran mkinitrd (CentOS version) to create the initrd
> > > image to go with the kernel, I get errors saying that certain kernel
> > > modules don't exist despite the fact they do actually exist. When I
> > > pass --allow-missing to mkinitrd, it seems to go fine but when booting
> > > up with the system with the new initrd image I get error messages
> > > saying that the modules don't exist.
> > > 
> > > A workaround is to compile the modules, don't have MODULE_COMPRESS set 
> > > in .config, install the modules, run mkinitrd and copy it to /boot, set 
> > > MODULE_COMPRESS in .config and then install the modules again but
> > > compressed.
> > > 
> > > That's about it really. The only showstopper I feel is mkinitrd not
> > > working properly with the compressed kernel modules.
> > 
> > Have you tried keeping the module names intact (.ko, not .ko.gz) ?
> > It's what I was doing with modutils in 2.4 and what I'm still doing
> > with module-init-tools in 2.6. While I don't particularly use mkinitrd,
> > I think that keeping the name intact is preferable and should help.
> 
> How would you see if, and if yes with what program, a module was 
> compressed if the name is kept intact?

depmod/modinfo/insmod/modprobe already know it. And quite honnestly,
I don't know about any other program which really needs to process
those files once installed. Well, maybe ksymoops, but I'd have to
check, as I don't recall having ever been annoyed with this.

> I'd assume stuff like mkinitrd simply also needs to gain knowledge about 
> compressed modules.

I'm not that sure. At most it might want to uncompress them to gain some
space, but someone who uses compressed modules for later use in an initrd
is probably missing something.

Regards,
Willy

