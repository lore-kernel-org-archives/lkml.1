Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXHVG2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXHVG2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXHVG21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:28:27 -0400
Received: from gw.goop.org ([64.81.55.164]:50807 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXHVG2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:28:25 -0400
Message-ID: <46CBD78C.3020804@goop.org>
Date: Tue, 21 Aug 2007 23:28:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH] Fix lazy mode vmalloc synchronization for paravirt
References: <46CB91BC.2010808@vmware.com>
In-Reply-To: <46CB91BC.2010808@vmware.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Found this looping Ubuntu installs with VMI.
>
> If unlucky enough to hit a vmalloc sync fault during a lazy mode
> operation (from an IRQ handler for a module which was not yet
> populated in current page directory, or from inside copy_one_pte,
> which touches swap_map, and hit in an unused 4M region), the required
> PDE update would never get flushed, causing an infinite page fault loop.

Ah, good catch.

> This bug affects any paravirt-ops backend which uses lazy updates, I
> believe that makes it a bug in Xen, VMI and lguest.  It only happens
> on LOWMEM kernels. 

No, under Xen the kernel/hypervisor PMD is not shared between processes,
so this is still used when PAE is enabled.

    J
