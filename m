Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXFED71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXFED71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760367AbXFED7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:59:19 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2723 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759902AbXFED7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:59:18 -0400
Date: Tue, 5 Jun 2007 04:59:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Martin Peschke <mp3@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1: __attribute__((weak)) considered harmful
Message-ID: <20070605035903.GD9045@flint.arm.linux.org.uk>
Mail-Followup-To: Martin Peschke <mp3@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070602171425.GG5500@stusta.de> <20070604142212.c0b68d6a.akpm@linux-foundation.org> <4664A5C6.7020004@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4664A5C6.7020004@de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 01:52:38AM +0200, Martin Peschke wrote:
> Andrew Morton wrote:
> >On Sat, 2 Jun 2007 19:14:25 +0200
> >Adrian Bunk <bunk@stusta.de> wrote:
> >
> >>statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch 
> >>shows why __attribute__((weak)) is harmful because you don't see if a 
> >>required non-weak implemtation is missing:
> >>
> >>In this case, the weak printk_clock() was renamed to timestamp_clock(), 
> >>but the ARM and i386 implementations weren't renamed...
> >>
> >
> >printk_clock() is sched_clock() in disguise, and I'm not sure that making
> >sched_clock() more widely available in this fashion is something that we
> >want to do anyway.

Note that sched_clock() can not be used early on ARM; it might want to
access MMIO which is not accessible until later in setup_arch().  This
is why ARM's printk_clock() divorces itself from sched_clock().

> As to timestamp_clock(): its useful for statistics, but still a minor 
> feature. It would be unfortuante if that was the stumbling block for my 
> patches. Am I right that the fix for the issue pointed at by Adrian is to 
> rename those two occurrences of printk_clock()? Do you want me to submit a 
> patch?

If it's ends up being based upon sched_clock() instead of printk_clock()
on ARM then it'll break stuff horribly (== non-bootable kernels.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
