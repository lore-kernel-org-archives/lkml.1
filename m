Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbYA2NGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbYA2NGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbYA2NFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:05:08 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20536 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763AbYA2NFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:05:04 -0500
Message-ID: <479F247D.8040401@msgid.tls.msk.ru>
Date: Tue, 29 Jan 2008 16:05:01 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Yoav Artzi <yoavar@checkpoint.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
References: <479F1866.4050007@checkpoint.com>
In-Reply-To: <479F1866.4050007@checkpoint.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoav Artzi wrote:
> Hi,
> 
> 
> I have a 32-bit user land application which sends an IOCTL to a 64-bit
> Kernel module. I have a few different cmd codes that I can send through
> the IOCTL. For some reason I seem to always get the same IOCTL cmd from
> user land, no matter what the ioctl() call is given. This cmd code that
> I get has some bytes (W/R and the module code) that are OK, but the rest
> is just garbage or zeros. This was originally a 32-bit system, and we
> are no converting the Kernel module to 64-bit, so maybe there's
> something special for 32-64 communication that miss.

Please see numerous examples in kernel source, in many files named
compat_ioctl.c.  If your ioctls uses structures with fields that
have different sizes in 32- and 64-bit worlds (most notable int,
various enums etc), there should be corresponding translation
layer as in those examples.  If it's your kernel code, that is.
(And try to avoid such types there, use u32 or u64 and the like
that explicitly specify size).

Another possible problem is different alignment of fields in
64- vs 32-bits worlds.

> I am working on Linux Kernel v2.6.18.

If the kernel side isn't your code, the chances are quite high
that this problem has long been fixed in more recent kernels.

/mjt
