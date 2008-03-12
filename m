Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbYCLQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbYCLQw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYCLQwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:52:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41013 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYCLQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:52:20 -0400
Date: Wed, 12 Mar 2008 10:52:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, penguin-kernel@i-love.sakura.ne.jp,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
Message-ID: <20080312165218.GB613@parisc-linux.org>
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp> <1205291010.9828.60.camel@nimitz.home.sr71.net> <20080311202212.9fe1e5c1.akpm@linux-foundation.org> <1205313918.8514.215.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205313918.8514.215.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 10:25:18AM +0100, Peter Zijlstra wrote:
> On Tue, 2008-03-11 at 20:22 -0700, Andrew Morton wrote:
> > > > INFO: trying to register non-static key.
> 
> It means the lock_class_key ended up in non-static storage.
> 
> In practise it often means you initialized a on-stack structure
> incorrectly. DECLARE_WAIT_QUEUE_HEAD() vs
> DECLARE_WAIT_QUEUE_HEAD_ONSTACK() for example.
> 
> /me tries to untangle the sysfs stuff, finds nothing wrong, looks at
> semaphore code, and.. the winner is: Matthew messed up the semaphores.
> 
> Tssk, rewriting locking primitives and not using lockdep...

I verified my use of spinlocks by hand ;-)

> Compile tested defconfig with lockdep and !lockdep.

Thanks for the patch.  I'll merge it into my generic semaphore patch
and add credit for you if that's OK -- no point in leaving a breakage
point around for some innocent bisecter to stumble over.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
