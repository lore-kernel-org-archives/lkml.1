Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZFVQre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZFVQre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbZFVQqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:46:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57282 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168AbZFVQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:46:19 -0400
Date: Mon, 22 Jun 2009 17:46:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
Message-ID: <20090622164604.GG29188@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com> <20090619134446.GI24573@n2100.arm.linux.org.uk> <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com> <20090622154308.GC29188@n2100.arm.linux.org.uk> <1245685846.15580.107.camel@pc1117.cambridge.arm.com> <20090622155659.GE29188@n2100.arm.linux.org.uk> <1245687196.15580.122.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245687196.15580.122.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 05:13:16PM +0100, Catalin Marinas wrote:
> Well, I get this kind of errors (with /sbin/init) every time I try ext2
> on CompactFlash (with pata_platform). You could try with USB as well on
> a RealView/EB+ARM11MPCore board.

Is USB now usable on the rev.B board I have?

> Could you or Sudeep clarify whether the driver uses DMA or PIO?

If I knew what this "eMMC" was...

> In my case (ext2 over pata_platform), there is no flush_dcache_page()
> call after the page was written with data from the CompactFlash (neither
> the driver nor the VFS layer do this and we used hardware tracing to
> double-check). When the page is mapped into user space,
> update_mmu_cache() is called but the page hasn't been marked as dirty
> and no D-cache flushing occurs. Calling flush_dcache_page() in
> mpage_end_io_read() works around this issue.

As already covered, there's no chance of adding such a call to the
generic kernel.  It's the responsibility of the drivers to ensure that
data they read in hits the underlying page - in the same way that DMA
does.
