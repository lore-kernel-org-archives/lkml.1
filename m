Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXKGOj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXKGOj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbXKGOjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:39:10 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:46206 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808AbXKGOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:39:09 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: silence warning for 64KB PAGE_SIZE builds
References: <20071107051540.GB24266@lixom.net>
Date: Wed, 07 Nov 2007 23:39:01 +0900
In-Reply-To: <20071107051540.GB24266@lixom.net> (Olof Johansson's message of
	"Tue, 6 Nov 2007 23:15:40 -0600")
Message-ID: <87prymqfwa.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson <olof@lixom.net> writes:

> logical_sector_size can never be more than 16 bits worth, but switching
> it to an int silences gcc. It's a sanity check that can never fail with
> 64KB PAGE_SIZE but it seems like it'd still be useful for other page
> sizes, so it's worth keeping:
>
>         if (!is_power_of_2(logical_sector_size)
>             || (logical_sector_size < 512)
>             || (PAGE_CACHE_SIZE < logical_sector_size)) {
>                 if (!silent)
>                         printk(KERN_ERR "FAT: bogus logical sector size %u\n",
>                                logical_sector_size);
>                 brelse(bh);
>                 goto out_invalid;
>         }

Please use 4096 instead of allowing it, at least for now.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
