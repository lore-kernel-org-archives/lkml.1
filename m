Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYFTAlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYFTAlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 20:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYFTAlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 20:41:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:4982 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYFTAlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 20:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Mbn72P+x5jpw+YEebucbXXQ5/xwDGncZyvuw8qMVLZsmdmBbx87By97+CXCYj97zY8
         9vjm8ZUIge95R6d99E3wJWQvCiuIeCcF8sm/OPnkr/2DseDpmS/O/LvvH4pEJd/35Ufm
         eLrpR//TUGyXPrEgvr/EsLsadHspzKJO6nPOw=
Message-ID: <485AFC9B.7090502@gmail.com>
Date: Thu, 19 Jun 2008 21:40:59 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Bisecting tip/auto-x86-next?
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am trying to track down a problem I reported here:

http://lkml.org/lkml/2008/6/11/431

None or you were cc'd on the original report because I had no idea of 
the source of the issue.  However, I have now narrowed down the problem 
to the auto-x86-next tree.  Thus I did something like:

$ git bisect start
$ git bisect good linus/master
$ git bisect bad tip/auto-x86-next

which resulted in only about 170 or so revisions to test (sounds better 
than the 3000 or so that -next wanted me to bisect through).  However, 
when I tried to compile the bisect-chosen commit, I get:

------------------

In file included from include/asm/thread_info.h:5,
                  from include/linux/thread_info.h:47,
                  from include/linux/preempt.h:9,
                  from include/linux/spinlock.h:49,
                  from include/linux/seqlock.h:29,
                  from include/linux/time.h:8,
                  from include/linux/stat.h:60,
                  from include/linux/module.h:10,
                  from crypto/sha1_generic.c:20:
include/asm/thread_info_64.h: In function ‘set_restore_sigmask’:
include/asm/thread_info_64.h:189: warning: passing argument 2 of 
‘set_bit’ from incompatible pointer type

-----------------

Can I ignore these warnings and keep building the kernel anyway?  Or is 
there a way to work around this problem?  Am I allowed to cherry pick a 
particular commit to apply on top of the bisect-chosen commit, or will 
that ruin the process?  Can I manually choose a bisection point right 
after this warning was fixed?  Is it likely that the fix for this 
warning will get rearranged in the tree before Linus pulls it so that 
other don't run into this same bisection problem?

Is that enough questions?

Thanks,

-- 
Kevin Winchester


