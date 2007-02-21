Return-Path: <linux-kernel-owner+w=401wt.eu-S1161313AbXBUP5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161313AbXBUP5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161312AbXBUP5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:57:32 -0500
Received: from mba.ocn.ne.jp ([210.190.142.172]:49535 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161316AbXBUP5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:57:31 -0500
Date: Thu, 22 Feb 2007 00:57:28 +0900 (JST)
Message-Id: <20070222.005728.126762028.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Subject: Detecting section mismatches in vmlinux
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Until 2.6.16 or so, we had reference_init.pl and
reference_discarded.pl to check section mismatches in vmlinux.

Are there any alternatives of this in recent kernel?

Now "modpost vmlinux" is executed during normal build, but it seems
the pass can not detect these mismatches.

For example:

$ ../build-i386/scripts/mod/modpost ../build-i386/mm/built-in.o
WARNING: ../build-i386/mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x18382) and '__kmem_cache_destroy'

set_up_list3s() in slab.c is not marked as __init and it references
initkmem_list3[] which is marked as __initdata.  So it is not false
positive.  But "modpost vmlinux" does not report it.

---
Atsushi Nemoto
