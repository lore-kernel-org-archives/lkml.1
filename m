Return-Path: <linux-kernel-owner+w=401wt.eu-S1946126AbXBPU2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946126AbXBPU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946131AbXBPU2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:28:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946126AbXBPU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:28:09 -0500
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Howells <dhowells@redhat.com>,
       torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20070216202135.GA22121@redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
	 <20070215221304.GB6602@ucw.cz>  <20070216202135.GA22121@redhat.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 16 Feb 2007 21:27:58 +0100
Message-Id: <1171657678.12771.645.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> The restricted dev/mem patches we've had in Fedora for a while
> do the right thing, but they're a bit crufty (in part due to
> drivers/char/mem.c being a bit of a mess before we even start
> patching it).  I've had "clean these up for upstream" on my
> todo for a while. I might get around to it one of these days.


the real thing is that /dev/mem is too many things for too many people.
Fundamentally it has 3 components
1) ram-but-not-kernel data: basically BIOS datastructures
2) kernel visible ram: user/kernel data, this has all the nasty cache
coherency issues. This is also a "debug only" use, and "rootkit only"
sometimes ;) 
3) MMIO space: this really should not be used anymore, sysfs provides a
MUCH better interface and it also breaks if you have enforcing IOMMU's
in the system... it can't really work since the kernel doesn't get told
which device is being accessed

unless we split this up (well the third is split already) it's going to
remain a big mess.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

