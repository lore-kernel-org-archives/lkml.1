Return-Path: <linux-kernel-owner+w=401wt.eu-S936250AbXGQVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936250AbXGQVf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935930AbXGQVfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:35:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935889AbXGQVfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:35:30 -0400
Date: Tue, 17 Jul 2007 14:34:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: block/bsg.c
Message-Id: <20070717143434.48836fb8.akpm@linux-foundation.org>
In-Reply-To: <200707172252.25729.bzolnier@gmail.com>
References: <20070717065940.GZ5195@kernel.dk>
	<20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	<20070717101928.GK5195@kernel.dk>
	<200707172252.25729.bzolnier@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 22:52:25 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> ide-{disk,scsi,tape} don't support REQ_TYPE_BLOCK_PC requests et all
> (so attempts to use SG_IO, CDROM_SEND_PACKET and SCSI_IOCTL_SEND_COMMAND
> will result in requests being failed and error messages in the kernel logs).

In my case it results in a completely tits-up machine.  CPU stuck somewhere
spinning with local interrutps disabled.

If you see the log output I sent, I'm suspecting this might be because
this BSG brainfart has exposed underlying bugs in IDE or SCSI.

Note that I saw literally 20,000 lines of output in the bit which I snipped,
so something has gone pretty wild in the handling of these bogus commands.

