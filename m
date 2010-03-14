Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0CNKuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:50:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:33452 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab0CNKuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:50:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in commit a2db6842873c8e5a70652f278d469128cb52db70
Date: Sun, 14 Mar 2010 10:49:50 +0000 (UTC)
Message-ID: <loom.20100314T113306-436@post.gmane.org>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org> <m1fx43zhbd.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 58.89.190.212 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.14) Gecko/2009091010 Iceweasel/3.0.6 (Debian-3.0.6-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eric W. Biederman <ebiederm <at> xmission.com> writes:

> Wolfram Sang was figuring out if he could get coccinelle (whatever
> that is) to find more of them.

Huh, found this accidently, CC helps :)

coccinelle can apply semantic patches, rough description here [1]. So I wrote
one which checks for every c-file in the kernel-tree:

- Is there a structure containing (bin_)attribute?
- Does a function declare a pointer to such a structure?
- Is this pointer then used for a sysfs_create(_bin)_file?
- If so, has there been a call to sysfs(_bin)_attr_init before?

If not -> report. As coccinelle works on an abstract level of the code (not on
source-code level), it can follow code-paths and such. Really nice tool, once
you gathered the information to learn it.

The outcome are those patches:

http://patchwork.kernel.org/patch/85214/

http://patchwork.kernel.org/patch/85212/
(which is pretty much the same like the patch originating this thread. I vote
very much for dropping those patches and use
http://patchwork.kernel.org/patch/84814/ instead!)

http://patchwork.kernel.org/patch/85213/

Eric, if you have a bit of time, acking these patches would help them getting
accepted for the mips/rtc-trees, IMHO.

Regards,

   Wolfram

[1] http://lwn.net/Articles/315686/

