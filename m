Return-Path: <linux-kernel-owner+w=401wt.eu-S936452AbXHJPJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936452AbXHJPJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbXHJPJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:09:35 -0400
Received: from canuck.infradead.org ([209.217.80.40]:45870 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXHJPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:09:34 -0400
Subject: Re: [SCSI] aic94xx: new driver
From: David Woodhouse <dwmw2@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
In-Reply-To: <200609240400.k8O403OJ024220@hera.kernel.org>
References: <200609240400.k8O403OJ024220@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:09:22 +0800
Message-Id: <1186758562.7615.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2006-09-24 at 04:00 +0000, Linux Kernel Mailing List wrote:
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -429,4 +429,10 @@ #define SCSI_IOCTL_GET_BUS_NUMBER  0x5386
>  /* Used to obtain the PCI location of a device */
>  #define SCSI_IOCTL_GET_PCI             0x5387
>  
> +/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
> +static inline u32 scsi_to_u32(u8 *ptr)
> +{
> +       return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
> +}
> +
>  #endif /* _SCSI_SCSI_H */ 

Please explain why it's necessary to export this to userspace.

The files in /usr/include/scsi are actually shipped by glibc, and most
distributions use glibc's version instead of the one from the kernel --
so this additional userspace interface is automatically incompatible
with most people's installations.

It would perhaps make sense to stop glibc providing these files, and let
distributions use the version from the kernel -- but that's a separate
issue. And still doesn't seem to justify the addition of the above
function.

-- 
dwmw2

