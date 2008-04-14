Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbYDNJbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbYDNJbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYDNJbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:31:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42973 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYDNJbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:31:00 -0400
Date: Mon, 14 Apr 2008 10:30:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080414093038.GA9785@ZenIV.linux.org.uk>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com> <20080411074631.GB6410@elte.hu> <20080411081901.f56f5180.randy.dunlap@oracle.com> <20080411152648.GK9785@ZenIV.linux.org.uk> <20080414081220.GA19865@elte.hu> <20080414082220.GZ9785@ZenIV.linux.org.uk> <20080414083440.GD19865@elte.hu> <20080414084320.GE23259@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414084320.GE23259@devserv.devel.redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 04:43:20AM -0400, Jakub Jelinek wrote:
> On Mon, Apr 14, 2008 at 10:34:40AM +0200, Ingo Molnar wrote:
> > ... but reality called in and gcc added printf format checks as a gcc 
> > extension and even modifies the code to make it safe when the user gets 
> > it "wrong".
> 
> GCC format string checking is only about warnings, GCC never modifies
> the arguments passed to make them match the format string conversions.

Actually, how hard would it be to allow new modifiers recognized by
format string checking?  Hell, even being able to teach it that (in this
family of functions) "%<d>u" should expect dma_addr_t, "%016<64>x" -
u64, etc. would solve all the problems.  Ideally we'd need something
for things like IPv4 address (__be32 expected), IPv6 address (taking
__be32 *), etc.

No magic, usual calling conventions - it'd still remain a valid C.
We can do that in sparse and just tell gcc to STFU about these warnings,
of course, but that's kind of things that is probably wanted by userland
projects as well...

BTW, ISTR FreeBSD folks carrying gcc patches in their tree for something
with similar purpose - project-specific format modifiers/specifiers.
No idea how hard it would be to generalize, though - never looked at
those in details...
