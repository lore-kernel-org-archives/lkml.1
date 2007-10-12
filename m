Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbXJLRwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbXJLRwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761091AbXJLRw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:52:29 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41840 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760071AbXJLRw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:52:27 -0400
Date: Fri, 12 Oct 2007 19:53:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH v2] kbuild: save ARCH & CROSS_COMPILE when building a kernel
Message-ID: <20071012175308.GC21193@uranus.ravnborg.org>
References: <20071009194919.GA26726@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009194919.GA26726@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 09:49:19PM +0200, Sam Ravnborg wrote:
> When building a kernel for a different architecture
> kbuild requires the user always to specify ARCH and
> CROSS_COMPILE on the command-line.
> Failing to do so can result in strange build errros especially
> when the asm symlink point to anohter architecture than
> the one being build.
> The typical case is that the user forget to specify
> ARCH and/or CROSS_COMPILE on the commandline.
> 
> Address the above issues by saving ARCH and CROSS_COMPILE
> when building a kernel. The information is saved in a
> file named ".kbuild" which is not supposed to be manually
> edited and kbuild will overwrite it when a kernel is build.
> 
> If a kernel is build and no ARCH/CROSS_COMPILE info is saved
> then the current settings are saved.
> If ARCH/CROSS_COMPILE was saved then these value are used.
> If the user specified either ARCH and/or CROSS_COMPILE
> it is validated that they match the saved values and kbuild
> error out if this is not the case.

There quickly turned up two issues which this patch when
hitting -mm.
Issue 1) Adding the ARCH ?= caused all native builds
to loose their ARCH setting. I only tested this with
my suite of crosscompilers and not native.

Issue 2) When installing the kernel in a different
environment than where is was compiled turned up that
we even for a modules_install or headers_install call
gcc - and with CROSS_COMPILE set the gcc could not be
located and we printed an error message.

The latter issue require some more involved refactoring
of the top-level Makefile and is thus not ready until next
merge window.
The patch will be withdrawn for now and I hope to have
the top-level Makefile refactored until next merge window.

The prime reason for the refactoring is to remove the top-
level Makefile from the 3xun list.
3xun = Unreadable, unhackable, unmaintainable

Introducing said patch afterwoard is just a nice bonus.

	Sam
