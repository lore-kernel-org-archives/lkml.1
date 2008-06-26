Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYFZIp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYFZIp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYFZIos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:44:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:55171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYFZIor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:44:47 -0400
Date: Thu, 26 Jun 2008 10:45:24 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Vivek Goyal <vgoyal@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080626104524.2d7ed1ab@halley.suse.de>
In-Reply-To: <18531.20387.111875.576837@harpo.it.uu.se>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de>
	<1214423826-12628-2-git-send-email-bwalle@suse.de>
	<20080625224301.GE32344@redhat.com>
	<18531.20387.111875.576837@harpo.it.uu.se>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mikael Pettersson [2008-06-26 10:13]:
>
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

Ok, changed:

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 1008737..73fcc59 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -28,7 +28,7 @@ config EDD_OFF
 
 config FIRMWARE_MEMMAP
     def_bool y
-    depends on X86_64 || X86_32
+    depends on (X86_64 || X86_32) && KEXEC
 
 config EFI_VARS
        tristate "EFI Variable Support via sysfs"

I will wait with resending the patch for other feedback.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
