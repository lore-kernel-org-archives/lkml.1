Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbXGXVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbXGXVbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXGXVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:31:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbXGXVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:31:11 -0400
Date: Tue, 24 Jul 2007 14:30:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070724143004.6325a511.akpm@linux-foundation.org>
In-Reply-To: <200707241612.56509.rgetz@blackfin.uclinux.org>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<200707241350.45086.rgetz@blackfin.uclinux.org>
	<20070724111215.8d91dc7c.akpm@linux-foundation.org>
	<200707241612.56509.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 16:12:56 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Tue 24 Jul 2007 14:12, Andrew Morton pondered:
> > Oh well, it sounds like we need the super-duper fast version.  Keep it
> > as simple as possible, please.
> 
> What about:
> 
> int log_buf_copy(void *dest, int idx, size_t n);
> 
> starting at index idx - copy n bytes to dest, return the number of bytes 
> copied (in case there are not n bytes in the log_buf yet).

Sounds sensible.  I'd make it return size_t and take a char* arg though.
Or just use `int' - size_t is a bit of a pain and this is all kernel-internal
anwyay.
