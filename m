Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYKLP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYKLP2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYKLP2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:28:11 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:50533 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbYKLP2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:28:10 -0500
Date: Thu, 13 Nov 2008 00:28:14 +0900 (JST)
Message-Id: <20081113.002814.12191937.anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Matteo Croce <technoboy85@gmail.com>
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

Note: all parsers except for the ar7part return kmalloced memory.

The ar7part parser returns a pointer of static array.  While currently
there is no in-kernel user of this parser, there should not be cause
regression.

Anyway, I suppose ar7part parser also should return kmalloced memory,
as like as all other parsers.

---
Atsushi Nemoto
