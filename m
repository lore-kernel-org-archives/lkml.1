Return-Path: <linux-kernel-owner+w=401wt.eu-S1423530AbXD3ScF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423530AbXD3ScF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423570AbXD3ScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:32:04 -0400
Received: from holomorphy.com ([66.93.40.71]:59718 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423530AbXD3ScA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:32:00 -0400
Date: Mon, 30 Apr 2007 11:32:23 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] make stack size configurable (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430183223.GL19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174047.GD19966@holomorphy.com> <20070430182538.GE23336@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430182538.GE23336@stusta.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 08:25:38PM +0200, Adrian Bunk wrote:
> These are no questions a user should ever see, and it's impossible that 
> a user will be able to choose the right answer - that's an 
> implementation detail, and it has to be set correctly automatically 
> without bothering the user.
> Pro of bigger stacks:
> - kernel developers have to care less about stack usage
> Pros of smaller stacks:
> - less memory usage
> - higher order allocations are more likely to fail with fragmented
>   memory
> We are currently at "works with 8k stacks and without separate IRQ stacks"
> and at "works in most situations with 4k stacks", so nothing > 8k should 
> be required.

freitag mentioned that IRQ stacks should be bootmem allocated, so I
dredged up a series of debug patches I had that did so. This is in no
way intended as a suggestion we should e.g. merge config options as
in 1/6 for 64KB stacks.

This is all sort of meant to be cherrypicked mostly for 5/6's bootmem
allocation of IRQ stacks. Otherwise it's just a set of debug patches
I wrote. 1/6 is merely needed for 5/6 to eventually apply. 5/6 can't
really be used verbatim because it does various handling for vmalloc()
of stacks and depends on the patches in the series prior to it, but
it is something in the way of bootmem allocation of IRQ stacks being
out there already.


-- wli
