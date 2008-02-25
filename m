Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYBYSyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYBYSyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbYBYSx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:53:58 -0500
Received: from lazybastard.de ([212.112.238.170]:60054 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYBYSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:53:58 -0500
Date: Mon, 25 Feb 2008 19:53:20 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Page scan keeps touching kernel text pages
Message-ID: <20080225185319.GA14699@lazybastard.org>
References: <20080224144710.GD31293@lazybastard.org> <20080225150724.GF2604@shadowen.org> <1203961702.6662.35.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1203961702.6662.35.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 February 2008 09:48:22 -0800, Dave Hansen wrote:
> On Mon, 2008-02-25 at 15:07 +0000, Andy Whitcroft wrote:
> > shrink_page_list() would be expected to be passed pages pulled from
> > the active or inactive lists via isolate_lru_pages()?  I would not have
> > expected to find the kernel text on the LRU and therefore not expect to
> > see it passed to shrink_page_list()?
> 
> It may have been kernel text at one time, but what about __init
> functions?  Don't we free that section back to the normal allocator
> after init time?  Those can end up on the LRU.

Pages below 0x2ba should be non-init in my test kernel:
c02ba000 T __init_begin
...
c02d5000 B __init_end

scanning zone DMA
page      3fa        3 00000000 628
page      2bf        2 00000000 628
page       97        3 00000000 628
page       98        2 00000000 628

So __init explains one page of this minimal sample, but not the other
three.

Jörn

-- 
Never argue with idiots - first they drag you down to their level,
then they beat you with experience.
-- unknown
