Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbYFZIgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbYFZIgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYFZIgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:36:48 -0400
Received: from aun.it.uu.se ([130.238.12.36]:41962 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYFZIgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:36:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18531.20387.111875.576837@harpo.it.uu.se>
Date: Thu, 26 Jun 2008 10:13:23 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
In-Reply-To: <20080625224301.GE32344@redhat.com>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de>
	<1214423826-12628-2-git-send-email-bwalle@suse.de>
	<20080625224301.GE32344@redhat.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal writes:
 > On Wed, Jun 25, 2008 at 09:57:05PM +0200, Bernhard Walle wrote:
 > > This patch adds /sys/firmware/memmap interface that represents the BIOS
 > > (or Firmware) provided memory map. The tree looks like:
 > > 
 > >     /sys/firmware/memmap/0/start   (hex number)
 > >                            end     (hex number)
 > >                            type    (string)
 > >     ...                 /1/start
 > >                            end
 > >                            type
 > > 
 > > With the following shell snippet one can print the memory map in the same form
 > > the kernel prints itself when booting on x86 (the E820 map).
 > > 
 > >   --------- 8< --------------------------
 > >     #!/bin/sh
 > >     cd /sys/firmware/memmap
 > >     for dir in * ; do
 > >         start=$(cat $dir/start)
 > >         end=$(cat $dir/end)
 > >         type=$(cat $dir/type)
 > >         printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type"
 > >     done
 > >   --------- >8 --------------------------
 > > 
 > > That patch only provides the needed interface:
 > > 
 > >  1. The sysfs interface.
 > >  2. The structure and enumeration definition.
 > >  3. The function firmware_map_add() and firmware_map_add_early()
 > >     that should be called from architecture code (E820/EFI, for
 > >     example) to add the contents to the interface.
 > > 
 > > If the kernel is compiled without CONFIG_FIRMWARE_MEMMAP, the interface does
 > > nothing without cluttering the architecture-specific code with #ifdef's.
 > > 
 > 
 > Hi Bernhard,
 > 
 > Thanks for the patch. Couple of thoughts.
 > 
 > Do we really need another CONFIG option (CONFIG_FIRMWARE_MEMMAP)? To,
 > me this does not seem to be a big chunk of code

It should be configurable. Whether it's done via CONFIG_KEXEC or its own
option I don't care.

 > at the same time I am
 > assuming that most of the people will use it (because of kexec). So
 > probably, it might not make lot of sense to put additional CONFIG option.

I question that assumption. Even if (and that's a big if) "most"
people use kexec (I don't), Linux is not about forcing unwanted
stuff down peoples' throats, we allow knowledgeable users to tune
their kernels.
