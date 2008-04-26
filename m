Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYDZXh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYDZXh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYDZXhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:37:51 -0400
Received: from gw.goop.org ([64.81.55.164]:40388 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYDZXhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:37:50 -0400
Message-ID: <4813BCC7.5040701@goop.org>
Date: Sat, 26 Apr 2008 16:37:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai.lu@sun.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, boot protocol
References: <20080426185516.GA32364@elte.hu>	<alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>	<20080426195407.GA13729@elte.hu> <20080426133928.a6f40caa.akpm@linux-foundation.org>
In-Reply-To: <20080426133928.a6f40caa.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +	memcpy(&early_res[i], &early_res[i + 1],
>> +	       (j - 1 - i) * sizeof(struct early_res));
>>     
>
> nit: memcpy() shouldn't be used for overlapping copies.  It happens to be
> OK (for dst<src) in the kernel implementations.  We hope.
>   

Definitely shouldn't be assumed.  At one point in the distant past I had 
a ppc memcpy which would clobber a destination cacheline before reading 
the source, so source and dest within a cacheline's distance would be 
trouble, regardless of the direction.  Arch-specific code which knows 
about the arch-specific details of memcpy might be safer, I guess, but 
its still fairly brittle.

    J
