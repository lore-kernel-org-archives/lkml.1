Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549Ab0AGXvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0AGXvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007Ab0AGXvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:51:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34306 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0AGXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:51:52 -0500
Date: Fri, 8 Jan 2010 00:51:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
Message-ID: <20100107235149.GD16076@basil.fritz.box>
References: <1262896174.2659.3.camel@localhost> <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262901198.2659.38.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd like to see this fixed, but I do not want to jump onto a solution
> that changes the behaviour of mmap() w.r.t. revalidation. The current
> behaviour dates back at least to 2.3.x if not before.

So do you have a plan to fix it?

I don't think it'll be possible to do drastic changes in the
VFS for 2.6.33, and it seems preserving the current semantics
would need that.

> That's why I'm working slowly on this.

Delaying a fix to after 2.6.33 is not an option imho.

It hits everyone with LOCKDEP enabled who uses mmap over NFS.
That's new in 2.6.33, previously LOCKDEP didn't diagnose this.

I'll keep using my patch, but I suppose once we're going more
towards a release you'll get more reports of this.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
