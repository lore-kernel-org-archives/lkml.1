Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXDZAPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXDZAPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXDZAPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:15:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbXDZAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:15:46 -0400
Date: Wed, 25 Apr 2007 17:15:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
Cc: <linux-pcmcia@lists.infradead.org>, "lkml" <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Message-Id: <20070425171533.22efa133.akpm@linux-foundation.org>
In-Reply-To: <D7810733513F4840B4EBAAFA64D9C6A4012D5C9F@stgw002a.ww002.siemens.net>
References: <44c9a2b88950e3848d2c4e457641eb9b@kernel.crashing.org>
	<D7810733513F4840B4EBAAFA64D9C6A4012D5C9F@stgw002a.ww002.siemens.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 11:27:09 +0200 "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com> wrote:

> Without the following patch, the kernel does not automatically detect
> 2GB CompactFlash cards from Transcend.
> 
> I'm not sure which correct values must be assigned to the 3th and 4th
> parameters (here: 0x709b1bf1, 0xf54a91c8). Anyway, the patch is working
> with these values. Tested on arch=mips.
> 

Thanks.  Your patch was wordwrapped and had tabs replaced by spaces, btw.

> 
> ===================================================================
> --- linux-2.6.20.7-orig/drivers/ide/legacy/ide-cs.c     2007-04-15
> 21:08:02.000000000 +0200
> +++ linux-2.6.20.7/drivers/ide/legacy/ide-cs.c  2007-04-25
> 10:53:53.000000000 +0200
> @@ -64,6 +64,7 @@
>  
>  #define INT_MODULE_PARM(n, v) static int n = v; module_param(n, int, 0)
>  
> +#define PCMCIA_DEBUG 1
>  #ifdef PCMCIA_DEBUG
>  INT_MODULE_PARM(pc_debug, PCMCIA_DEBUG);
>  #define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)

I removed the above change

> @@ -399,6 +400,7 @@
>         PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a,
> 0x3489e003),
>         PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
>         PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1,
> 0x2a54d4b1),
> +       PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1,
> 0xf54a91c8),
>         PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1,
> 0xf54a91c8),
>         PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
>         PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c,
> 0x212bb918),

I'm never sure whether it's Bart or Dominik who handles pcmcia-cs patches.
