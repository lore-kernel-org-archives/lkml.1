Return-Path: <linux-kernel-owner+w=401wt.eu-S933523AbXGWSAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbXGWSAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933371AbXGWSAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:00:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42367 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933359AbXGWSAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:00:05 -0400
Date: Mon, 23 Jul 2007 19:59:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Nelson, Shannon" <shannon.nelson@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: Gabriel C <nix.or.die@googlemail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: __unsafe() usage
Message-ID: <20070723175927.GM26212@stusta.de>
References: <46A3FE3E.20300@googlemail.com> <BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:05:54AM -0700, Nelson, Shannon wrote:
> Gabriel C [mailto:nix.or.die@googlemail.com] 
> >
> >Hi,
> >
> >I got this warning on current git using gcc 4.2.1 :
> >
> >...
> >
> >drivers/dma/ioatdma.c: In function 'ioat_init_module':
> >drivers/dma/ioatdma.c:816: warning: the address of 
> >'__this_module' will always evaluate as 'true'
>...

I'm less interested in why this gives a warning, more interesting is the 
code:
        __unsafe(THIS_MODULE);

@Rusty:
As far as I understand it, __unsafe() wasn't intended for such a usage, 
and simply not providing an exit function would be the right solution?
If this is true, and since the MOD_INC_USE_COUNT compat code is long 
gone, shouldn't we be able to completely remove __unsafe() and the 
struct member "unsafe"?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

