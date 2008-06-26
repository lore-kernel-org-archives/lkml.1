Return-Path: <linux-kernel-owner+w=401wt.eu-S1763882AbYFZNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763882AbYFZNCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760043AbYFZMnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:43:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759373AbYFZMnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:43:05 -0400
Date: Thu, 26 Jun 2008 08:42:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080626124204.GB3878@redhat.com>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de> <1214423826-12628-2-git-send-email-bwalle@suse.de> <20080625224301.GE32344@redhat.com> <18531.20387.111875.576837@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18531.20387.111875.576837@harpo.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:13:23AM +0200, Mikael Pettersson wrote:
> Vivek Goyal writes:
>  > On Wed, Jun 25, 2008 at 09:57:05PM +0200, Bernhard Walle wrote:
>  > > This patch adds /sys/firmware/memmap interface that represents the BIOS
>  > > (or Firmware) provided memory map. The tree looks like:
>  > > 
>  > >     /sys/firmware/memmap/0/start   (hex number)
>  > >                            end     (hex number)
>  > >                            type    (string)
>  > >     ...                 /1/start
>  > >                            end
>  > >                            type
>  > > 
>  > > With the following shell snippet one can print the memory map in the same form
>  > > the kernel prints itself when booting on x86 (the E820 map).
>  > > 
>  > >   --------- 8< --------------------------
>  > >     #!/bin/sh
>  > >     cd /sys/firmware/memmap
>  > >     for dir in * ; do
>  > >         start=$(cat $dir/start)
>  > >         end=$(cat $dir/end)
>  > >         type=$(cat $dir/type)
>  > >         printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type"
>  > >     done
>  > >   --------- >8 --------------------------
>  > > 
>  > > That patch only provides the needed interface:
>  > > 
>  > >  1. The sysfs interface.
>  > >  2. The structure and enumeration definition.
>  > >  3. The function firmware_map_add() and firmware_map_add_early()
>  > >     that should be called from architecture code (E820/EFI, for
>  > >     example) to add the contents to the interface.
>  > > 
>  > > If the kernel is compiled without CONFIG_FIRMWARE_MEMMAP, the interface does
>  > > nothing without cluttering the architecture-specific code with #ifdef's.
>  > > 
>  > 
>  > Hi Bernhard,
>  > 
>  > Thanks for the patch. Couple of thoughts.
>  > 
>  > Do we really need another CONFIG option (CONFIG_FIRMWARE_MEMMAP)? To,
>  > me this does not seem to be a big chunk of code
> 
> It should be configurable. Whether it's done via CONFIG_KEXEC or its own
> option I don't care.
> 

That's fine. I am just curious how does one decide whether a particular
functionality should have a separate CONFIG option or not.

I thought if a functionality is sufficiently big/significant (in terms of code
and in terms of memory allocation etc), then it is a good idea to put it
under a CONFIG option, in case people want to compile it out. 

Just that looking at the patch, personally, I don't think that it makes
lot of sense to create a separate CONFIG option for this patch. 

Thanks
Vivek
