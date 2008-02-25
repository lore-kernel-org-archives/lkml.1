Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYBYRgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYBYRgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYBYRgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:36:35 -0500
Received: from lazybastard.de ([212.112.238.170]:53655 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYBYRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:36:35 -0500
Date: Mon, 25 Feb 2008 18:35:52 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Page scan keeps touching kernel text pages
Message-ID: <20080225173551.GA13911@lazybastard.org>
References: <20080224144710.GD31293@lazybastard.org> <20080225150724.GF2604@shadowen.org> <20080225151536.GA13358@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080225151536.GA13358@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 February 2008 16:15:36 +0100, Jörn Engel wrote:
> On Mon, 25 February 2008 15:07:24 +0000, Andy Whitcroft wrote:
> 
> > I would expect to find pages below the kernel text as real pages, and
> > potentially on the LRU on some architectures.  Which architecture are
> > you seeing this?  Which zones do the pages belong?
> 
> 32bit x86 (run in qemu, shouldn't make a difference).
> 
> Not sure about the zones.  Let me rerun to check that.

Example output:
scanning zone DMA
page      3fa        3 00000000 628
page      2bf        2 00000000 628
page       97        3 00000000 628
page       98        2 00000000 628
scanning zone DMA
page      2c0        3 00000000 628
page      2c3        2 00000000 628
page       44        3 00000000 628
page       46        2 00000000 628
scanning zone DMA
page       37        3 00000000 628
page       35        2 00000000 628
page       32        3 00000000 628
page       38        2 00000000 628

Looks like all kernel text is in zone DMA.  Second column holds the page
number, third is refcount, fourth is the flags, fifth is the line, which
corresponds to this one after my debugging changes:
		if (!mapping || !remove_mapping(mapping, page))
			goto keep_locked;

Jörn

-- 
Joern's library part 4:
http://www.paulgraham.com/spam.html
