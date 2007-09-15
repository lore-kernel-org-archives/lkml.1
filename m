Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXIOXuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXIOXuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 19:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXIOXuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 19:50:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54810 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbXIOXuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 19:50:08 -0400
Message-ID: <46EC6F2A.5090008@oracle.com>
Date: Sat, 15 Sep 2007 16:47:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org> <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com> <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 15 Sep 2007, Linus Torvalds wrote:
>> So regardless of whether we want to trust "user_mode(regs)" more than 
>> "error_code & PF_USER", it would definitely be very interesting if you can 
>> give a good "this is where it started happening".
> 
> Also, can you point to good crashme sources, and give the arguments you 
> used to run it when it crashed?

I use http://people.delphiforums.com/gjc/crashme.tgz from
http://people.delphiforums.com/gjc/crashme.html, plus one small patch:

--- gjc-crashme.orig/crashme.c
+++ gjc-crashme/crashme.c
@@ -260,7 +260,8 @@ void my_signal(sig, func)
 #else
  struct sigaction act;
  act.sa_handler = func;
- act.sa_mask = 0;
+ //act.sa_mask = 0;
+ sigemptyset(&act.sa_mask);
 #ifdef linux
  act.sa_restorer = 0;
 #endif /* linux */


Command: ./crashme +2000 666 1000 1:00:00 1

> The original gjc crashme doesn't even do a "mprotect(PROT_EXEC)" by 
> default (nor does it even compile on a modern unix), so it's not going to 
> do anything. I hacked it up, and it appears to work ok for me, but I'm not 
> at all confident that I'm even close to recreating what you are doing.

So I'm missing some mprotect() call also?
Oops.

> (It probably goes without saying that I've not reproduced the oops on my 
> Core 2 Duo. Lots of #GP and #PF errors, but nothing interesting.
> 
> 		Linus

