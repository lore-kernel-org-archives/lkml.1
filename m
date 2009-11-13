Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZKMPqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZKMPqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZKMPqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:46:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34270 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZKMPqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:46:33 -0500
Date: Fri, 13 Nov 2009 15:45:13 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Add support for LZO-compressed kernels
Message-ID: <20091113154513.GD27752@flint.arm.linux.org.uk>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com> <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 01:27:55PM +0100, Albin Tonnerre wrote:
> This is the first part of the lzo patch
> The lzo compressor is worse than gzip at compression, but faster at
> extraction. Here are some figures for an ARM board I'm working on:
> 
> Uncompressed size: 3.24Mo
> gzip  1.61Mo 0.72s
> lzo   1.75Mo 0.48s

>From my testing on a Cortex A9 model:
- lzo decompressor is 65% of the time gzip takes to decompress a kernel
- lzo kernel is 9% larger than a gzip kernel

which I'm happy to say confirms your figures when comparing the two.

However, when comparing your new gzip code to the old gzip code:
- new is 99% of the size of the old code
- new takes 42% of the time to decompress than the old code

What this means is that for a proper comparison, the results get even better:
- lzo is 7.5% larger than the old gzip'd kernel image
- lzo takes 28% of the time that the old gzip code took

So the expense seems definitely worth the effort.  The only reason I
can think of ever using gzip would be if you needed the additional
compression (eg, because you have limited flash to store the image.)

I would argue that the default for ARM should therefore be LZO.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
