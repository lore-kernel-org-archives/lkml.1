Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYGNDTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYGNDTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 23:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYGNDTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 23:19:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50037
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYGNDTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 23:19:10 -0400
Date: Sun, 13 Jul 2008 20:19:06 -0700 (PDT)
Message-Id: <20080713.201906.60811176.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: benh@kernel.crashing.org, suresh.b.siddha@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Re: Multiple MSI, take 3
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1ej5x1at3.fsf@frodo.ebiederm.org>
References: <1215994659.7549.227.camel@pasglop>
	<20080713.174457.82768245.davem@davemloft.net>
	<m1ej5x1at3.fsf@frodo.ebiederm.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 13 Jul 2008 19:03:52 -0700

> At the very least you are left with the problem of allocating multiple
> contiguous destinations.  Which has the potential to create
> fragmentation on all supported platforms.

I don't think this is a very real concern.  With 256 MSI slots
available per domain, at least on sparc64, no real case can cause
problems.

And even so, drivers can and should fall back when allocations fail
anyways.

That's what drivers, at least the ones I have written, do even for
MSI-X.  For example, the NIU driver scales back the number of
MSI-X vectors it askes for if the original request cannot be
satisfied.

> My honest opinion is that the should have deprecated multi-msi after
> the introduction of the msi-x specification.

I don't think this would have materially influenced what happened with
AHCI at all.
