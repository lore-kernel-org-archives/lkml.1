Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZFVOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZFVOdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZFVOcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:32:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48305 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757274AbZFVOcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:32:45 -0400
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sudeep K N <sudeepholla.maillist@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
In-Reply-To: <1245680789.15580.85.camel@pc1117.cambridge.arm.com>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
	 <20090619134446.GI24573@n2100.arm.linux.org.uk>
	 <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
	 <1245680789.15580.85.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 22 Jun 2009 15:32:38 +0100
Message-Id: <1245681158.15580.91.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 14:32:39.0802 (UTC) FILETIME=[4B93FDA0:01C9F346]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 15:26 +0100, Catalin Marinas wrote:
> On Mon, 2009-06-22 at 19:43 +0530, Sudeep K N wrote:
> > Thanks for the suggestion.
> > With the logs it is clear that crash is in the userspace.
> > I am getting one of the 2 logs(below) randomly.
> 
> This sounds familiar: SMP -> writealloc cache policy (could be forced by
> hardware) -> cache corruption in user space with ext2.
> 
> Does you driver use the DMA API? If not, does your eMMC driver flush the
> cache (in case you hit one of the long-standing problems with PIO
> drivers).
> 
> It's worth trying this hack:
> 
> http://article.gmane.org/gmane.linux.ports.arm.kernel/51556

To be more precise:

If your system is ARM11MPCore based and your driver uses DMA, try this
patch (in-software DMA cache maintenance operations broadcasting):

http://www.linux-arm.org/git?p=linux-2.6-stable.git;a=commitdiff_plain;h=95298b1792121e7068258de451caec7f3dda0e78

If your driver is a PIO one, try this patch (flush_dcache_page called in
the VFS layer):

http://www.linux-arm.org/git?p=linux-2.6-stable.git;a=commitdiff_plain;h=d763f5815aa21095141c3ba87011906a61505dad

-- 
Catalin

