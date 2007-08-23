Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXHWDZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXHWDZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXHWDZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:25:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:64118 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXHWDZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:25:38 -0400
Message-ID: <46CCFE2C.4050306@windriver.com>
Date: Wed, 22 Aug 2007 22:25:32 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [Kgdb-bugreport] 2.6.23-rc3-mm1: kgdb build failure on powerpc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<200708222104.29432.m.kozlowski@tuxland.pl>	<20070822124743.fc316963.akpm@linux-foundation.org>	<46CCBC3C.7010307@windriver.com> <20070822165318.b82da13c.akpm@linux-foundation.org>
In-Reply-To: <20070822165318.b82da13c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2007 03:25:13.0804 (UTC) FILETIME=[37F2E0C0:01C7E535]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 22 Aug 2007 17:44:12 -0500
> Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> +	while (!atomic_read(&debugger_active));
>>     
>
> eek.  We're in the process of hunting down and eliminating exactly this
> construct.  There have been cases where the compiler cached the
> atomic_read() result in a register, turning the above into an infinite
> loop.
>
> Plus we should never add power-burners like that into the kernel anyway. 
> That loop should have a cpu_relax() in it.  Which will also fix the
> compiler problem described above.
>
>   
Agreed, and fixed with a cpu_relax.

> Thirdly, please always add a newline when coding statements like that:
>
> 	while (expr())
> 		;
>   

The other instances I found of the same problem in the kgdb core are 
fixed too.

I merged all the changes into the for_mm branch in the kgdb git tree.

Thanks,
Jason.
