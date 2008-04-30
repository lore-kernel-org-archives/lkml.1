Return-Path: <linux-kernel-owner+w=401wt.eu-S1764994AbYD3TOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764994AbYD3TOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762546AbYD3TOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:14:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:43445 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764903AbYD3TOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=BY3xMDg+eMvoSDmNzege+s3+OwmIVJoeDqQ/KwifCPdFe06t0iRdmGLlwuq+ck2hlpBg4C3T6v3QYjAVb0hmA3cdYTgd4Cdt/e32FlU79FfYWdtRHcjffhR1gi3wquzQ5RsHn2rvT39/rQVTYllso3WTakmvf7dp9KQujRYOlE0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: IDE probe failure in 2.6.25-mm1
Date: Wed, 30 Apr 2008 21:30:44 +0200
User-Agent: KMail/1.9.9
Cc: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org
References: <200804302343.14949.balajirrao@gmail.com> <20080430112028.ae20df4a.akpm@linux-foundation.org>
In-Reply-To: <20080430112028.ae20df4a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804302130.44894.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008, Andrew Morton wrote:
> On Wed, 30 Apr 2008 23:43:14 +0530
> Balaji Rao <balajirrao@gmail.com> wrote:
> 
> > Hi Andrew,
> > 
> > IDE probe fails in 2.6.25-mm1 on qemu.
> > 
> > [    0.664164] Uniform Multi-Platform E-IDE driver
> > [    1.571508] ide0: DISABLED, NO IRQ
> > [    1.572380] ide0: failed to initialize IDE interface
> > 
> > This is the output with linux-2.6.git
> > 
> > [    1.567368] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > [    1.571430] hda: max request size: 512KiB
> > [    1.574302] hda: 10485760 sectors (5368 MB) w/256KiB Cache, CHS=10402/255/63
> > [    1.583896] hda: cache flushes supported
> > [    1.585053]  hda: hda1
> > 
> > This is apparently due to the invasive changes in hwif_t's io_ports member.
> > 
> 
> OK, thanks.
> 
> I _think_ Bart idenfitied a patch which caused this (or something like it)
> and dropped it?

Yep.

Two patches were dropped from IDE tree:

	ide-fix-hwif-s-initialization.patch
	ide-make-ide_hwifs-static.patch

there is also a hot-fix patch available: 

	http://article.gmane.org/gmane.linux.ide/30860

+ for qemu switching to using piix host driver (qemu emulates PIIX3) should
also workaround the issue since it seems to happen only with ide_generic.

Thanks,
Bart
