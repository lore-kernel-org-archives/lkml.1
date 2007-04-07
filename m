Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXDGHpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXDGHpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 03:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXDGHpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 03:45:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43932 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965472AbXDGHpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 03:45:33 -0400
Message-Id: <1175931932.27274.1183445262@webmail.messagingengine.com>
X-Sasl-Enc: 85j3XppVWWs809BTbcxPQBa8/QRHLlJS3yr4hio2DywX 1175931932
From: johnrobertbanks@fastmail.fm
To: johnrobertbanks@fastmail.fm, "Ignatich" <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <1175909205.905.1183425104@webmail.messagingengine.com>
Subject: Re: COMPILING AND CONFIGURING A NEW KERNEL.
In-Reply-To: <1175909205.905.1183425104@webmail.messagingengine.com>
Date: Sat, 07 Apr 2007 00:45:32 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just correcting some errors and typos. 

Wouldn't want you to say that the linux kernel mailing list gave you
incorrect info.

COMPILING AND CONFIGURING A NEW KERNEL.

Download a recent kernel from http://www.kernel.org/
I will use the kernel linux-2.6.20.tar.bz2

You will have to change details of the following to suit your purposes.

Save it in /usr/src/
# mv linux-2.6.20.tar.bz2 /usr/src/

Unzip the kernel package
# tar -jxf linux-2.6.20.tar.bz2

Copy the original kernel configuration file (that came with your distro)
to .config
# cp /boot/config-2.6.13-15-default /usr/src/linux-2.6.20/.config

Change to the new kernel source directory
# cd /usr/src/linux-2.6.20/

Look at the available kernel building options
# make help

Run oldconfig to update the original kernel configuration to a current
configuration
# make oldconfig

Use menuconfig (or xconfig or gconfig) to make any further changes
# make menuconfig

YOU SHOULD compile all the drivers necessary to boot your system, into
the kernel (ie, such drivers should not be built as modules).

This way you will NOT need an initrd file.

Use rpm-pkg to create a Red Hat RPM kernel package.
# make rpm-pkg

When built, the RPM package is put in
/usr/src/packages/RPMS/*your*architecture*

# cd /usr/src/packages/RPMS/x86_64

Install the package (you may have to un-install previous installs)
# rpm -i kernel-2.6.20-1.x86_64.rpm

Use deb-pkg to create a Debian .deb kernel package.
# make deb-pkg

When built, the .deb package is put in /usr/src/
# cd /usr/src/

Install the package (you may have to un-install previous installs)
# dpkg --install linux-2.6.20_2.6.20_amd64.deb

If you were unable to determine which drivers you need (to boot), then
you will need an initrd file. To build it use the command
# mkinitrd -o /boot/initrd-2.6.20

IF YOU ARE CUSTOMIZING YOUR KERNEL, YOU SHOULD PUT IN THE EFFORT TO
BUILD A KERNEL THAT DOES NOT NEED AN INITRD FILE.

It is possible that deb-pkg and rpm-pkg take care of creating the initrd
automatically.

I have always compiled in the important drivers, so I do not know.

Does any caring person here know the answer to this question?

------------------------------------------------------

Now you need to configure your kernel. Using GRUB you need to change the
menu.lst file.

# emacs /boot/grub/menu.lst &

The grub entry that you presently boot with, will look something like:

###Don't change this comment - YaST2 identifier: Original name: linux###
title SUSE LINUX 10.0
    root (hd0,2)
    kernel /boot/vmlinuz-2.6.13-15-default root=/dev/hda3
    resume=/dev/hda5 vga=0x317 video=vesafb:nomtrr splash=silent
    initrd /boot/initrd

Do NOT delete the old boot entry, so you can boot it, if things go wrong
with the new kernel.

Cut a copy of it and paste it above the original. Then adjust the copy
for the new kernel.

###Don't change this comment - YaST2 identifier: Original name: linux###
title MY NEW KERNEL
    root (hd0,2)
    kernel /boot/linux-2.6.20 root=/dev/hda3 resume=/dev/hda5 vga=0x317
    video=vesafb:nomtrr splash=silent

Of course, you don't need a initrd entry as you have compiled in all the
vital drivers,... right?
If you could not determine the vital drivers and needed to build an
initrd file, then you need an entry, like

    initrd /boot/initrd-2.6.20

------------------------------------------------------

If your new kernel is destined to have the same name as the old one, you
need to do something about it (unless you do not mind the old one being
overwritten).

Use your favorite text editor to change the top level Makefile
# emacs /usr/src/linux-2.6.20/Makefile &

change the line 
EXTRAVERSION
to 
EXTRAVERSION = something

This will change the name of the new kernel to linux-2.6.20-something

Your /boot/grub/menu.lst entry will now look something like:

###Don't change this comment - YaST2 identifier: Original name: linux###
title MY NEW KERNEL
    root (hd0,2)
    kernel /boot/linux-2.6.20-something root=/dev/hda3 resume=/dev/hda5
    vga=0x317 video=vesafb:nomtrr splash=silent

and perhaps an entry

    initrd /boot/initrd-2.6.20-something

------------------------------------------------------

Now reboot and choose the "MY NEW KERNEL" entry from the GRUB boot menu,
and see how you went.

-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - Send your email first class

