Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab0CNSGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:06:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758696Ab0CNSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:06:48 -0400
Date: Sun, 14 Mar 2010 11:04:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
In-Reply-To: <loom.20100314T113306-436@post.gmane.org>
Message-ID: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
 <m1fx43zhbd.fsf@fess.ebiederm.org> <loom.20100314T113306-436@post.gmane.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 14 Mar 2010, Wolfram Sang wrote:
>
> coccinelle can apply semantic patches, rough description here [1]. So I wrote
> one which checks for every c-file in the kernel-tree:
>
> - Is there a structure containing (bin_)attribute?
> - Does a function declare a pointer to such a structure?
> - Is this pointer then used for a sysfs_create(_bin)_file?
> - If so, has there been a call to sysfs(_bin)_attr_init before?
>
> If not -> report. As coccinelle works on an abstract level of the code (not on
> source-code level), it can follow code-paths and such. Really nice tool, once
> you gathered the information to learn it.
> 
> The outcome are those patches:
> 
> http://patchwork.kernel.org/patch/85214/
>
> http://patchwork.kernel.org/patch/85212/
> (which is pretty much the same like the patch originating this thread. I vote
> very much for dropping those patches and use
> http://patchwork.kernel.org/patch/84814/ instead!)
> 
> http://patchwork.kernel.org/patch/85213/

Hey, goodie.  Can we merge the trivial one-liners into a single patch that 
fixes the issue?

Also, that "firmware_attr_data" thing should probably be marked 'const', 
no? That should make it more obvious that it's ok to share across multiple 
different firmware file, I think.

> Eric, if you have a bit of time, acking these patches would help them getting
> accepted for the mips/rtc-trees, IMHO.

You removed everybody from the Cc: line, so I doubt Eric even sees your 
email. I added the cc's back in.

			Linus
