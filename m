Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXEPS4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXEPS4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763351AbXEPSz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:55:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36466 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759214AbXEPSzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:55:55 -0400
Date: Wed, 16 May 2007 20:55:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: 2.6.22-rc1-mm1: IDE compile error
Message-ID: <20070516185552.GA4086@stusta.de>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:19:14PM -0700, Andrew Morton wrote:
>...
> - Added an i386 early-startup development tree, as git-newsetup.patch ("H. 
>   Peter Anvin" <hpa@zytor.com>)
>...
> Changes since 2.6.21-mm2:
>...
>  git-newsetup.patch
>...
>  git trees
>...

This breaks the compilation of the oldest of our IDE disk drivers:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `hd_init':
hd.c:(.init.text+0x44a7d): undefined reference to `drive_info'
hd.c:(.init.text+0x44a89): undefined reference to `drive_info'
hd.c:(.init.text+0x44a95): undefined reference to `drive_info'
hd.c:(.init.text+0x44aa1): undefined reference to `drive_info'
hd.c:(.init.text+0x44aad): undefined reference to `drive_info'
drivers/built-in.o:hd.c:(.init.text+0x44ab9): more undefined references to `drive_info' follow
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Considering the fact that we have two more recent drivers with the same 
functionality, it might be an option to simply remove this driver...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

