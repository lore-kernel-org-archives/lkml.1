Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZCFXUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZCFXUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZCFXTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:19:55 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46911 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZCFXTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:19:55 -0500
Date: Fri, 6 Mar 2009 23:19:50 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>
Subject: Re: Problems with AGPGART/drm and X11 2D-acceleration (i8xx)
Message-ID: <20090306231949.GB963@silver.sucs.org>
References: <Pine.LNX.4.44L0.0903061522001.2715-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903061522001.2715-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 03:33:16PM -0500, Alan Stern wrote:
> I've been experiencing problems running X with recent kernels.  
> Without 2D-acceleration everything seems to work okay, but scrolling is
> uncomfortably slow.  With acceleration enabled...
> 
> Under 2.6.28.7, X fails during startup and exits with an error message.  
> Dmesg says:
> 
> [   63.129319] [drm] Initialized drm 1.1.0 20060810
> [   63.196690] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   63.196704] pci 0000:00:02.0: setting latency timer to 64
> [   63.197679] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   63.457664] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
> [   63.457673] [drm:i915_gem_object_pin] *ERROR* Failure to bind: -12
> 
> Under 2.6.29-rc6, X hangs during startup.  I have to reboot the machine
> to recover.  Dmesg says only:
> 
> [   57.001997] [drm] Initialized drm 1.1.0 20060810
> [   57.121966] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   57.121980] pci 0000:00:02.0: setting latency timer to 64
> [   57.127739] [drm] Initialized i915 1.6.0 20080730 on minor 0
> 
> Relevant device info:
> 
> # lspci -v -s 0:2.0
> 00:02.0 VGA compatible controller: Intel Corporation 82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device (rev 03) (prog-if 00 [VGA controller])
>         Subsystem: Intel Corporation Device 5247
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at f0000000 (32-bit, prefetchable) [size=128M]
>         Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
>         Capabilities: [d0] Power Management version 1
>         Kernel modules: intelfb
> 
> I use XAA because the default EXA method causes X to hang during 
> startup even under 2.6.27.

There is a warning about XAA on other chipsets here:
http://marc.info/?l=linux-kernel&m=123536263005071&w=1 but I don't know
if that would apply in your case.

I notice gem messages in your logs... are you using a new enough Intel
Xorg driver? What version are you currently using (see
http://marc.info/?l=dri-devel&m=123578388323843&w=1 for details)? If
it's not new enough you will have to disable kernel mode setting (e.g.
via nomodesetting on the kernel command line).

Finally there is a warning about 8xx being notoriously problematic here:
http://marc.info/?l=linux-kernel&m=123585107823835&w=1 .

HTH.

-- 
Sitsofe | http://sucs.org/~sits/
