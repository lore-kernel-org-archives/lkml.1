Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXDGB0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXDGB0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 21:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXDGB0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 21:26:47 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52943 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933573AbXDGB0q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 21:26:46 -0400
Message-Id: <1175909205.905.1183425104@webmail.messagingengine.com>
X-Sasl-Enc: +NuqmRSCoy2WquSLKKoDMa7aeE6c7/CMLINuh4mBgj4X 1175909205
From: johnrobertbanks@fastmail.fm
To: johnrobertbanks@fastmail.fm, "Ignatich" <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
Subject: Re: COMPILING AND CONFIGURING A NEW KERNEL.
In-Reply-To: <1175817921.18400.1183285196@webmail.messagingengine.com>
Date: Fri, 06 Apr 2007 18:26:45 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a reply to an email that I accidentally deleted.

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
# cp /boot/config-2.6.20 /usr/src/linux-2.6.20/.config

Look at the available kernel building options
# make help

Run oldconfig to update the original kernel config to a current config
# make oldconfig

Use menuconfig (or xconfig or gconfig) to make any further changes
# make menuconfig

YOU SHOULD compile all the drivers necessary to boot your system, into
the kernel (ie, such drivers should not be built as modules).

This way you will NOT need an initrd file.

Use rpm-pkg to create a Red Hat RPM kernel package.
# make rpm-pkg

Went built, the RPM package is put in
/usr/src/packages/RPMS/*your*architecture*

# cd /usr/src/packages/RPMS/x86_64

Install the package (you may have to un-install previous installs)
# rpm -i kernel-2.6.20-1.x86_64.rpm

Use deb-pkg to create a Debian .deb kernel package.
# make deb-pkg

Went built, the .deb package is put in /usr/src/
# cd /usr/src/

Install the package (you may have to un-install previous installs)
# dpkg --install linux-2.6.20_2.6.20_amd64.deb

If you were unable to determine which drivers you need (to boot), then
you will need an initrd file. To build it use the command
# mkinitrd -o /boot/initrd-2.6.20

IF YOU ARE CUSTOMIZING YOUR KERNEL, YOU SHOULD PUT IN THE EFFORT TO
BUILD A KERNEL THAT DOES NOT NEED AN INITRD FILE.

------------------------------------------------------

Now you need to configure your kernel. Using GRUB you need to change the
menu.lst file.

# emacs /boot/grub/menu.lst &

The grub entry that you boot with will look something like:

###Don't change this comment - YaST2 identifier: Original name: linux###
title SUSE LINUX 10.0
    root (hd0,2)
    kernel /boot/vmlinuz root=/dev/hda3 resume=/dev/hda5 vga=0x317
    video=vesafb:nomtrr splash=silent
    initrd /boot/initrd

Leave the old boot entry so you can boot it if things go wrong with the
new kernel.
Cut and paste a copy of it above the old one. Then adjust the copy for
the new kernel.

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


------------------------------------------------------


On Thu, 05 Apr 2007 17:05:21 -0700, johnrobertbanks@fastmail.fm said:
> Hi Ignatich,
> 
> After seeing the following benchmarks at 
> 
> http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
> http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm
> 
> The Reiser4 benchmarks are so good, I have decided to try the Reiser4
> filesystem.
> 
> .-------------------------.
> | FILESYSTEM | TIME |DISK |
> | TYPE       |(secs)|USAGE|
> .-------------------------.
> |REISER4 lzo | 1938 | 278 |
> |REISER4 gzip| 2295 | 213 |
> |REISER4     | 3462 | 692 |
> |EXT2        | 4092 | 816 |
> |JFS         | 4225 | 806 |
> |EXT4        | 4408 | 816 |
> |EXT3        | 4421 | 816 |
> |XFS         | 4625 | 779 |
> |REISER3     | 6178 | 793 |
> |FAT32       |12342 | 988 |
> |NTFS-3g     |10414 | 772 |
> .-------------------------.
> 
> Column one measures the time taken to complete the bonnie++ benchmarking
> test (run with the parameters bonnie++ -n128:128k:0)
> 
> Column two, Disk Usage: measures the amount of disk used to store 655MB
> of raw data (which was 3 different copies of the Linux kernel sources).
> 
> Anyway, I have patched the 2.6.20 kernel and have a partition formatted
> with Reiser4.
> 
> However, I am having trouble getting LILO or GRUB working (with
> Reiser4).
> 
> Could you guys who know all about this, help me, or point me to some
> help.
> 
> Thanks a lot, John.
> 
> 
> On Fri, 06 Apr 2007 02:42:35 +0400, "Ignatich" <ignatich@gmail.com>
> said:
> > While trying to find the cause of problems with reiser4 in recent 
> > kernels I came across this.
> > 
> > Incomplete write handling seem to be missing from reiser4_write_extent() 
> > thanks to reiser4-temp-fix.patch. Strangely, there is a patch by Edward 
> > Shishkin that should address that issue, but it is missing from -mm 
> > tree. Please check.
> > 
> >     Max
> > 
> -- 
>   
>   johnrobertbanks@fastmail.fm
> 
> -- 
> http://www.fastmail.fm - And now for something completely different…
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

