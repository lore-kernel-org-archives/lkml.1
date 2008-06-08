Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYFHSgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYFHSgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYFHSgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:36:39 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40397 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYFHSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:36:38 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: caglar@pardus.org.tr
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       Onur =?iso-8859-1?Q?K=FC=E7=FCk?= <onur@pardus.org.tr>
Subject: Re: [PATCH] include/linux/msdos_fs.h: Cleanup include/linux/msdos_fs.h for userspace.
References: <200806082116.50355.caglar@pardus.org.tr>
Date: Mon, 09 Jun 2008 03:36:26 +0900
In-Reply-To: <200806082116.50355.caglar@pardus.org.tr>
 (=?iso-2022-jp-2?B?IlMuGyQoRCouGyhCYRskKEQrOxsoQmxhcg==?= Onur"'s
	message of "Sun, 8 Jun 2008 21:16:48 +0300")
Message-ID: <87wskzn591.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp-2
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"S.Çağlar Onur" <caglar@pardus.org.tr> writes:

> include/linux/msdos_fs.h header should use __u## rather than u## types else any userspace code (like syslinux) includes that header fails to compile like following;
>
> [...]
> gcc -Wp,-MT,bootsect_bin.o,-MMD,.bootsect_bin.o.d -W -Wall -D_FILE_OFFSET_BITS=64 -g -Os -I. -I.. -I../libinstaller -c -o bootsect_bin.o ../bootsect_bin.c
> gcc -Wp,-MT,ldlinux_bin.o,-MMD,.ldlinux_bin.o.d -W -Wall -D_FILE_OFFSET_BITS=64 -g -Os -I. -I.. -I../libinstaller -c -o ldlinux_bin.o ../ldlinux_bin.c
> In file included from syslinux.c:52:
> /usr/include/linux/msdos_fs.h:61: error: expected ')' before 'media'
> [...]
>
> Noticed by Onur Küçük <onur@pardus.org.tr>
>
> Cc: Frank Seidel <fseidel@suse.de>
> CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> CC: Onur Küçük <onur@pardus.org.tr>
>
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

Looks good to me. Thanks.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

>  include/linux/msdos_fs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
> index b03b274..3825b1c 100644
> --- a/include/linux/msdos_fs.h
> +++ b/include/linux/msdos_fs.h
> @@ -58,7 +58,7 @@
>  #define MSDOS_DOTDOT	"..         "	/* "..", padded to MSDOS_NAME chars */
>  
>  /* media of boot sector */
> -static inline int fat_valid_media(u8 media)
> +static inline int fat_valid_media(__u8 media)
>  {
>  	return 0xf8 <= media || media == 0xf0;
>  }
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
