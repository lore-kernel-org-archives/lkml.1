Return-Path: <linux-kernel-owner+w=401wt.eu-S1030339AbXDUKJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339AbXDUKJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 06:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXDUKJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 06:09:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933115AbXDUKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 06:09:52 -0400
Date: Sat, 21 Apr 2007 03:08:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       "Cameron, Steve" <Steve.Cameron@hp.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] utilities: add helper functions for safe 64-bit integer
 operations as 32-bit halves
Message-Id: <20070421030825.bed0b8a9.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.98.0704202040150.16687@sigma.j-a-k-j.com>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
	<1176995934.31764.7.camel@mulgrave.il.steeleye.com>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net>
	<1176999730.31764.15.camel@mulgrave.il.steeleye.com>
	<558F4D473FD7FE419B019232BF2D37B401167D74@G3W0634.americas.hpqcorp.net>
	<20070419222028.d33c7f86.akpm@linux-foundation.org>
	<1177074641.3718.5.camel@mulgrave.il.steeleye.com>
	<20070420114337.12a67141.akpm@linux-foundation.org>
	<1177095007.3718.43.camel@mulgrave.il.steeleye.com>
	<20070420123041.94aac1e1.akpm@linux-foundation.org>
	<1177100459.3718.45.camel@mulgrave.il.steeleye.com>
	<20070420141218.a0222472.akpm@linux-foundation.org>
	<alpine.DEB.0.98.0704201732240.11655@sigma.j-a-k-j.com>
	<alpine.DEB.0.98.0704202040150.16687@sigma.j-a-k-j.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 20:55:49 -0400 (EDT) "John Anthony Kazos Jr." <jakj@j-a-k-j.com> wrote:

> +#define upper_32_bits(n) (sizeof(n) == 8 ? (u64)(n) >> 32 : 0)

It's very unclear what type this returns, in terms of both size and
signedness.  Perhaps it always returns a u64, dunno.  If it does, that will
cause the arithmetic which uses this macro to go 64-bit too.  Casting the
whole return value to u32 would fix all those doubts up.

> +#define lower_32_bits(n) (sizeof(n) == 8 ? (u32)(n) : (n))

n&0xffffffff would be simpler.

Do we actually have any call for this?
