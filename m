Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYGaWEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYGaWEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYGaWE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:04:28 -0400
Received: from gw.goop.org ([64.81.55.164]:42447 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYGaWE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:04:27 -0400
Message-ID: <489236E9.6060804@goop.org>
Date: Thu, 31 Jul 2008 15:04:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Krzysztof Helt <krzysztof.h1@wp.pl>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fdiv bug detection fix
References: <20080731234344.eb3c4ed2.krzysztof.h1@wp.pl> <20080731144920.0016e02d.akpm@linux-foundation.org>
In-Reply-To: <20080731144920.0016e02d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>  		"fwait\n\t"
>>  		"fninit"
>> -		: "=m" (*&boot_cpu_data.fdiv_bug)
>> +		: "=m" (*&fdiv_bug)
>>  		: "m" (*&x), "m" (*&y));
>>     

This (*&foo) construct is strange.  Just "m" (foo) should be enough.

>> +
>> +	boot_cpu_data.fdiv_bug = fdiv_bug;
>>  	if (boot_cpu_data.fdiv_bug)
>>  		printk("Hmm, FPU with FDIV bug.\n");
>>  }
>>     
>
> hm, the code seems to have been that way for quite some time.  I wonder
> why nobody noticed this before.  
>   

It would trash f00f_bug, coma_bug and some padding.  You'd have to be 
running a Cyrix or Intel chip dating from somewhere around 1997-1998 to 
even be subject to those bugs, and even if you were, they wouldn't hurt 
day to day.  And if it snoops for those bugs after the fdiv bug, then 
they'd get updated properly anyway.

Change looks correct.

    J
