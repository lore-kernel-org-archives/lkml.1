Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYD1EU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYD1EU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbYD1EUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:20:47 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:47345 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYD1EUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:20:46 -0400
Date: Mon, 28 Apr 2008 14:20:44 +1000
To: Christian Kujau <lists@nerdbynature.de>, Sam Ravnborg <sam@ravnborg.org>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: pmac_newworld undefined
Message-ID: <20080428042044.GX20457@bakeyournoodle.com>
References: <alpine.DEB.1.10.0804271951190.11017@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0804271951190.11017@sheep.housecafe.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 08:03:46PM +0200, Christian Kujau wrote:
> Hi,
> 
> the build failure reported[0] by Kamalesh back in 01/2008 is still 
> present in today's 2.6.25-git with CONFIG_NVRAM=m (instead of =y):
> 
>   Building modules, stage 2.
>   MODPOST 72 modules
> ERROR: "pmac_newworld" [arch/powerpc/platforms/powermac/nvram.ko] undefined!
> ERROR: "__alloc_bootmem" [arch/powerpc/platforms/powermac/nvram.ko] 
> undefined!
> make[1]: *** [__modpost] Error 1

Yeah that isn't really surprising.  Essentially
arch/powerpc/platforms/powermac/nvram.c must be builtin (not modular)
but CONFIG_NVRAM is tristate, and your .config has CONFIG_NVRAM=m.

We can probably "fix" this by adding another config config symbol and
"selecting" that from CONFIG_NVRAM.  Then using this new symbol in
arch/powerpc/platforms/powermac/*

so I think with we need is:
config NVRAM
  bool "..." if PPC32
  tristate "..." if !PPC32
  ...
  ...

Sam is there some way to achieve that or should we just create an
secondary symbol?

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

