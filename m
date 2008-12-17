Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757878AbYLQQv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYLQQv6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYLQQvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:51:48 -0500
Received: from sh.osrg.net ([192.16.179.4]:59690 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbYLQQvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:51:47 -0500
Date: Thu, 18 Dec 2008 01:51:14 +0900
To: jbeulich@novell.com
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
        ian.campbell@citrix.com, mingo@elte.hu, jeremy@goop.org,
        x86@kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0	
 useof swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4948CAC3.76E4.0078.0@novell.com>
References: <20081216203513.GA14787@elte.hu>
	<20081217142637V.fujita.tomonori@lab.ntt.co.jp>
	<4948CAC3.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081218014653A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 08:47:47 +0000
"Jan Beulich" <jbeulich@novell.com> wrote:

> >I think that the whole patchset is against the swiotlb design. swiotlb
> >is designed to be used as a library. Each architecture implements the
> >own swiotlb by using swiotlb library
> >(e.g. arch/x86/kernel/pci-swiotlb_64.c).
> 
> If it is a library, then it should be prepared to serve all possible users.

I don't against changing swiotlb library to make it usable for Xen.


> >For example, adding the following code (9/14) for just Xen that the
> >majority of swiotbl users (x86_64 and IA64) don't need to the library
> >is against the design.
> 
> "Don't" in terms of "currently don't": Once x86-64 wants to support more
> than 46 physical address bits, it's not impossible that this would lead to
> CONFIG_HIGHMEM getting introduced there, and then it'll be helpful that the
> code is already prepared to deal with that case.

If you seriously think "adding highmem support to x86_64 would
happen", please take a look at:

http://lkml.org/lkml/2008/12/16/306


> After all, the code portion in question ought to compile to nothing if
> !CONFIG_HIGHMEM.

Adding such complication to the generic swiotlb code seriously hurts
its readability and maintainability. X86_64 and IA64 should not surfer
such damage.
