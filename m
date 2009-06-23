Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbZFWF63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbZFWF63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZFWF6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:58:21 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53658 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZFWF6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CiL2fVjCxyfg/x4ZAL8O02vRMMNlBaceAFT7k7i3V0N2HnLVm9Up6aSBvpqg1AMKS0
         ZRjz47cM0B91GJYypChYCgXSzOHF0M+Zk/Bzf0ASbOJLx62y78K3ZwDASph3qtYRH9T9
         3t05R/UahD0VEvUgZkLj8TbpIUWOTfN93o4sk=
MIME-Version: 1.0
In-Reply-To: <1245687196.15580.122.camel@pc1117.cambridge.arm.com>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
	 <20090619134446.GI24573@n2100.arm.linux.org.uk>
	 <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
	 <20090622154308.GC29188@n2100.arm.linux.org.uk>
	 <1245685846.15580.107.camel@pc1117.cambridge.arm.com>
	 <20090622155659.GE29188@n2100.arm.linux.org.uk>
	 <1245687196.15580.122.camel@pc1117.cambridge.arm.com>
Date: Tue, 23 Jun 2009 11:28:23 +0530
Message-ID: <366f00c80906222258l2c577b4eq7c97d0430f7f7104@mail.gmail.com>
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Sudeep K N <sudeepholla.maillist@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you or Sudeep clarify whether the driver uses DMA or PIO?
>
I have option to use both. I tried you patch(rather hack) for PIO mode i.e
(flush_dcache_page called in the VFS layer). This solves the crash in polling
mode. I need to work for proper way of flushing in the MMC driver.
I am yet to try with DMA as I am not much familiar with the DMA driver and
need some time.

> In my case (ext2 over pata_platform), there is no flush_dcache_page()
> call after the page was written with data from the CompactFlash (neither
> the driver nor the VFS layer do this and we used hardware tracing to
> double-check). When the page is mapped into user space,
> update_mmu_cache() is called but the page hasn't been marked as dirty
> and no D-cache flushing occurs. Calling flush_dcache_page() in
> mpage_end_io_read() works around this issue.

Looks like the crash I am getting is similar to one you are explaining with
your experience with CF cards.


Thanks to both Catalin and Russell for making such a informative discussion on
ARM SMP and related cache know hows.

-- 
Regards,
Sudeep
