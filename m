Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbXLHUpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbXLHUpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbXLHUoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:44:46 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41192 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXLHUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:44:44 -0500
Date: Sat, 8 Dec 2007 20:44:26 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: davem@davemloft.net, wli@holomorphy.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: use of fixmap on non-x86/sh?
Message-ID: <20071208204426.GC3361@linux-mips.org>
References: <D16EA8BE-3C87-4345-8832-AB6112EE0FEA@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D16EA8BE-3C87-4345-8832-AB6112EE0FEA@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:14:55PM -0600, Kumar Gala wrote:

> Ben and I are talking about using fixmap on ppc for similar applications to 
> it use on x86.  However in poking around other arch's (sparc, mips) they 
> appear to have some support but not as complete as x86.
>
> For example both SPARC & MIPS reference __set_fixmap() in asm/fixmap.h but 
> I can't find an implementation on either.
>
> So I was wondering if there was some reason fixmap isn't as well supported 
> or if its just used for a specific function on those SPARC, MIPS, etc. and 
> they dont need as much functionality out of it as x86 does.

MIPS uses fixmap for two purposes:

 o In some cases it is possibly to avoid or optimize a cacheflush by creating
   a temporary mapping.  The mechanism works very similar to what x86 and
   MIPS use for atomic kmaps.
 o Highmem.

Both manipulate pagetables directly or even insert entries directly into
the TLB without pagetables as intermediate stage so __set_fixmap is indeed
unused.

  Ralf
