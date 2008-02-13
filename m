Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbYBMRkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbYBMRkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbYBMRkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:40:41 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:56741 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbYBMRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:40:40 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bart Dopheide <dopheide@fmf.nl>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <mzolnier@gmail.com>
Subject: Re: Kernel BUG at fs/mpage.c:489
References: <20080212194546.GA2174@fmf.nl> <20080212215006.170ade88@core>
	<200802131205.45493.nickpiggin@yahoo.com.au>
	<20080213072627.GB2174@fmf.nl>
	<20080213010145.76ee9714.akpm@linux-foundation.org>
Date: Thu, 14 Feb 2008 02:40:20 +0900
In-Reply-To: <20080213010145.76ee9714.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 13 Feb 2008 01:01:45 -0800")
Message-ID: <87zlu492m3.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 13 Feb 2008 08:26:27 +0100 Bart Dopheide <dopheide@fmf.nl> wrote:
>
>> On Wed, Feb 13, 2008 at 12:05:45PM +1100, Nick Piggin wrote:
>> :)On Wednesday 13 February 2008 08:50, Alan Cox wrote:
>> :)> Almost certainly a hardware fail of some sort.
>> :)
>> :)Right, but the kernel shouldn't go bug...
>> 
>> Indeed, that's why I'm reporting.
>> 
>> 
>> :)I don't have a copy of your exact source code... which condition in
>> :)__mpage_writepage went BUG?
>> 
>> BUG_ON(buffer_locked(bh));
>> 
>> In a bit of context:
>> 482:    if (page_has_buffers(page)) {
>> 483:            struct buffer_head *head = page_buffers(page);
>> 484:            struct buffer_head *bh = head;
>> 485:
>> 486:            /* If they're all mapped and dirty, do it */
>> 487:            page_block = 0;
>> 488:            do {
>> 489:                    BUG_ON(buffer_locked(bh));
>> 490:                    if (!buffer_mapped(bh)) {
>> 491:                            /*
>> 492:                             * unmapped dirty buffers are created by
>> 493:                             * __set_page_dirty_buffers -> mmapped data
>> 494:                             */
>> 495:                            if (buffer_dirty(bh))
>> 496:                                    goto confused;
>> 497:                            if (first_unmapped == blocks_per_page)
>> 498:                                    first_unmapped = page_block;
>> 499:                            continue;
>> 500:                    }
>> 
>
> Probably means that either fat, IDE, block or fs/buffer.c failed to unlock a buffer_head
> when the IO error happened.  It's unlikely to be fat.

Yes. FAT does almost nothing on this path. Um...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
