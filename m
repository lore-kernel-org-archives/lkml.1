Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZCDW03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZCDW03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZCDW0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:26:20 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38275 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZCDW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:26:19 -0500
Date: Wed, 4 Mar 2009 15:26:17 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: Support for multiple MSI
Message-ID: <20090304222617.GA21720@parisc-linux.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <m17i35z6fc.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17i35z6fc.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 06:52:39AM -0800, Eric W. Biederman wrote:
> Do we have any benchmarks anywhere that show that multiple msi support
> gains us something?

Yep.  I get a 1% performance gain when doing

dd if=/dev/sdb of=/dev/null bs=512 count=10000000 iflag=direct

This is less improvement than I had expected, and I'm trying to find out
why before I publish the rest of the code.

> The requirement to allocate a contiguous block of vector numbers worries
> me for the x86 implementation.  I don't like the idea of having to deal
> with allocations that can fail because of fragmentation.

Multiple MSI support can fail for any number of reasons, fragmentation
is only one of them.  Drivers just have to deal with it.

> The fact that we also can not honor the irq affinity properly for multiple
> msi also disturbs me.

That's an x86 limitation; powerpc can independently steer MSI.

> At a quick skim your patchset is only the generic code without a single
> architecture specific implementation so it appears you have not done the
> hard work on figuring out how to deal with multiple msi in the real
> world.

I think that's terribly unfair.  How dare you insinuate I have done no
testing of my code?  I've published code before that implements multiple
MSI for x86-64, and I've adapted that code to the current tree.  When I
have enough time to do so, I'm going to adapt it to Ingo's -tip and
publish it.  There will be many things to criticise in it which I'm sure
will make you happy.

> Given that msi-x does not have any of these issues without data to say
> that there is a true gain in supporting multi-msi I don't see the point
> of supporting it.

There are people who have implemented it in silicon, and there is evidence of
performance improvement with Linux and with other operating systems.
Just because you don't like its limitations on x86 is not a valid reason
to keep it out.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
