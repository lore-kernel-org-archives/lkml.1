Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbYJRIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbYJRIdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYJRIdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:33:04 -0400
Received: from 1wt.eu ([62.212.114.60]:4806 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYJRIdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:33:01 -0400
Date: Sat, 18 Oct 2008 10:32:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081018083241.GP24654@1wt.eu>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 01:16:38AM -0700, Steven Noonan wrote:
> I believe some of Adrian's concerns are valid. Userspace programs will
> indeed break, largely because some depend on build-time and run-time
> checks for the kernel version being >=2.6.0 or >=2.4.0 and so forth. I
> suspect the best way to prove userspace breakage would be to make a
> branch of the kernel with a new versioning scheme (8.10, 2008.10,
> whatever) and use that as the installed kernel while building a Gentoo
> system. I suspect you'd see massive breakage.

The breakage is expected of course but should remain minor. It has
always existed, when switching from 2.0 to 2.1, then 2.1 to 2.2,
assuming that 2.2 was equivalent to 2.1.XX for some tools (remember
knfsd ?), then from 2.2 to 2.3, then to assume that 2.4 was roughly
equal to some 2.3.XX for some tools, then 2.5.XX then 2.6. Now some
tools know that all 2.6 are not equivalent and they add new checks
as versions appear.

It will not be a problem. Some versions of some tools will certainly
break at some point, but these are the ones used to check for a given
platform, and it is normal for them to evolve and follow new releases.

I know I have some build scripts packaging one way for 2.4 and another
way for 2.6. Should initramfs not work anymore for instance, I'd have
to rethink the process for more recent 2.6 anyway. It is possible that
I'll have to do this with the recent firmware changes.

Some tools which already assume that all 2.6 are equivalent will one
day or another have to refine their checks after kernel feature
removals which we're not allowed to complain about (eg: some modules).

So updating tools to add support for new versions is not a major problem
because it will eventually happen anyway.

> I think a version numbering system change would be OK (though I
> wouldn't very much -like- it), so long as there was a way for
> userspace software to be able to differentiate between a kernel with
> the old versioning system and the new versioning system.
> 
> I think perhaps a better option in the long run is to start a v2.7
> tree and figure out some Cool New Stuff(tm) to implement, keeping
> consistency with the current versioning scheme.

It would require tools updates as well.

Willy

