Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbYCAJjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbYCAJjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYCAJjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 04:39:10 -0500
Received: from mail.suse.de ([195.135.220.2]:39764 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbYCAJjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 04:39:08 -0500
Message-ID: <47C9241F.3080008@suse.de>
Date: Sat, 01 Mar 2008 10:38:39 +0100
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH] fs/partitions/msdos: directly check if FAT boot
 sector
References: <47C6A9C1.8000008@suse.de> <20080229170246.67391f7b.akpm@linux-foundation.org>
In-Reply-To: <20080229170246.67391f7b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> fs/partitions/msdos.c: In function 'msdos_partition':
> fs/partitions/msdos.c:446: warning: comparison is always true due to limited range of data type
> 
> didn't you get this?

Yes, sorry, but i saw it too late after posting.

> The reason is that FAT_VALID_MEDIA() is bogus:

yes, i stated this in our bug to the complaint
(https://bugzilla.novell.com/show_bug.cgi?id=364365#c15), but should have
also posted it here, sorry.

> #define FAT_VALID_MEDIA(x)      ((0xF8 <= (x) && (x) <= 0xFF) || (x) == 0xF0)
> 
> It appears that the on-disk field which FAT_VALID_MEDIA() is designed to
> test is only 8-bit, so the comparison with 0xff is pointless.  The only
> existing caller of FAT_VALID_MEDIA() cheats by copying the value into a
> local unsigned int first.
> 
> So I'll leave things as they are for now, but I'd ask that someone can
> confirm that we should simply remove the 0xff test from FAT_VALID_MEDIA()?

At least in my opinion it should be removed.

Thanks,
Frank
