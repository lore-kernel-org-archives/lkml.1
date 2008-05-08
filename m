Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYEHCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYEHCPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYEHCPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:15:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbYEHCPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:15:31 -0400
Message-ID: <4822614B.6080706@zytor.com>
Date: Wed, 07 May 2008 19:11:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 8 May 2008, Rene Herman wrote:
>> Okay, so how's this? Seem to work well for me and makes me happy. Only
>> tested on UP.
> 
> Looks sane to me.
> 
> Not that I ever really saw the point about this whole argument in the 
> first place. Clearing the flags wasn't really wrong to begin with.
> 

Indeed it wasn't, and at least I have no interest of maintaining what is 
in effect an in-kernel version of x86info(1).

*Certainly* I don't want anything like this crap:

> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 277446c..6ee3efb 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -43,7 +43,7 @@ static int pat_known_cpu(void)
>     if (!pat_wc_enabled)
>         return 0;
> 
> -    if (cpu_has_pat)
> +    if (cpu_has_pat && cpu_has_pat_good)
>         return 1;
> 
>     pat_wc_enabled = 0; 

	-hpa
