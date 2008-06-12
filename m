Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYFLNDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYFLNDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYFLNDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:03:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbYFLNDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:03:07 -0400
Date: Thu, 12 Jun 2008 09:02:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 2/2] kexec jump -v11: save/restore device state
Message-ID: <20080612130225.GA9654@redhat.com>
References: <1213082106.22608.30.camel@caritas-dev.intel.com> <20080611163026.GG6450@redhat.com> <1213232019.21353.8.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213232019.21353.8.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 08:53:39AM +0800, Huang, Ying wrote:
> On Wed, 2008-06-11 at 12:30 -0400, Vivek Goyal wrote:
> [...]
> > > Usage example of simple hibernation:
> > > 
> > > 1. Compile and install patched kernel with following options selected:
> > > 
> > > CONFIG_X86_32=y
> > > CONFIG_RELOCATABLE=y
> > > CONFIG_KEXEC=y
> > > CONFIG_CRASH_DUMP=y
> > > CONFIG_PM=y
> > > 
> > > 2. Build an initramfs image contains kexec-tool and makedumpfile, or
> > >    download the pre-built initramfs image, called rootfs.gz in
> > >    following text.
> > > 
> > > 3. Prepare a partition to save memory image of original kernel, called
> > >    hibernating partition in following text.
> > > 
> > > 4. Boot kernel compiled in step 1 (kernel A).
> > > 
> > > 5. In the kernel A, load kernel compiled in step 1 (kernel B) with
> > >    /sbin/kexec. The shell command line can be as follow:
> > > 
> > >    /sbin/kexec --load-preserve-context /boot/bzImage --mem-min=0x100000
> > >      --mem-max=0xffffff --initrd=rootfs.gz
> > > 
> > > 6. Boot the kernel B with following shell command line:
> > > 
> > >    /sbin/kexec -e
> > > 
> > > 7. The kernel B will boot as normal kexec. In kernel B the memory
> > >    image of kernel A can be saved into hibernating partition as
> > >    follow:
> > > 
> > >    jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
> > >    echo $jump_back_entry > kexec_jump_back_entry
> > >    cp /proc/vmcore dump.elf
> > > 
> > >    Then you can shutdown the machine as normal.
> > > 
> > > 8. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
> > >    root file system.
> > > 
> > 
> > One of the concerns raised by hibernation people in the past was to use
> > single boot loader entry to boot normally as well while resuming a kernel.
> > 
> > So in this case a user either needs to maintain two boot-loader entries
> > or modify it on the fly. I wished there was a better way to handle that.
> 
> ﻿Now it is not needed to have two boot-loader entries, just one is
> enough. Step 4 and step 8 can share the same boot-loader entries. The
> rootfs.gz can be the normal initramfs or initrd when deployment. In
> rootfs.gz, if there is a valid hibernation image, the hibernated system
> will be restored, otherwise, normal boot process follows.
> 

Few things I don't understand.

- Are you saying that hibernated image will be saved in initrd
  (rootfs.gz)? But that saving is only in RAM, we never write back
  it to disk?

- I thought we probably have to dedicate a raw partition kind of thing
  for saving image and then modify boot loader command line to something
  similar to, "resume=partition". Then initrd can go hunting for image
  in respective partition (as specified by command line parameter) and if
  image is not available then continue with normal boot.

Thanks
Vivek
