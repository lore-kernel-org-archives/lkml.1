Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbXICXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbXICXlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 19:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXICXlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 19:41:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbXICXlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 19:41:07 -0400
Message-ID: <46DC9B8A.3060404@redhat.com>
Date: Mon, 03 Sep 2007 19:40:58 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: "James C. Georgas" <jgeorgas@georgas.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: HIMEM calculation
References: <1188857974.6090.19.camel@Tachyon.home>
In-Reply-To: <1188857974.6090.19.camel@Tachyon.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James C. Georgas wrote:
> I'm not sure I understand how the kernel calculates the amount of
> physical RAM it can map during the boot process.
> 
> I've quoted two blocks of kernel messages below, one for a kernel with
> NOHIGHMEM and another for a kernel with HIGHMEM4G.
> 
> If I do the math on the BIOS provided physical RAM map, there is less
> than 5MiB of the address space reserved. Since I only have 1GiB of
> physical RAM in the board, I figured that it would still be possible to
> physically map 1019MiB, even with the 3GiB/1GiB split between user space
> and kernel space that occurs with NOHIGHMEM.
> 
> However, What actually happens is that I'm 127MiB short of a full GiB.
> 
> What am I missing here? Why does that last 127MiB have to go in HIGHMEM?

That's the vmalloc address space.  You only get 896 MB in the NORMAL 
zone on i386, to leave room for vmalloc.  If you don't like it, go 64-bit.

	-- Chris
