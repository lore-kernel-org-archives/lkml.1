Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0CHDG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 22:06:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36999 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0CHDGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 22:06:51 -0500
Date: Mon, 8 Mar 2010 04:06:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, Nick Piggin <npiggin@suse.de>,
       David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "haicheng.li" <haicheng.li@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
Message-ID: <20100308030650.GD20695@one.firstfloor.org>
References: <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box> <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com> <20100305062002.GV8653@laptop> <c1fb08351003050447w17175bbdy15e1e9bb78c2e40@mail.gmail.com> <alpine.DEB.2.00.1003050808390.32229@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003050808390.32229@router.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Under certain conditions this is possible. If the bad memory was modified
> then you have a condition that requires termination of all processes that
> are using the memory. If its the kernel then you need to reboot.
> 
> If the memory contains a page from disk then the memory can be moved
> elsewhere.
> 
> If you can clean up a whole range like that then its possible to replace
> the memory.

Typically that's not possible because of the way DIMMs are interleaved --
the to be freed areas would be very large, and with a specific size
there are always kernel or unmovable user areas areas in the way.

In general on Linux hot DIMM replacement only works if the underlying
platform does it transparently (e.g. support memory RAID and chipkill) 
and you have enough redundant memory for it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
