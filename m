Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZIMJNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZIMJNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 05:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZIMJNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 05:13:42 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53431 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbZIMJNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 05:13:42 -0400
Date: Sun, 13 Sep 2009 11:13:37 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: recent bdi changes result in WARN_ON on luksClose / dm
Message-ID: <20090913091337.GA21969@Chamillionaire.breakpoint.cc>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
 <20090912195212.GF14984@kernel.dk>
 <20090912195839.GG14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090912195839.GG14984@kernel.dk>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe | 2009-09-12 21:58:40 [+0200]:

>Don't count this as a real fix, I'll investigate closer on monday. Does
>the warning go away with this hack? It'll ensure that pending dirty
>inodes are flushed.

That warning goes away but another pops up:

|------------[ cut here ]------------
|WARNING: at /home/bigeasy/git/cryptodev-2.6/fs/fs-writeback.c:504 writeback_inodes_wb+0x2cc/0x49c()
|Modules linked in: sha256_generic cbc dm_crypt
|[<c0028dd8>] (unwind_backtrace+0x0/0xdc) from [<c003adb0>] (warn_slowpath_common+0x4c/0x80)
|[<c003adb0>] (warn_slowpath_common+0x4c/0x80) from [<c00b0998>] (writeback_inodes_wb+0x2cc/0x49c)
|[<c00b0998>] (writeback_inodes_wb+0x2cc/0x49c) from [<c00b0c98>] (wb_writeback+0x130/0x180)
|[<c00b0c98>] (wb_writeback+0x130/0x180) from [<c00b10f8>] (wb_do_writeback+0x7c/0x1d0)
|[<c00b10f8>] (wb_do_writeback+0x7c/0x1d0) from [<c00b1284>] (bdi_writeback_task+0x38/0xb0)
|[<c00b1284>] (bdi_writeback_task+0x38/0xb0) from [<c007f788>] (bdi_start_fn+0x74/0xe0)
|[<c007f788>] (bdi_start_fn+0x74/0xe0) from [<c004f2cc>] (kthread+0x7c/0x84)
|[<c004f2cc>] (kthread+0x7c/0x84) from [<c0024858>] (kernel_thread_exit+0x0/0x8)
|---[ end trace e1f395241bdb07ff ]---

Sebastian
