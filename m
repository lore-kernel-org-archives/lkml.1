Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYIEOGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYIEOGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYIEOGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:06:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:57070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYIEOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:06:13 -0400
Subject: Re: [PATCH 02/23] arm: use the new byteorder headers
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Khem Raj <raj.khem@gmail.com>
In-Reply-To: <20080905102533.GA26458@flint.arm.linux.org.uk>
References: <1219106875.17033.55.camel@brick>
	 <20080819072715.GB30521@flint.arm.linux.org.uk>
	 <1219172580.17033.87.camel@brick>
	 <1220608169.2985.305.camel@pmac.infradead.org>
	 <20080905102533.GA26458@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 15:06:06 +0100
Message-Id: <1220623566.2985.343.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-05 at 11:25 +0100, Russell King wrote:
> On Fri, Sep 05, 2008 at 10:49:29AM +0100, David Woodhouse wrote:
> > On Tue, 2008-08-19 at 12:03 -0700, Harvey Harrison wrote:
> > > include/linux/swab.h, include/linux/byteorder.h are in current
> > > mainline which is all that these patches depend on.
> > 
> > Er, it also depends on the patch which exports those headers to
> > userspace, which isn't in Linus' tree yet.
> 
> How useful.  If those generic headers are already in Linus' tree, and
> are required for architectures to convert, why hasn't the patch which
> exports them to userspace already been submitted?

Because they weren't being used by anything exported to userspace yet.
The patch has been seen, but wasn't destined for 2.6.27...

> However, another question: why should userspace be using a kernel header
> file for byteswapping?

... mostly (on my part, at least) because of that question.

Given my druthers, I'd revert the ARM part of the patch for now, and we
can have a _serious_ think about whether we really need to export these
functions to userspace.

A quick survey shows that the following user-visible headers currently
use cpu_to_xxx() and xxx_to_cpu():

linux/romfs_fs.h
linux/bfs_fs.h
linux/ext2_fs.h
linux/reiserfs_fs.h
linux/msdos_fs.h
linux/ncp.h
linux/ncp_no.h

Of those, most of them use the form without underscores, which isn't
visible in userspace _anyway_ and would be broken even if the new header
is exported. I suspect that they should all just be dropped from the
list of exported headers.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



