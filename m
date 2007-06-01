Return-Path: <linux-kernel-owner+w=401wt.eu-S1762372AbXFATK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762372AbXFATK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXFATKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:10:19 -0400
Received: from outbound-mail-41.bluehost.com ([69.89.18.10]:60950 "HELO
	outbound-mail-41.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753306AbXFATKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:10:18 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Fri, 1 Jun 2007 12:10:15 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011210.15808.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> and the MTRRs (from /proc/mtrr, from private email):
>
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
> reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
> reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
> reg07: base=0x220000000 (8704MB), size= 128MB: write-back, count=1
>
> so the ranges mapped as cacheable are:
>
> 0-3319MB
> 4096-8832MB
>
> leaving 64MB of memory at the top of RAM uncached. What do you want to
> bet that something important (kernel code?) is getting loaded there..
>
> So essentially it's a BIOS problem, it's not setting up the MTRRs
> properly in order to map all of RAM as cacheable. As Andi says, complain
> to Intel.

If it's just 64M you'll end up losing, you could try the "[RFC] trim memory 
not covered by MTRR WB type" patch I posted yesterday.  It won't reinit the 
MTRRs (maybe we should) but it will at least prevent your system from 
crawling if the BIOS doesn't set them up right.  That would at least let you 
use most of your memory until the BIOS guys acknowledge that they have a 
problem (or we get proper PAT support, which I think would make this problem 
go away as well).

Jesse
