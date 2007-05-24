Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbXEXXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbXEXXN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXEXXNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:13:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:21129 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbXEXXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=A+ivCZX1XYOQCr2Agms4m4wMfy+8tD5LitkXruh6sO02Irs23kNsahKoYD0SeM+e5Gik2vSmZ+0EiztNLuyDm69n0rsVZyZ6BHbamGiVSYHjIQHkiXaLn1egFvu0bRnRXQ8L8Bt0nAHXpY7vQA/765RphlYHSDMd3jjdcrQuIc8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Remove a few UMSDOS leftovers
Date: Fri, 25 May 2007 01:15:04 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jacques Gelinas <jacques@solucorp.qc.ca>,
       Matija Nalis <mnalis@jagor.srce.hr>, Matija Nalis <mnalis@voyager.hr>,
       trivial@kernel.org
References: <200705250058.29266.jesper.juhl@gmail.com> <46561AA5.8090908@zytor.com>
In-Reply-To: <46561AA5.8090908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705250115.04491.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 01:07:17 H. Peter Anvin wrote:
> Jesper Juhl wrote:
> > The UMSDOS filesystem was removed back in 2.6.11, but some tiny bits 
> > stuck around. This patch removes the few leftovers.
> > The only things left behind after this are the entries in the CREDITS file.
> > 
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> > --- 
[snip]
> > --- a/Documentation/ioctl-number.txt
> > +++ b/Documentation/ioctl-number.txt
> > @@ -67,7 +67,6 @@ Code	Seq#	Include File		Comments
> >  0x00	00-1F	linux/wavefront.h	conflict!
> >  0x02	all	linux/fd.h
> >  0x03	all	linux/hdreg.h
> > -0x04	all	linux/umsdos_fs.h
> >  0x06	all	linux/lp.h
> >  0x09	all	linux/md.h
> >  0x12	all	linux/fs.h
> 
> NAK!
> 
> We should at least document which ioctl numbers have been burned, since
> they SHOULD NOT be reused.
> 
Ok, that makes sense. How about this version : 


The UMSDOS filesystem was removed back in 2.6.11, but some tiny bits 
stuck around. This patch removes the few leftovers.
The only things left behind after this are the entries in the CREDITS file 
and the ioctl number in Documentation/ioctl-number.txt as documentation.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
--- 

 Documentation/ioctl-number.txt |    2 +-
 arch/arm26/defconfig           |    1 -
 arch/cris/arch-v10/defconfig   |    1 -
 arch/um/config.release         |    1 -
 include/linux/ncp_fs.h         |    2 --
 5 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
index 3de7d37..4413866 100644
--- a/Documentation/ioctl-number.txt
+++ b/Documentation/ioctl-number.txt
@@ -67,7 +67,7 @@ Code	Seq#	Include File		Comments
 0x00	00-1F	linux/wavefront.h	conflict!
 0x02	all	linux/fd.h
 0x03	all	linux/hdreg.h
-0x04	all	linux/umsdos_fs.h
+0x04	all	linux/umsdos_fs.h	Dead, but don't reuse this ioctl number.
 0x06	all	linux/lp.h
 0x09	all	linux/md.h
 0x12	all	linux/fs.h
diff --git a/arch/arm26/defconfig b/arch/arm26/defconfig
index c4a8970..2b7d44b 100644
--- a/arch/arm26/defconfig
+++ b/arch/arm26/defconfig
@@ -248,7 +248,6 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_JBD_DEBUG is not set
 # CONFIG_FAT_FS is not set
 # CONFIG_MSDOS_FS is not set
-# CONFIG_UMSDOS_FS is not set
 # CONFIG_VFAT_FS is not set
 # CONFIG_EFS_FS is not set
 # CONFIG_JFFS_FS is not set
diff --git a/arch/cris/arch-v10/defconfig b/arch/cris/arch-v10/defconfig
index 2a3411e..710c20b 100644
--- a/arch/cris/arch-v10/defconfig
+++ b/arch/cris/arch-v10/defconfig
@@ -429,7 +429,6 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_BFS_FS is not set
 # CONFIG_FAT_FS is not set
 # CONFIG_MSDOS_FS is not set
-# CONFIG_UMSDOS_FS is not set
 # CONFIG_VFAT_FS is not set
 # CONFIG_EFS_FS is not set
 # CONFIG_JFFS_FS is not set
diff --git a/arch/um/config.release b/arch/um/config.release
index fc68bcb..aba42f8 100644
--- a/arch/um/config.release
+++ b/arch/um/config.release
@@ -200,7 +200,6 @@ CONFIG_JBD=y
 # CONFIG_JBD_DEBUG is not set
 CONFIG_FAT_FS=y
 CONFIG_MSDOS_FS=y
-CONFIG_UMSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_EFS_FS=m
 # CONFIG_JFFS_FS is not set
diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index 83e39eb..88766e4 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -148,8 +148,6 @@ struct ncp_nls_ioctl
 #include <linux/ncp_fs_i.h>
 #include <linux/ncp_fs_sb.h>
 
-/* undef because public define in umsdos_fs.h (ncp_fs.h isn't public) */
-#undef PRINTK
 /* define because it is easy to change PRINTK to {*}PRINTK */
 #define PRINTK(format, args...) printk(KERN_DEBUG format , ## args)
 

