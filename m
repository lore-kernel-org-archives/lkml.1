Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZGMPuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZGMPuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZGMPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:50:21 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:51582 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbZGMPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:50:21 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 11:50:20 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Uzt7UZDaKUulLkFe6OY269hgnovvfDqWIA8lKiwQN5RcpMrABLe9e2552DroUdm9rk
         ko1LxBSrcNKq1XKM6AfMIC49txqhGQAbcgzAfd8Ufa6pUrqq5brm3u2xW6fbRvwHxodH
         JLHL3X5S/9hJ8nz/F3CObtXP3wTZZEY5GZdN0=
Message-ID: <4A5B5640.2050308@googlemail.com>
Date: Mon, 13 Jul 2009 17:44:00 +0200
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
References: <20090622164604.GG29188@n2100.arm.linux.org.uk> <1245767657.16488.38.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1245767657.16488.38.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Catalin Marinas wrote:
> On Mon, 2009-06-22 at 17:46 +0100, Russell King - ARM Linux wrote:
>> On Mon, Jun 22, 2009 at 05:13:16PM +0100, Catalin Marinas wrote:
>>> In my case (ext2 over pata_platform), there is no flush_dcache_page()
>>> call after the page was written with data from the CompactFlash (neither
>>> the driver nor the VFS layer do this and we used hardware tracing to
>>> double-check). When the page is mapped into user space,
>>> update_mmu_cache() is called but the page hasn't been marked as dirty
>>> and no D-cache flushing occurs. Calling flush_dcache_page() in
>>> mpage_end_io_read() works around this issue.
>> As already covered, there's no chance of adding such a call to the
>> generic kernel.  It's the responsibility of the drivers to ensure that
>> data they read in hits the underlying page - in the same way that DMA
>> does.
> 
> The patch below appears to solve the problem with CompactFlash using
> pata_platform (I cc'ed linux-ide since the patch changes their code).
> The patch only handles the read case but similarly it may need to handle
> the write case if D-cache aliasing between user and kernel mappings
> exists.
> 
> For the USB mass storage, I haven't yet figured out the best place to
> call flush_dcache_page().

Any news regarding USB mass storage on ARM MPCore? Else this would 
mean that USB mass storage (USB stick, USB disk) formatted with 
ext2/3/4 wouldn't work with MPCore?

Many thanks and best regards

Dirk
