Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbXEAPwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbXEAPwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXEAPwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:52:03 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:38153 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXEAPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:52:00 -0400
Message-ID: <46376210.6090200@cosmosbay.com>
Date: Tue, 01 May 2007 17:51:44 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>, Andi Kleen <ak@suse.de>,
       Eric Dumazet <dada1@cosmosbay.com>, ebiederm@xmission.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the
 2G/2G split.
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <4636C16F.204@cosmosbay.com> <20070501062132.GQ25929@bingen.suse.de> <20070501130132.GL26598@holomorphy.com>
In-Reply-To: <20070501130132.GL26598@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 01 May 2007 17:51:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin a écrit :
> On Tue, May 01, 2007 at 06:26:23AM +0200, Eric Dumazet wrote:
>>> Hum... We lose a usefull 2G/2G split. Should'nt we use a patch to change 
>>> PAGE_OFFSET to 0x8000000 instead of 0x78000000 and keep 2G/2G split ?
> 
> On Tue, May 01, 2007 at 08:21:32AM +0200, Andi Kleen wrote:
>> I dropped the patch for now.
> 
> I'm more miffed about what it's cleaning up after than the patch itself.
> 
> 
> On Tue, May 01, 2007 at 06:26:23AM +0200, Eric Dumazet wrote:
>>> [PATCH] i386 : Adjust CONFIG_PAGE_OFFSET in case of 2G/2G split and X86_PAE
>>> When in PAE mode we require that the user kernel divide to be
>>> on a 1G boundary.  We must therefore make sure PAGE_OFFSET is correctlty 
>>> defined in the 2G/2G split and PAE mode.
> 
> On Tue, May 01, 2007 at 08:21:32AM +0200, Andi Kleen wrote:
>> Looks reasonable. Did you test both cases? wli, ok for you too?
> 
> Sorry about the delay in replying.
> 
> I don't mind so long as we're not letting doorstop configs through. I'd
> probably do something more like
> 
> Index: sched/arch/i386/Kconfig
> ===================================================================
> --- sched.orig/arch/i386/Kconfig	2007-05-01 04:35:47.065162310 -0700
> +++ sched/arch/i386/Kconfig	2007-05-01 04:36:50.100754504 -0700
> @@ -571,6 +571,9 @@
>  		bool "3G/1G user/kernel split (for full 1G low memory)"
>  	config VMSPLIT_2G
>  		bool "2G/2G user/kernel split"
> +	config VMSPLIT_2G_OPT
> +		depends on !HIGHMEM
> +		bool "2G/2G user/kernel split (for full 2G low memory)"
>  	config VMSPLIT_1G
>  		bool "1G/3G user/kernel split"
>  endchoice
> @@ -578,7 +581,8 @@
>  config PAGE_OFFSET
>  	hex
>  	default 0xB0000000 if VMSPLIT_3G_OPT
> -	default 0x78000000 if VMSPLIT_2G
> +	default 0x80000000 if VMSPLIT_2G
> +	default 0x78000000 if VMSPLIT_2G_OPT
>  	default 0x40000000 if VMSPLIT_1G
>  	default 0xC0000000
>  
> as a stopgap measure, but I'm not all that interested in grabbing patch
> credits where others could do it easily enough. Either of the config
> alterations is fine by me as they now stand; maybe Eric Dumazet might
> care to do something like my suggestion at some point.

Your patch is very fine Bill, please resubmit it with proper Signed-off-by

My first patch was a trivial reaction to try to keep alive 2G/2G split, yours 
is better for fine tuning.

Thank you


