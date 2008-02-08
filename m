Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbYBHKSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbYBHKSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932667AbYBHKSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:18:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33315 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972AbYBHKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:18:42 -0500
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
	architecture
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080208094538.GC21852@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local>
	 <20080207125824.GB7111@infradead.org>
	 <20080207130117.GA18750@uranus.ravnborg.org>
	 <200802071609.36960.openembedded@haerwu.biz>
	 <20080207160557.GB28435@flint.arm.linux.org.uk>
	 <20080207202329.GA21949@uranus.ravnborg.org>
	 <1202461453.5469.217.camel@pmac.infradead.org>
	 <20080208094538.GC21852@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 10:18:31 +0000
Message-Id: <1202465911.5469.240.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 09:45 +0000, Russell King - ARM Linux wrote:
> If we are serious about allowing ARM to use drivers/Kconfig, then let's
> not get distracted by perfection - by trying to do too many changes in
> one go.
> 
> If, today, we conditionalise MTD or IDE on a certain set of symbols,
> then those conditions should be preserved in the first step - it should
> be a 1:1 translation.

That makes some sense. Currently you have:

	if ALIGNMENT_TRAP || !CPU_CP15_MMU
	source "drivers/mtd/Kconfig"
	endif

> Later, if there's a need to improve it (as you're suggesting) that should
> be a *separate* change.

We can certainly improve the behaviour later, it's true -- it's not the
end of the world if we continue to have the whole of the MTD layer
turned off on platforms with alignment problems for now.

But still, it's HAVE_UNALIGNED_ACCESS which we want to depend on, not a
newly-invented HAVE_MTD. And there are other places we really ought to
be depending on HAVE_UNALIGNED_ACCESS too.

-- 
dwmw2

