Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYEGNNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYEGNNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYEGNNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:13:19 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:47449 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYEGNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:13:16 -0400
Message-ID: <4821AB1F.8090101@keyaccess.nl>
Date: Wed, 07 May 2008 15:14:07 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       hpa@zytor.com, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: Undocumented and duplicated code
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi>
In-Reply-To: <20080507124650.GD29935@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-05-08 14:46, Adrian Bunk wrote:

>> others like to to whitebox methods, ..., please try attach patch to
>> see if duron support PAT.
> 
> 
> There surely is documentation available covering this?
> 
> And why do we need this clear_cpu_cap(c, X86_FEATURE_PAT) and then 
> manual setting of X86_FEATURE_PAT at all?
> 
> There's no indication in the code, and as Rene already says there's even
> no description at all in commit 9307cacad0dfe3749f00303125c6f7f0523e5616
> 
> Such code really needs a comment explaining why we have to do this at all.
> 
> There must be some CPUs with the "pat" flag set but not being usable?
> Which?
> 
> According to the linux-kernel discussions there might not be any broken 
> CPU at all - but in this case the whitelist will not fill itself, and 
> expecting people to note that their flags changed and complaining is not 
> really a good approach.

I'd say it's an insane approach unless there's actually some indication of
buggy CPUs. Which there might be, I don't know, but this then definitely
wants a comment and changelog.

Just now sent out another reply as well saying much the same:

http://marc.info/?l=linux-kernel&m=121016531804511&w=2

but I see you tracked the people involved and added them to CC on this
thread-leaf...

> And that your commit added the same clear/set code in three different 
> places doesn't look good - this really deserved from the beginning being 
> factored out into an own function to avoid future problems when CPUs get 
> added (like what happens with your patch here - it touches only one 
> place, and since the same context is present in two places in the same 
> file "patch" might even choose freely where it gets applied...).
> 
> Pavel even made a similar comment on linux-kernel before the patch 
> got merged into Linus' tree. [1]
> 
> Guys, even if it compiles in all randconfig configurations and works on 
> all test machines this is exactly the kind of stuff that causes 
> headaches in the future.
> 
> And this patch (by the author of the code himself) is the first time 
> where it breaks.

Rene.
