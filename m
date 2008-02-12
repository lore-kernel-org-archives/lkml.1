Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYBLXDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYBLXDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYBLXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:03:14 -0500
Received: from www.tglx.de ([62.245.132.106]:58515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYBLXDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:03:13 -0500
Date: Wed, 13 Feb 2008 00:02:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] CPA: Fix set_memory_x for ioremap v2
In-Reply-To: <20080212153.888987414@suse.de>
Message-ID: <alpine.LFD.1.00.0802122318090.12988@apollo.tec.linutronix.de>
References: <20080212153.888987414@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Andi Kleen wrote:
> There would be several possible ways to fix this:
> - Simply don't set the NX bit in the original ioremap and drop
> set_memory_x and add a ioremap_exec(). That would be my preferred solution, 
> but unfortunately has been dismissed before
> - Drop all __pas and always use the physical address derived 
> from the looked up PTE. This would need some significant restructuring
> and would only fix the first problem above, not the second.
> - Special case NX clear to change any aliases. I chose this one
> because it happens to fix both problems, so is both a fix
> and a optimization.
> 
> This implies that it's still not safe calling set_memory_(not x) on
> any ioremaped/vmalloced/module addresses. 

There is another option:

- Fix it proper.

The so-called "significant restructuring" took a mere 2 hours,
which is probably less than the time consumed in this thread.

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=shortlog;h=mm

Thanks,

	tglx
