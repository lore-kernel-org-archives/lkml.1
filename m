Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYFXEG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYFXEG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbYFXEF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:05:59 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:39671 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754703AbYFXEF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:05:57 -0400
Date: Tue, 24 Jun 2008 13:03:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh: export get_cpu_subtype
Message-ID: <20080624040329.GC22526@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080618003650.GO25911@cs181133002.pp.htv.fi> <20080617223340.GN25911@cs181133002.pp.htv.fi> <20080617223103.GL25911@cs181133002.pp.htv.fi> <20080617223057.GK25911@cs181133002.pp.htv.fi> <20080617223053.GJ25911@cs181133002.pp.htv.fi> <20080617223040.GI25911@cs181133002.pp.htv.fi> <20080617223023.GH25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618003650.GO25911@cs181133002.pp.htv.fi> <20080617223340.GN25911@cs181133002.pp.htv.fi> <20080617223103.GL25911@cs181133002.pp.htv.fi> <20080617223057.GK25911@cs181133002.pp.htv.fi> <20080617223053.GJ25911@cs181133002.pp.htv.fi> <20080617223040.GI25911@cs181133002.pp.htv.fi> <20080617223023.GH25911@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 01:30:24AM +0300, Adrian Bunk wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 1837 modules
> ERROR: "get_cpu_subtype" [arch/sh/oprofile/oprofile.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

On Wed, Jun 18, 2008 at 01:30:40AM +0300, Adrian Bunk wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 1837 modules
> ERROR: "board_pci_channels" [drivers/pcmcia/yenta_socket.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> I freely admit that it's a pathological configuration, but as long as 
> it is allowed it should build.
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

On Wed, Jun 18, 2008 at 01:30:53AM +0300, Adrian Bunk wrote:
> EXPORT_SYMBOL's in lib-y considered harmful:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 1837 modules
> ERROR: "__raw_readsl" [drivers/ssb/ssb.ko] undefined!
> ERROR: "__raw_writesl" [drivers/ssb/ssb.ko] undefined!
> ERROR: "__raw_writesl" [drivers/net/smc91x.ko] undefined!
> ERROR: "__raw_readsl" [drivers/net/smc91x.ko] undefined!
> ERROR: "__raw_writesl" [drivers/net/3c59x.ko] undefined!
> ERROR: "__raw_readsl" [drivers/net/3c59x.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

On Wed, Jun 18, 2008 at 01:30:57AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global aica_rtc_{get,set}timeofday() 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

On Wed, Jun 18, 2008 at 01:31:03AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global EARLY_PCI_OP's static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

On Wed, Jun 18, 2008 at 01:33:40AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global pcibios_max_latency static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

On Wed, Jun 18, 2008 at 03:36:50AM +0300, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make the following needlessly global code static:
>   - cf-enabler.c: cf_init()
>   - cpu/clock.c: __clk_enable()
>   - cpu/clock.c: __clk_disable()
>   - process_32.c: default_idle()
>   - time_32.c: struct clocksource_sh
>   - timers/timer-tmu.c: struct tmu_timer_ops
> - remove the following unused functions (no CONFIG_BLK_DEV_FD on sh):
>   - process_{32,64}.c: disable_hlt()
>   - process_{32,64}.c: enable_hlt()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

These are all applied, thanks.
