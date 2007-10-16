Return-Path: <linux-kernel-owner+w=401wt.eu-S965929AbXJPVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965929AbXJPVAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765124AbXJPVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:00:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:22440 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760787AbXJPVAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:00:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cgc125qCitXq0qaOAnIn8+oqQUNd6amJIb9Y2/1M0dRldZvHedHvT+/9NPYNiutyJ0WhAM9wHCqoJP3+YsWxwEKsl/V4fm/2GYMF+Kvcf9WIngjcKMh0QbVeI5h9euRMZytlrzL4FWDO1DaSdCMW/C0addTDDe7j0EwpmR068WY=
Message-ID: <2ea3fae10710161400s1c558845y8e398c9a18f98dfb@mail.gmail.com>
Date: Tue, 16 Oct 2007 14:00:00 -0700
From: yhlu <yinghailu@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: kexec: Cannot determine the file type of arch/x86/boot/bzImage
Cc: "Thomas Meyer" <thomas@m3y3r.de>, kexec@lists.infradead.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071016130657.8cc17011.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47151631.9000307@m3y3r.de>
	 <20071016130657.8cc17011.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 16 Oct 2007 21:51:13 +0200 Thomas Meyer wrote:
>
> [adding kexec mailing list]
>
>
> > Hi.
> >
> > Look at this:
> >
> > $ file arch/x86/boot/bzImage (tree 821f3eff7cdb9d6c7076effabd46c96c322daed1)
> > arch/x86/boot/bzImage: Linux kernel x86 boot executable zImage, version
> > 2.6.23 (thomas@hotzenplotz) #39, RO-rootFS, root_dev 0x803, swap_dev
> > 0x1, Prompt for Videomode
> >
> > $ file /boot/bzImage-2.6.23
> > /boot/bzImage-2.6.23: Linux kernel x86 boot executable RO-rootFS,
> > root_dev 0x803, swap_dev 0x1, Normal VGA
> >
> > and this:
> >
> > # kexec -l arch/x86/boot/bzImage
> > Cannot determine the file type of arch/x86/boot/bzImage
> >
> > How to solve this error?

#!/bin/bash
KERNEL_VER=2.6.24_k8.2
CONSOLE=console=uart8250,io,0x3f8,9600n8

./kexec -t bzImage -l bzImage_"$KERNEL_VER" --command-line="apic=debug
acpi.debug_level=0x0000000F pci=routeirq nmi_watchdog=2
ramdisk_size=65536 root=/dev/ram0 rw ip=dhcp $CONSOLE"
--ramdisk=mydisk8_x86_64.gz

YH
