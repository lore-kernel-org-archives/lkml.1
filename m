Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYKLPzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYKLPzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYKLPzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:55:31 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:53109 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYKLPza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:55:30 -0500
Date: Thu, 13 Nov 2008 00:55:34 +0900 (JST)
Message-Id: <20081113.005534.56563769.anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] physmap: Fix leak of memory returned by
 parse_mtd_partitions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
References: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 23:57:33 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> The mtd partition parser returns an allocated pointer array of
> mtd_partition.  The caller must free it.  The array is used only for
> add_mtd_partitions(), so free it just after the call.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
>  drivers/mtd/maps/physmap.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)

And many other callers of parse_mtd_partitions() also do not free the
returned memory.  With a quick look, 21 of 36 have same defect.

drivers/mtd/devices/m25p80.c
drivers/mtd/devices/mtd_dataflash.c
drivers/mtd/maps/bfin-async-flash.c
drivers/mtd/maps/edb7312.c
drivers/mtd/maps/impa7.c
drivers/mtd/maps/intel_vr_nor.c
drivers/mtd/maps/solutionengine.c
drivers/mtd/nand/atmel_nand.c
drivers/mtd/nand/cafe_nand.c
drivers/mtd/nand/cmx270_nand.c
drivers/mtd/nand/cs553x_nand.c
drivers/mtd/nand/edb7312.c
drivers/mtd/nand/fsl_elbc_nand.c
drivers/mtd/nand/fsl_upm.c
drivers/mtd/nand/mxc_nand.c
drivers/mtd/nand/orion_nand.c
drivers/mtd/nand/ppchameleonevb.c
drivers/mtd/nand/sharpsl.c
drivers/mtd/nand/tmio_nand.c
drivers/mtd/nand/ts7250.c
drivers/mtd/onenand/generic.c

Volunteers? ;)

---
Atsushi Nemoto
