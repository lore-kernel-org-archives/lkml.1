Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYHUNKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYHUNKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYHUNK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:10:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbYHUNKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:10:25 -0400
Message-ID: <48AD692F.8030908@linux-foundation.org>
Date: Thu, 21 Aug 2008 08:10:07 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: holt@sgi.com, kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<48AC25E7.4090005@linux-foundation.org>	<20080821021332.GA23397@sgi.com> <20080820.200852.193706487.davem@davemloft.net>
In-Reply-To: <20080820.200852.193706487.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> Using SLAB/SLUB for the page table bits with appropriate constructor
> and destructor bits ought to be able to approximate the gains
> from avoiding the initialization for cached objects.

Its a bit strange to use the small object allocator for page sized
allocations. Plus there is this tie in with the tlb flushing logic. So I think
this would be more clean if it would be moved into the asm-generic/tlb.h or so.
