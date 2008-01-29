Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbYA2NX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbYA2NX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbYA2NXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:23:09 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:56033 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbYA2NXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:23:07 -0500
Date: Tue, 29 Jan 2008 15:23:04 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Yoav Artzi <yoavar@checkpoint.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
Message-ID: <20080129132304.GD2537@mea-ext.zmailer.org>
References: <479F1866.4050007@checkpoint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F1866.4050007@checkpoint.com>
nFrom: Matti Aarnio <matti.aarnio@zmailer.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 02:13:26PM +0200, Yoav Artzi wrote:
> Hi,
>
>
> I have a 32-bit user land application which sends an IOCTL to a 64-bit 
> Kernel module. I have a few different cmd codes that I can send through the 
> IOCTL. For some reason I seem to always get the same IOCTL cmd from user 
> land, no matter what the ioctl() call is given. This cmd code that I get 
> has some bytes (W/R and the module code) that are OK, but the rest is just 
> garbage or zeros. This was originally a 32-bit system, and we are no 
> converting the Kernel module to 64-bit, so maybe there's something special 
> for 32-64 communication that miss.

In x86_64 kernel there is an adaptation layer that translates 32-bit ioctl:s
to kernel internal 64-bit ones, when absolutely necessary.

If you do not need to pass pointers in your ioctl(), then typedef:in passed
parameters with explicite size may save you from lots of trouble:

   struct cpioctl {
        long     var;   /* definite trouble 32-bit vs. 64-bit */
        uint32_t var2;  /* no troubles... */
        uint64_t var3;
   };

After that, the only issue is that 32-bit user space ioctl() passes
a pointer that is valid in 32-bit space only, bit that is handled by
the common layer without need to make specific adaptation routine.

.. however if the structure has pointer to elsewere in memory, then
things get complicated really fast.


> I am working on Linux Kernel v2.6.18.
> Thanks
