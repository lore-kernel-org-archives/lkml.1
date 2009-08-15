Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZHONsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZHONsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZHONsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:48:46 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:59295 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZHONsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:48:45 -0400
Date: Sat, 15 Aug 2009 22:48:43 +0900 (JST)
Message-Id: <20090815.224843.240484147.anemo@mba.ocn.ne.jp>
To: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ata_tf_read_block() question
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question on CHS calculation in ata_tf_read_block().

The calculation in ata_tf_read_block() is:
	block = (cyl * dev->heads + head) * dev->sectors + sect;

but ata_build_rw_tf() does:
	track = (u32)block / dev->sectors;
	cyl   = track / dev->heads;
	head  = track % dev->heads;
	sect  = (u32)block % dev->sectors + 1;

It seems inconsistent.  The correct calculation is:
	block = (cyl * dev->heads + head) * dev->sectors + sect - 1;
isn't it?

I don't have any real problem.  Just noticed by code reading.
---
Atsushi Nemoto
