Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZFVP5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZFVP5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZFVP5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:57:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41641 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZFVP5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:57:15 -0400
Date: Mon, 22 Jun 2009 16:56:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
Message-ID: <20090622155659.GE29188@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com> <20090619134446.GI24573@n2100.arm.linux.org.uk> <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com> <20090622154308.GC29188@n2100.arm.linux.org.uk> <1245685846.15580.107.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245685846.15580.107.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 04:50:46PM +0100, Catalin Marinas wrote:
> On Mon, 2009-06-22 at 16:43 +0100, Russell King - ARM Linux wrote:
> > On Mon, Jun 22, 2009 at 07:43:40PM +0530, Sudeep K N wrote:
> > > Thanks for the suggestion.
> > > With the logs it is clear that crash is in the userspace.
> > > I am getting one of the 2 logs(below) randomly.
> > > >From trial#2,
> > > pgd = c60bc000
> > > [00000000] *pgd=061ee031, *pte=00000000, *ppte=00000000
> > > I could understand that the page tables are not proper.
> > > I am not able understand how to proceed.
> > > 
> > > Trial#1:
> > > VFS: Mounted root (ext2 filesystem).
> > > Freeing init memory: 108K
> > > linuxrc (1): undefined instruction: pc=40008100
> > > Code: e08e3003 eb002842 e2801008 e58c217c (e0812103)
> > 
> > Your processor is misbehaving; none of the above hex codes are undefined
> > instructions, so you shouldn't be taking an undefined instruction trap.
> 
> The undefined instruction aborts are possible in this situation since
> instructions are fetched via the I-cache while the abort handler shows
> the code via the D-cache.

However, you're missing a very important point.

This early on, the I-cache for the non-kernel pages won't contain any
entries except those placed there by this first binary - it's the very
first user process which is receiving these exceptions.

Second point is that the page concerned has only recently been mapped
into that page.  I would be very very surprised if speculative
instruction prefetch managed to dirty the exact right page via the
kernel mapping to always cause the first process to fail in some way.
