Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZKIPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZKIPqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZKIPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:46:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59705 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbZKIPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:46:19 -0500
Date: Mon, 9 Nov 2009 16:46:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091109154621.GG26740@basil.fritz.box>
References: <m1pr7siqjz.fsf@fess.ebiederm.org> <m1zl6vvpiv.fsf@fess.ebiederm.org> <20091109132830.GF26740@basil.fritz.box> <200911091628.47003.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911091628.47003.arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you name one binary sysctl value that gets accessed more
> than a few times during the execution of a vaguely common
> application? We're talking about microseconds for typically
> write-once or read-once settings.

For example shell scripts tend to execute programs quite a lot.

> The question is just how many sysctl values you regard as both
> common and performance critical.

Very little, I suspect in fact it's only one.

> > > in glibc-ports for the support of arm inb/outb.  The only other
> > > use in older glibc was checking to see if we ran on an SMP kernel.
> > 
> > That older glibc is widely deployed. And it won't go away next year.
> 
> So? Most users of old glibc are also using old kernels, and they

How do you know? At least here it's quite common to use new kernels
with old user land.

> can still use the  config option for the compatibility code.
> There wouldn't even be a performance penalty over new glibc with
> new kernels which already use procfs.

When he drops the sysctl(2) API completely the old userland will
be unhappy.

> > I just think you should have two flavours of emulation layer:
> > full and "common sysctls". This can be probably done with the same
> > code and some strategic ifdefs.
> 
> If it's just about code size, I totally wouldn't bother. Just put the
> emulation code in loadable module and add a 'printk("Warning, %s is
> using sysctl %s, wasting %d kb of kernel memory")' to it's module_init
> function.

That means non modular kernels can't support old userland.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
