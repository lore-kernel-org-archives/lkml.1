Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbYAYWgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbYAYWgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAYWgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:36:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYAYWgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:36:11 -0500
Date: Fri, 25 Jan 2008 23:35:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Message-ID: <20080125223556.GB24708@elte.hu>
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com> <20080125221548.GA15172@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125221548.GA15172@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> On Fri, Jan 25, 2008 at 01:05:40PM -0800, Yinghai Lu wrote:
> > current linus tree + x86.git
> > 
> > got
> > 
> > Calling initcall 0xffffffff80b93d98: threshold_init_device+0x0/0x3f()
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > IP: [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9
> 
> Does this happen on just Linus's tree?
> 
> Can you send me a .config file for this?
> 
> What is threshold_init()?  Is it something new in the x86.git tree?

no. A quick grep shows that it is in a file that _your_ changes in 
Linus' latest have touched:

  arch/x86/kernel/cpu/mcheck/mce_amd_64.c

via:

 Author: Greg Kroah-Hartman <gregkh@suse.de>
 Date:   Thu Dec 20 08:13:05 2007 -0800

     Kobject: convert arch/* from kobject_unregister() to kobject_put()

 Author: Greg Kroah-Hartman <gregkh@suse.de>
 Date:   Wed Dec 19 09:23:20 2007 -0800

     Kobject: change arch/x86/kernel/cpu/mcheck/mce_amd_64.c to use kobject_init_ 

 commit a521cf209c6e7042f85b2c5b16da3ffa8004fb7b
 Author: Greg Kroah-Hartman <gregkh@suse.de>
 Date:   Wed Dec 19 09:23:20 2007 -0800

     Kobject: change arch/x86/kernel/cpu/mcheck/mce_amd_64.c to use kobject_creat

x86.git changed nothing to cause a crash in kobject_uevent_env(), and 
nothing has changed anything near this code anyway.

We havent had a runtime (non-boot related) crash in x86.git for quite 
some time. It's rock solid and dependable, and the only significant 
change today were your upstream kobject commits.

	Ingo
