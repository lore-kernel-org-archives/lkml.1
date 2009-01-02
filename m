Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZABSYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZABSYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbZABSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:24:36 -0500
Received: from relay3.sgi.com ([192.48.171.31]:58598 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751741AbZABSYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:24:36 -0500
Message-ID: <495E5BDF.6030204@sgi.com>
Date: Fri, 02 Jan 2009 10:24:31 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Gautham R Shenoy <ego@in.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Sergio Luis <sergio@larces.uece.br>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>, LKML <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: git-pull request for tip/cpus4096
References: <495E4837.8090600@sgi.com> <20090102180942.GB10072@elte.hu>
In-Reply-To: <20090102180942.GB10072@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Hi Ingo,
>>
>> Here's the latest cpumask updates which includes the latest merge from 
>> Rusty's cpumask tree.
> 
> Pulled into tip/cpus4096, thanks Mike.
> 
> Rusty already sent the pull request to Linus for his latest cpumask bits - 
> is it fine if that goes upstream first and we do the second phase of the 
> cpus4096 tree after that point?

As in the bits included in this pull request, or as in the last set of cpumask
changes yet to be pushed to you?  (Either is fine with me, just let me know
what you want me to do.)

> 
> Also, while testing tip/master i noticed that a couple of architectures 
> wouldnt build due to cpumask changes:
> 
>    testing 21 architectures.
>  
>    testing       cris:  -git:  pass (  28),  -tip:  FAIL (  25)
>    testing       m32r:  -git:  pass (  21),  -tip:  FAIL (  31)
>  
> both build failures go like this:
>  
>   /home/mingo/tip/lib/find_last_bit.c: In function 'find_last_bit':
>   /home/mingo/tip/lib/find_last_bit.c:38: error: implicit declaration of function '__fls'
>   make[2]: *** [lib/find_last_bit.o] Error 1
>   make[2]: *** Waiting for unfinished jobs....
>   make[1]: *** [lib] Error 2
>  
> these architectures have no __fls() implementation ...
>  
> trouble should be expected on ~8 architectures:

I'll leave this to Rusty, as it's his baby.  (Is there an echo in here? ;-)

Thanks,
Mike

>  
>   for N in arch/*; do [ -d $N ] && ( printf "%-20s: " $N; cd $N; dgrep __fls |
>     wc -l; ); done | sort -t: -n -k +2
>  
>  arch/cris           : 0
>  arch/frv            : 0
>  arch/h8300          : 0
>  arch/m32r           : 0
>  arch/m68k           : 0
>  arch/mn10300        : 0
>  arch/um             : 0
>  arch/xtensa         : 0
>  arch/arm            : 1
>  arch/avr32          : 1
>  arch/blackfin       : 1
>  arch/ia64           : 1
>  arch/m68knommu      : 1
>  arch/parisc         : 1
>  arch/powerpc        : 1
>  arch/s390           : 1
>  arch/sh             : 1
>  arch/x86            : 1
>  arch/alpha          : 2
>  arch/sparc          : 2
>  arch/mips           : 5
>  
>  	Ingo

