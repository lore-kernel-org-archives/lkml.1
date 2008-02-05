Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbYBEAIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbYBEAIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYBEAIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:08:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:45278 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbYBEAIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:08:13 -0500
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <20080201210656.174030@gmx.net>
References: <20080201184254.174020@gmx.net>
	 <20080201191119.GI18688@csn.ul.ie> <20080201200518.174050@gmx.net>
	 <20080201202518.GJ18688@csn.ul.ie>  <20080201210656.174030@gmx.net>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 11:07:51 +1100
Message-Id: <1202170071.7079.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 22:06 +0100, Gerhard Pircher wrote:
> > Could you try booting with 16MB less memory using mem=?
> I started the kernel with 512MB RAM (mem=496) and 1.5GB (mem=1520).
> The
> kernel oopes in both cases with a "Unable to handle kernel paging
> request
> for data address 0xbffff000", followed by a "Oops: kernel access of
> bad
> area, sig 11" message. The end of the stack trace shows the
> start_here()
> function.
> I'm not a PowerPC expert, but if 0xbffff000 is a virtual address, then
> it would be in the user program address space, right? If it is a
> physical
> address, then it is somewhere in the unallocated PCI address space

Have you tried DEBUG_PAGEALLOC ? It might fault earlier which might give
us better informations. Also, a stactrace from the oops might be useful,
along with a copy of your device-tree.

Ben.


