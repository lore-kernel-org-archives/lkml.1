Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbYCIM3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbYCIM3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYCIM3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:29:42 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54003 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbYCIM3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:29:34 -0400
Date: Sun, 9 Mar 2008 21:29:16 +0900
To: mjt@tls.msk.ru
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <47D3C8A1.6040409@msgid.tls.msk.ru>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080309212916T.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Mar 2008 14:23:13 +0300
Michael Tokarev <mjt@tls.msk.ru> wrote:

> Just got quite.. bad situation on a production server
> here.  The machine locked up hard several times in a
> row (required hard reboot).  So I finally enabled watchdog
> subsystem which helped.
> 
> Now I see the following (over netconsole):
> 
> DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:08:07.0
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!

Seems that you was out of swiommu space (and aic79xx can't handle it
though it should). This happened because:

a) you produced more I/Os than swiommu can handle.

b) swiommu space leaks due to bugs.

If you hit this problem due to a), the following boot option might
help:

swiotlb=65536

The same machine run well with old kernels? If so, probably, 2.6.24
has new bugs that lead to swiommu space leak.
