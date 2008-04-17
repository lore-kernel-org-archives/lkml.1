Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYDQIOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYDQIOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYDQIOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:14:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbYDQIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:14:19 -0400
Date: Thu, 17 Apr 2008 01:14:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417011401.ea3e70f0.akpm@linux-foundation.org>
In-Reply-To: <20080417002552.5742ad65.akpm@linux-foundation.org>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 00:25:52 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> A quick grep indicates that only 644 of
> these 884 patches are in -mm.  And a lot of them only turned up a week or
> two ago.

I did a test merge.

- About 13 patch rejects agaisnt git-kvm

- Multiple minor rejects aginst the IDE tree, the PCI tree

- Minor bustage of git-semaphore

- Several core MM patches which I also had merged.  I didn't check fully
  whether they are the same.

- extensive damage to the page-flags patches

  Did you check that all architectures and configurations still have
  sufficient page flags for us to be able to consume another one for
  kmemcheck?  The MM developers have put much, much effort into avoiding
  running out of flags over numerous years and afaik none of them even know
  that this debug feature is using one of the few remaining ones.

  What do we do when we run out?

- rejects in capabilities-implement-per-process-securebits.patch

- The proposed PR_GET_TSC and PR_SET_TSC have the same values as
  PR_GET_SECUREBITS and PR_SET_SECUREBITS.  Because we never knew this
  before we didn't get to discuss which one needs to be altered as we
  normally would.

- several rejects in
  x86-olpc-add-one-laptop-per-child-architecture-support.patch

- several bitops patches (use-__fls-for-fls64-on-64-bit-archs, etc) were
  also in -mm.  I did not check for differences between the two versions.

  These are not x86 patches.

- maybe ten-odd minor rejects in other places.


So not as bad as it might have been.  kvm and page-flags are the major
problems.  Of course, none of this has been compiled and this proposed code
combination has never been tested by anyone at runtime.

