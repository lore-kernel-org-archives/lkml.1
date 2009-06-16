Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbZFPXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbZFPXeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbZFPXeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:34:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZFPXeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:34:17 -0400
Message-ID: <4A382AC6.2070603@zytor.com>
Date: Tue, 16 Jun 2009 16:29:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Stas Sergeev <stsp@aknet.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Tejun Heo <tj@kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Chuck Ebbert <76306.1226@compuserve.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ping: Re: [PATCH 0/2] i386: espfix fixes
References: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm> <1245182594.27756.1320705931@webmail.messagingengine.com> <4A380C49.6050206@aknet.ru> <1245192098.31604.1320729303@webmail.messagingengine.com>
In-Reply-To: <1245192098.31604.1320729303@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> On http://lkml.indiana.edu/hypermail/linux/kernel/0608.0/0162.html:
>>>> - .quad 0x0000920000000000 /* 0xd0 - ESPFIX 16-bit SS */
>>>> + .quad 0x00cf92000000ffff /* 0xd0 - ESPFIX SS */
>>> Seems a bit dangerous to allow access to full 4GB through this.
>>> Can you tighten the limit any? I suppose not, because the high
>>> bits in %esp really could be anything. But it might be nice to
>>> try setting the limit to regs->esp + THREAD_SIZE. Of course, this
>>> is not strictly necessary, just an extra paranoid protection
>>> mechanism. 
>> Since, when calculating the base, I do &-THREAD_SIZE, I guess the
>> minimal safe limit is regs->esp + THREAD_SIZE*2... Well, may just
>> I not do that please? :) For what, btw? There are no such a things
>> for __KERNEL_DS or anything, so I just don't see the necessity.
> 
> In the normal case user-esp would be between 0 and 65535, and in
> that case the memory range in the ESPFIX stack segment would be
> pretty small. But userspace can set esp to just about anything if
> it really wants to, and in that case the reduction of the memory
> range is pretty much wothless (kernel stacks are allocated way
> above the code). As you said: may we just not do that, please?
> 

Who are "we", here?  First of all, this is about a 16-bit stack segment,
right?  Why are we doing a 4 GB limit at all if this is a 16-bit stack
segment (where the stack can only be touched for the first 64K even if a
stack operation happens)?

I clearly don't quite understand at a glance what is going on.
	
	-hpa

