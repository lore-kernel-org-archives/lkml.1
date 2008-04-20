Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYDTD3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYDTD3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 23:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYDTD3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 23:29:18 -0400
Received: from sandeen.net ([209.173.210.139]:14048 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYDTD3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 23:29:18 -0400
Message-ID: <480AB88C.1050900@sandeen.net>
Date: Sat, 19 Apr 2008 22:29:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu>
In-Reply-To: <20080419142329.GA5339@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>>  config 4KSTACKS
>>>  	bool "Use 4Kb for kernel stacks instead of 8Kb"
>>> -	depends on DEBUG_KERNEL
>>>  	depends on X86_32
>>> +	default y
>> This patch will cause kernels to crash.
> 
> what mainline kernels crash and how will they crash? Fedora and other 
> distros have had 4K stacks enabled for years:
> 
>   $ grep 4K /boot/config-2.6.24-9.fc9
>   CONFIG_4KSTACKS=y
> 
> and we've conducted tens of thousands of bootup tests with all sorts of 
> drivers and kernel options enabled and have yet to see a single crash 
> due to 4K stacks. 

Really, not one?

https://bugzilla.redhat.com/show_bug.cgi?id=247158
https://bugzilla.redhat.com/show_bug.cgi?id=227331
https://bugzilla.redhat.com/show_bug.cgi?id=240077

(hehe, ok, xfs is a common component there...)

and it's not always obvious that you've overflowed the stack.

CONFIG_DEBUG_STACKOVERFLOW isn't ery useful because the warning printk
it generates uses the remaining amount of stack, and tips the box.

> So basically the kernel default just follows the 
> common distro default now. (distros and users can still disable it)

If Fedora is the common distro, ok. :)

Fedora is a pretty narrow sample in terms of IO stacks at least.  I have
plenty of fondness for Fedora, but it's almost 100% ext3[1].  I spent a
fair amount of time getting xfs+lvm to survive 4k on F8; gcc caused
stack usage to grow in general from F7 to F8, and F9 seems to have
gotten tight again but I haven't gotten to the bottom of yet.

Heck my ext3-root-on-sda1 pre-beta F9 box, no nfs or lvm or xfs or
anything gets within 744 bytes of the end of the 4k stack simply by
*booting* (it was a modprobe process... maybe some module needs help)

How many other distros use 4K stacks on x86, really?

-Eric

[1] http://www.smolts.org/static/stats/stats.html shows 24588 ext3
filesystems, compared to 366 xfs, 248 reiserfs, 76 jfs ...
