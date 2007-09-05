Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbXIEOHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbXIEOHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXIEOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:07:07 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:42795 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbXIEOHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:07:05 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
Date: Wed, 5 Sep 2007 10:06:28 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
References: <46CED214.6050505@gmail.com> <200709040753.32204.paul.moore@hp.com> <200709042302.CDE26023.MJOOLQVFFOtHSF@I-love.SAKURA.ne.jp>
In-Reply-To: <200709042302.CDE26023.MJOOLQVFFOtHSF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2180
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200709051006.28429.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 September 2007 10:02:46 am Tetsuo Handa wrote:
> According to Patrick McHardy's posting at
> http://www.mail-archive.com/linux-security-module@vger.kernel.org/msg00999.
>html netfilter *socket filters* cannot know final recipient process.
> Can netfilter *userspace queue mechanism* know final recipient process?

Okay, I just went back and re-read the conversation from July as well as the 
description of your current patches and I think what is basically comes down 
to is that your design makes use of userspace intervention to allow/reject 
connections and/or packets based on the application's domain.  Unfortunately 
for TOMOYO, the current LSM network hooks are placed in such a way that you 
can not block and query a userspace agent for an access control decision.

Myself and some others have suggested using the netfilter userspace queue 
mechanism[1].  However, I understand this may cause you problems when you try 
to determine the incoming packet's destination/domain.  With these 
requirements I understand why you are pushing so hard to introduce these new 
LSM hooks, but for many reasons I would really prefer to try and find a way 
to utilize the existing hooks.  I've tried to think of a way to do this over 
the past day and have not been able to arrive at a clean solution.  
Personally, I still question the wisdom of receiving a packet/connection only 
to drop/reject it later when an application tries to read it but I might be 
the only one.

Based on some of the other discussion around this patch there appears to be 
other, larger issues which you still need to sort out (language parser in the 
kernel, /proc issues, etc.).  I would recommend addressing those concerns and 
including the netdev mailing list on your next patchset as they might have 
some thoughts on your network design.

[1]http://www.netfilter.org/projects/libnetfilter_queue/index.html

-- 
paul moore
linux security @ hp
