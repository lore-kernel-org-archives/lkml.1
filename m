Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXFVI6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXFVI6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXFVI6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:58:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51771 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751708AbXFVI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:58:34 -0400
Date: Fri, 22 Jun 2007 10:02:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] schedule BLK_DEV_IDE_SATA for removal
Message-ID: <20070622100216.45abf2b3@the-village.bc.nu>
In-Reply-To: <20070621235211.GH23017@stusta.de>
References: <20070621235211.GH23017@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 01:52:11 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> Users should use the libata based drivers for SATA drives.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.22-rc4-mm2/Documentation/feature-removal-schedule.txt.old	2007-06-21 23:41:03.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/Documentation/feature-removal-schedule.txt	2007-06-21 23:42:03.000000000 +0200
> @@ -347,3 +347,10 @@
>  Who:	Jean Delvare <khali@linux-fr.org>
>  
>  ---------------------------
> +
> +What:  CONFIG_BLK_DEV_IDE_SATA
> +When:  December 2007
> +Why:   users should use the libata based drivers for SATA
> +Who:   Adrian Bunk <bunk@stusta.de>
> +
> +---------------------------

NAK this for now

For the standard SATA controllers it is probably true now and will
definitely be true by December 2007 but there is lots of stuff out there
which uses SATA/PATA bridges on older PATA controllers such as the
VIA and HPT controllers. While support for them varies between rock solid
(VIA) and passable (HPT), I don't think its yet time to bump those people
towards libata forcibly at all.

About the only thing this would meaningfully obsolete would be
ide/pci/siimage.c for SI3112 and some PCI identifiers from ide/pci/piix.c.

