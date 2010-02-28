Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031558Ab0B1IUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:20:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51373 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031496Ab0B1IUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:20:08 -0500
Date: Sun, 28 Feb 2010 08:19:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100228081922.GO30031@ZenIV.linux.org.uk>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <201002271323.14402.rjw@sisk.pl>
 <20100227124710.GA21164@elte.hu>
 <201002272007.43042.rjw@sisk.pl>
 <20100228071405.GA14205@elte.hu>
 <20100228183725.80915681.sfr@canb.auug.org.au>
 <20100228075105.GC14205@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228075105.GC14205@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 08:51:05AM +0100, Ingo Molnar wrote:

> ( Alas, ARM doesnt tend to be a big problem, at least as far as the facilities 
>   i'm concerned about go: it has implemented most of the core kernel 
>   infrastructures so there's few if any 'self inflicted' breakages that i can 
>   remember. )

FWIW, it might make sense to run cross-builds for many targets and post
the things that crop up + analysis to linux-arch...  Any takers?

I haven't run a lot of cross-builds lately, but IME most of the breakage
tends to be less dramatic - somebody relying on indirect includes in
driver *or* forgetting to add "depends on" to Kconfig used to be the
most frequent case.

"let other targets rot" attitude has a very nasty effect - it snowballs.
At some point people *can't* check that their patches don't break things,
even if they want to.  And that, IMO, sucks.  At that point architecture
needs to be either removed or brought to the state when it builds in
mainline.

Note that we have filesystems that are built only on some architectures.
I don't know about you, but I *do* care about not leaving half-converted
interfaces in that area.  For entirely rational reasons - people tend
to copy b0rken code from random places in the tree.  Playing whack-a-mole
gets old pretty soon.
