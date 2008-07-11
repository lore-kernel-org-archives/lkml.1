Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYGKKXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYGKKXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYGKKXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:23:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40107 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbYGKKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:23:43 -0400
Date: Fri, 11 Jul 2008 04:23:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Re: Multiple MSI, take 3
Message-ID: <20080711102326.GR14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org> <m1iqvc91li.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqvc91li.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 03:06:33AM -0700, Eric W. Biederman wrote:
> Matthew Wilcox <matthew@wil.cx> writes:
> 
> > I'd like to thank Michael Ellerman for his feedback.  This is a much
> > better patchset than it used to be.
> 
> There is a reason we don't have an API to support this.  Linux can not
> reasonably support this, especially not on current X86.  The designers
> of the of the AHCI were idiots and should have used MSI-X.

Thank you for your constructive feedback, Eric.  Unfortunately, we have
to deal with the world as it is, not how we would like it to be.  Since
I have it running, I'd like to know what is unreasonable about the
implementation.

> mask/unmask is will likely break because the mask bit is optional
> and when it is not present we disable the msi capability.

I believe this is fixable.  I will attempt to do so.

> We can not set the affinity individually so we can not allow
> different queues to be processed on different cores.

This is true, and yet, it is still useful.  Just not as useful as one
would want.

> So in general it seems something that we have to jump through a million
> hurdles and the result is someones twisted parody of a multiple working
> irqs, that even Intel's IOMMU can't cure.

More constructive feedback ...

> So unless the performance of the AHCI is better by a huge amount I don't
> see the point, and even then I am extremely sceptical.

I don't have performance numbers yet, but surely you can see that
avoiding a register read in the interrupt path is a large win?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
