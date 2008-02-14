Return-Path: <linux-kernel-owner+w=401wt.eu-S934896AbYBNBEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934896AbYBNBEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761992AbYBNBEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:04:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32811
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758244AbYBNBEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:04:21 -0500
Date: Wed, 13 Feb 2008 17:04:52 -0800 (PST)
Message-Id: <20080213.170452.68851396.davem@davemloft.net>
To: tony.luck@intel.com
Cc: mingo@elte.hu, rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
From: David Miller <davem@davemloft.net>
In-Reply-To: <12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
References: <20080213125725.GC6344@elte.hu>
	<20080213.050340.64342037.davem@davemloft.net>
	<12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Tony Luck" <tony.luck@intel.com>
Date: Wed, 13 Feb 2008 16:59:30 -0800

> > It is legal to access per-cpu data as early as you like,
> > it just evaluates to the static copy in the per-cpu section
> > of the kernel image until the per-cpu areas are setup.
> 
> On ia64 per-cpu variables are mapped into the top 64K
> of the address space.  Accessing them before the
> resources to handle the access to that virtual address
> have been set up would cause problems.

That's right.  I thought you guys had something that would handle that
early on, but looking at how the trick works in the vmlinux.lds.S ia64
uses that isn't the case.

I guess we really can't do per-cpu accesses early on.

This is extremely fragile, we should find some way to formalize this
to make accidental early per-cpu references trap at build time or
similar.
