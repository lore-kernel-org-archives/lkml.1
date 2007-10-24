Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbXJXLGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbXJXLGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXJXLGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:06:02 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34258 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbXJXLGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:06:00 -0400
Date: Wed, 24 Oct 2007 13:07:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.24-rc1
Message-ID: <20071024110733.GA1374@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024080451.GA32690@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:04:51AM +0100, Christoph Hellwig wrote:
> On Tue, Oct 23, 2007 at 09:19:16PM -0700, Linus Torvalds wrote:
> > In short, we just had an unusually large amount of not just x86 merges, 
> 
> Btw, can we please finis up this merge a little more before we freeze
> 2.6.24?  The way we currently have leftovers of arch/i386/ and arch/x86_64/
> is quite a nightmare and not how the other architectures were merged.

If these 10 files gives you nightmares then poor soul ;-)

Anyway - the primary issue is the two defconfig files and the Kconfig stuff.
For defconfig we can inheritate the solution from powerpc where
the defconfig file is selected based on architecture.
Something like a
DEFCONFIG := defconfig_$(ARCH)

and then stuff them in configs/ directory.

The Kconfig stuff could be handled by special casing in scripts/kconfig.
We cannot just do the more obvious which is source the files since
they have conflicting choice symbols.
That could be fixed but requires a bit more work to do so - since we need
to track all relevant usages of the choice symbols and rename these.
We could also teach kconfig to allow duplicate symbols names in two choices
but Roman Zippel has not done that yet.

The Makefile stuff is trivial to merge.


The above is not preventing us - more what needs to be done.

	Sam
