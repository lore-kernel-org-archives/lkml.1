Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbYEGVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbYEGVKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYEGVKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:10:11 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36989 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbYEGVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:10:07 -0400
Message-ID: <48221AE3.6020602@keyaccess.nl>
Date: Wed, 07 May 2008 23:10:59 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-05-08 22:52, Thomas Gleixner wrote:

>> And why do we need this clear_cpu_cap(c, X86_FEATURE_PAT) and then 
>> manual setting of X86_FEATURE_PAT at all?
> 
> The reason is to make cpu_has_pat a useful check and to avoid checking
> cpu vendors, families and models inside of the PAT code. That's a good
> thing actually, because the PAT code only cares about that cpu_has_pat
> flag.
> 
> Clearing it in the cpuinfo is just a cosmetic side effect which does
> no harm at all.

Oh yes, it does. It makes people unaware that their CPUs _should_ be
supporting PAT. The thing's not called /proc/kernelinfo for a reason.

>> And this patch (by the author of the code himself) is the first time 
>> where it breaks.
> 
> Very interesting analysis. What broke ? This CPU was never in the set
> of supported ones at all.

You misunderstood. Yinghai's patch only changed one of the code sites
and not the others, which (if I understood right) is the breakage
Adrian was reffering to.

> Anyway, you are welcome to review x86 code - it can definitely use 
> more eyeballs, but please try to inform yourself about the topic or 
> ask polite questions before yelling at people who contribute in a 
> very valuable way.

And would yelling at people how shuffle in code without (publicly at
least) addressing one of your fellow arch maintainers objections and
Pavel's review comments about code duplication without a single line
of explanation/changelog do?

Rene.
