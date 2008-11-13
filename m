Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYKMO23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYKMO23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYKMO2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:28:19 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:57463 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYKMO2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:28:18 -0500
Date: Thu, 13 Nov 2008 23:28:23 +0900 (JST)
Message-Id: <20081113.232823.125897716.anemo@mba.ocn.ne.jp>
To: vapier@gentoo.org
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20081113.224350.18312549.anemo@mba.ocn.ne.jp>
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
	<20081113.224350.18312549.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 22:43:50 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Wed, 12 Nov 2008 18:38:53 -0500, Mike Frysinger <vapier@gentoo.org> wrote:
> > Rather than having every map/mtd driver doing the same sequence of
> > registering partitions and/or devices, implement common parse_mtd().
> > 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >  drivers/mtd/mtdcore.c   |   37 +++++++++++++++++++++++++++++++++++++
> >  include/linux/mtd/mtd.h |    3 +++
> >  2 files changed, 40 insertions(+), 0 deletions(-)
> 
> I like this idea.

Some drivers call both add_mtd_device() and add_mtd_partitions().  The
mtd_device is used to access whole flash area (like /dev/hda).  How do
you think of these usage patterns?

maps/edb7312.c
maps/mbx860.c
maps/plat-ram.c
nand/cafe_nand.c
nand/diskonchip.c
nand/ndfc.c

Automatic fallback to mtd_device in parse_mtd() is convenient but
somewhat unflexible...

---
Atsushi Nemoto
