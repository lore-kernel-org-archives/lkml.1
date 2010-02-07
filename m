Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0BGSJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 13:09:52 -0500
Received: from 8bytes.org ([88.198.83.132]:58829 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab0BGSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 13:09:51 -0500
Date: Sun, 7 Feb 2010 19:09:49 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 - cpu_relax - why nop vs. pause?
Message-ID: <20100207180949.GA26388@8bytes.org>
References: <4B6EF853.9090704@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6EF853.9090704@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 12:28:51PM -0500, Michael Breuer wrote:
> I did search and noticed some old discussions. Looking at both Intel and  
> AMD documentation, it would seem that PAUSE is the preferred instruction  
> within a spin lock. Further, both Intel and AMD specifications state  
> that the instruction is backward compatible with older x86 processors.

Its not the primary reason, but the hardware virtualization extensions
of x86 processors support an intercept after a configured amount of
pause instructions were executed. This is used to detect spinning vcpus
where the lock-holder is scheduled out.

> For fun, I changed nop to pause on my core i7 920 (smt enabled) and I'm  
> seeing about a 5-10% performance improvement on 2.6.33 rc7. Perf top  
> shows time spent in spin_lock under load drops from an average of around  
> 35% to about 25%.

What benchmarks have you used for your measurements?

	Joerg

