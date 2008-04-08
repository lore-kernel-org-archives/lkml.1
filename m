Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYDHAaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYDHAaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 20:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYDHAaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 20:30:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYDHAaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 20:30:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: joern@logfs.org
Subject: Re: [patch 1/15] Makefiles and Kconfig
Date: Tue, 8 Apr 2008 02:30:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <20080401181308.512473173@logfs.org> <20080401181332.853833001@logfs.org>
In-Reply-To: <20080401181332.853833001@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080230.17426.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+67Po8TEZXCVzzHOloCUa/2XBbixPEXkB24zo
 3HdtbYj0DyKN/s13M8y2sE39JlXzRFUFdN/qMfbYGZaQXOZWF7
 0JKyGnltmSJ7ZU0MFDXlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008, joern@logfs.org wrote:
> --- linux-2.6.24logfs/fs/Kconfig~logfs	2008-03-24 12:39:10.190939342 +0100
> +++ linux-2.6.24logfs/fs/Kconfig	2008-04-01 19:48:18.517351063 +0200
> @@ -1385,6 +1385,23 @@ config JFFS2_CMODE_FAVOURLZO
>  
>  endchoice
>  
> +config LOGFS
> +	bool "Log Filesystem (EXPERIMENTAL)"

Is it really still the "Log Filesystem"? By now, I had the impression
that "logfs" is a name by itself, so it should be called the
"Logfs file system", and "config LOGFS_FS" respectively, like
JFFS2_FS, REISERFS_FS, AUTOFS_FS, UDF_FS etc.

> --- /dev/null	2008-03-30 12:15:48.586669308 +0200
> +++ linux-2.6.24logfs/fs/logfs/Makefile	2008-04-01 19:48:07.170961891 +0200
> @@ -0,0 +1,14 @@
> +obj-$(CONFIG_LOGFS)	+= logfs.o
> +
> +logfs-y	+= compr.o
> +logfs-y	+= dir.o
> +logfs-y	+= file.o
> +logfs-y	+= gc.o
> +logfs-y	+= inode.o
> +logfs-y	+= journal.o
> +logfs-y	+= memtree.o
> +logfs-y	+= readwrite.o
> +logfs-y	+= segment.o
> +logfs-y	+= super.o
> +logfs-$(CONFIG_BLOCK)	+= dev_bdev.o
> +logfs-$(CONFIG_MTD)	+= dev_mtd.o

You shouldn't add the Makefile and Kconfig before adding the actual
files, or you could cause git-bisect problems.

	Arnd <><
