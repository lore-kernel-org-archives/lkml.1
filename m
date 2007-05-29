Return-Path: <linux-kernel-owner+w=401wt.eu-S1764748AbXE2LUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764748AbXE2LUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbXE2LUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:20:06 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:16048 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645AbXE2LUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qZZsxH9qWmc4tZAgHkqCWlY1dzdwBt8DMgXoFPcotZ1FHyLBWpshnp6BTp1TyVywzJ00Nfq7ffJEWcXNz0HdrIe1OaTs20en5fYxsVBnhEen5663BYCTnmapm6gcp+0r6TeYHMwB/Rh/Sk2RyjdBW2qfwePhiBZRsSIrOb6Ef7Y=
Message-ID: <465BF244.5080200@gmail.com>
Date: Tue, 29 May 2007 11:28:36 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>	 <46599E6B.1000209@pobox.com>	 <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>	 <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org>	 <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>	 <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
In-Reply-To: <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Gregor.

Gregor Jasny wrote:
> [   18.639188] ata_piix 0000:00:07.1: version 2.11
> [   18.639718] scsi0 : ata_piix
> [   18.640189] scsi1 : ata_piix
> [   18.640541] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6
> bmdma 0x00010860 irq 14
> [   18.641148] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376
> bmdma 0x00010868 irq 15
> [    0.653333] Marking TSC unstable due to: possible TSC halt in C2.
> [    0.656666] Time: acpi_pm clocksource has been installed.
> [    0.656666] Switched to NOHz mode on CPU #0
> [    0.779999] ata1.00: ata_hpa_resize 1: sectors = 78242976,
> hpa_sectors = 78242976
> [    0.779999] ata1.00: ATA-7: SAMSUNG MP0402H, UC100-14, max UDMA/100
> [    0.796666] ata1.00: 78242976 sectors, multi 8: LBA48
> [    0.816666] ata1.00: ata_hpa_resize 1: sectors = 78242976,
> hpa_sectors = 78242976
> [    0.829999] ata1.00: configured for UDMA/33
> [    1.376666] Clocksource tsc unstable (delta = -496294688 ns)
> [   10.866665] ata2: SRST failed (errno=-16)
> [   20.899997] ata2: SRST failed (errno=-16)
> [   55.946661] ata2: SRST failed (errno=-16)
> [   60.966660] ata2: SRST failed (errno=-16)
> [   60.979993] ata2: reset failed, giving up

Aieee, so the drive doesn't like the new SRST sequence.  Indan pointed
me to your original posting and before the reset sequence update your
drive was reset successfully but only after 30sec delay, right?  If you
change the first entry in ata_eh_reset_timeouts[] table at the top of
libata-eh.c to 35 * HZ, does it work?

Thanks.

-- 
tejun

