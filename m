Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZGMPs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZGMPs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbZGMPs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:48:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52554 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbZGMPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:48:55 -0400
Date: Mon, 13 Jul 2009 16:48:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dirk Behme <dirk.behme@googlemail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
Message-ID: <20090713154811.GA31979@n2100.arm.linux.org.uk>
References: <20090622164604.GG29188@n2100.arm.linux.org.uk> <1245767657.16488.38.camel@pc1117.cambridge.arm.com> <4A5B5640.2050308@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5B5640.2050308@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 05:44:00PM +0200, Dirk Behme wrote:
> Hi Catalin,
>
> Catalin Marinas wrote:
>> On Mon, 2009-06-22 at 17:46 +0100, Russell King - ARM Linux wrote:
>>> On Mon, Jun 22, 2009 at 05:13:16PM +0100, Catalin Marinas wrote:
>>>> In my case (ext2 over pata_platform), there is no flush_dcache_page()
>>>> call after the page was written with data from the CompactFlash (neither
>>>> the driver nor the VFS layer do this and we used hardware tracing to
>>>> double-check). When the page is mapped into user space,
>>>> update_mmu_cache() is called but the page hasn't been marked as dirty
>>>> and no D-cache flushing occurs. Calling flush_dcache_page() in
>>>> mpage_end_io_read() works around this issue.
>>> As already covered, there's no chance of adding such a call to the
>>> generic kernel.  It's the responsibility of the drivers to ensure that
>>> data they read in hits the underlying page - in the same way that DMA
>>> does.
>>
>> The patch below appears to solve the problem with CompactFlash using
>> pata_platform (I cc'ed linux-ide since the patch changes their code).
>> The patch only handles the read case but similarly it may need to handle
>> the write case if D-cache aliasing between user and kernel mappings
>> exists.
>>
>> For the USB mass storage, I haven't yet figured out the best place to
>> call flush_dcache_page().
>
> Any news regarding USB mass storage on ARM MPCore? Else this would mean 
> that USB mass storage (USB stick, USB disk) formatted with ext2/3/4 
> wouldn't work with MPCore?

USB normally uses DMA, so should be unaffected by this issue.
