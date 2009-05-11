Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZEKDmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZEKDmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZEKDlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:41:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:40166 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZEKDls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:41:48 -0400
Date: Mon, 11 May 2009 12:40:39 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] xen: swiotlb support for Xen dom0
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241741842-7966-1-git-send-email-jeremy@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090511123626N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 12:40:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 May 2009 17:17:13 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This branch adds the swiotlb hooks for Xen dom0.  We use swiotlb to handle
> various device drivers which assume that multipage DMA transfers which are
> contigious in kernel memory are also contigious in machine memory (mostly
> lower-performance devices, as high-performance ones already do a good job
> of scatter-gather).
> 
> Following Fujita's suggestion, these changes remove a lot of the
> placeholder stubs in arch/x86/kernel/pci-swiotlb.c and moves them into
> the Xen-specific arch/x86/xen/pci-swiotlb.c.

Yeah, all Xen-specific stuff should live in the Xen land. The changes
to non-Xen code (like arch/x86/kernel/pci-swiotlb.c) look fine to me.


>  (It still relies on
> overriding the weak functions defined in lib/swiotlb.c.)

As I said before, I don't like such weak hacks added for dom0. We will
merge dom0 support?
