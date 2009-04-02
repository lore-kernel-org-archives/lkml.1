Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbZDBThP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbZDBThP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762313AbZDBTgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:36:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58010 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbZDBTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=D+lis/RhAQDNn6RavmHXCEKCjepYgR45phdqp22PuhStek/kTSK04/qm0z8y7qC8IE
         sN+yP4WOCIuYmDvk52txf3AuQ7HkEi1634y97Xb1nMcE/FmW7d/nPUhm7FiN6Ce+xcvL
         3HdiGZ8+CTR9gfiM0CQ63mEx0udKjZ4zI6XMc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] ide: Fix host drivers that need IRQF_SHARED
Date: Thu, 2 Apr 2009 20:45:49 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090401; KDE/4.2.1; i686; ; )
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0903312115050.29238@anakin>
In-Reply-To: <Pine.LNX.4.64.0903312115050.29238@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022045.54971.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Geert Uytterhoeven wrote:
> commit 255115fb35f80735c21a1cbe9809e9795a3af26e ("ide: allow host drivers to
> specify IRQ flags") added irq_flags fields to struct ide_port_info and struct
> ide_host.  Drivers can now set ide_port_info.irq_flags = IRQF_SHARED, while
> init_irq() passes ide_host.irq_flags to request_irq().
> 
> Unfortunately ide_host.irq_flags is never set, causing (on ARAnyM):
> 
> | Uniform Multi-Platform E-IDE driver
> | ide: Falcon IDE controller
> | Probing IDE interface ide0...
> | hda: Sarge m68k, ATA DISK drive
> | init_irq: sa = 0
> | ide0: disabled, unable to get IRQ 15
> | ide0: failed to initialize IDE interface
> | ide0: disabling port
> 
> Solve this by copying ide_port_info.irq_flags to ide_host.irq_flags in
> ide_host_alloc().
> 
> This bug probably affects the following IDE host drivers:
>   - buddha
>   - delkin_cb
>   - falconide
>   - gayle
>   - ide-cs
>   - macide
>   - q40ide
>   - scc_pata
>   - sgiioc4
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

applied
