Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYEHAB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYEHAB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYEHABo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:01:44 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54631 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYEHABm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:01:42 -0400
Message-ID: <48224318.8020209@keyaccess.nl>
Date: Thu, 08 May 2008 02:02:32 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com>
In-Reply-To: <482233F0.7040000@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 00:57, H. Peter Anvin wrote:

>>> Clearing it in the cpuinfo is just a cosmetic side effect which does
>>> no harm at all.
>>
>> Oh yes, it does. It makes people unaware that their CPUs _should_ be
>> supporting PAT. The thing's not called /proc/kernelinfo for a reason.
>>
> 
> Okay, that is utter nonsense.  /proc/cpuinfo has always been, and will 
> always be, the CPU *AS THE KERNEL SEES IT*.  If you want something else, 
> use x86info(1).

What a lovely way of syncing reality with your definitions. The kernel
_does_ see that my CPU features PAT, it just refuses to use it because
it doesn't trust it enough. Vital difference. Maybe not to the kernel,
but definitely to me, the user. /proc/cpuinfo is a user interface.

PAT is a CPU, hardware, flag documented in the arch manuals. If the
kernel wants to keep software flags as well why not simply add those?

>> And would yelling at people how shuffle in code without (publicly at
>> least) addressing one of your fellow arch maintainers objections and
>> Pavel's review comments about code duplication without a single line
>> of explanation/changelog do?
> 
> We did discuss this (over IRC, I'm afraid), and came to the conclusion 
> that it's too risky to do the proper thing (blacklist) straight out the 
> gate.  Consider it a staged implementation.  The reason for this is that 
> some of the earlier chips have downright frightening errata w.r.t. PAT. 
>  *At this point*, we'd have no reasonable way to filter those bug 
> reports from the issues with the software itself.
> 
> So, one step at a time.  PAT is massively overdue in Linux, so it's no 
> wonder you're anxious about it, but we need a modicum of caution here.

Really, I'm not so much anxious about PAT as I got anxious about seeing
my entire CPU famility dropped without a single explanation. Had the one
you provide above be in the commit message this thread had not happened
(yes, although redefining X86_FEATURE_PAT is still crap).

As it's merged, nothing said that it was specifically not using and/or
disabling PAT just that it wasn't supported. Even if it had done _that_
much this thread would've probably not happened.

Rene.
