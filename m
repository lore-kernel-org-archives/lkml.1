Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbYEGW7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbYEGW7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYEGW6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:58:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbYEGW6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:58:53 -0400
Message-ID: <482233F0.7040000@zytor.com>
Date: Wed, 07 May 2008 15:57:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
In-Reply-To: <48221AE3.6020602@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 07-05-08 22:52, Thomas Gleixner wrote:
> 
>>> And why do we need this clear_cpu_cap(c, X86_FEATURE_PAT) and then 
>>> manual setting of X86_FEATURE_PAT at all?
>>
>> The reason is to make cpu_has_pat a useful check and to avoid checking
>> cpu vendors, families and models inside of the PAT code. That's a good
>> thing actually, because the PAT code only cares about that cpu_has_pat
>> flag.
>>
>> Clearing it in the cpuinfo is just a cosmetic side effect which does
>> no harm at all.
> 
> Oh yes, it does. It makes people unaware that their CPUs _should_ be
> supporting PAT. The thing's not called /proc/kernelinfo for a reason.
> 

Okay, that is utter nonsense.  /proc/cpuinfo has always been, and will 
always be, the CPU *AS THE KERNEL SEES IT*.  If you want something else, 
use x86info(1).

> And would yelling at people how shuffle in code without (publicly at
> least) addressing one of your fellow arch maintainers objections and
> Pavel's review comments about code duplication without a single line
> of explanation/changelog do?

We did discuss this (over IRC, I'm afraid), and came to the conclusion 
that it's too risky to do the proper thing (blacklist) straight out the 
gate.  Consider it a staged implementation.  The reason for this is that 
some of the earlier chips have downright frightening errata w.r.t. PAT. 
  *At this point*, we'd have no reasonable way to filter those bug 
reports from the issues with the software itself.

So, one step at a time.  PAT is massively overdue in Linux, so it's no 
wonder you're anxious about it, but we need a modicum of caution here.

	-hpa
