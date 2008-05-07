Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbYEGPbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbYEGPbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbYEGPax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:30:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47026 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757846AbYEGPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:30:52 -0400
Date: Wed, 7 May 2008 16:21:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <JosephChan@via.com.tw>
Cc: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device
 Driver
Message-ID: <20080507162118.45ba52bb@core>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67759@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67759@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void delays(int count);
> +void i2cWriteSdaScl(u8 sda, u8 scl);
> +void i2cWriteScl(u8 scl);
> +void i2cReadSdaScl(u8 *pSda, u8 *pScl);

Style is good, code looks clean

One big thing that needs fixing here is the function names. If the driver
gets linked into the kernel then the symbols become global - and names
like enableGPIO are asking for clashes. The viafb code is fine as it uses
viafb_ as the function names. Possibly the helper functions should doo
something similar.

We also have a generic i2c layer that might be usable but that is
something that could be addressed in the future and isn't really an
important detail.

>
