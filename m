Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYF2FSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYF2FSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYF2FS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:18:29 -0400
Received: from gw.goop.org ([64.81.55.164]:40353 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYF2FS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:18:29 -0400
Message-ID: <48671B20.5050109@goop.org>
Date: Sat, 28 Jun 2008 22:18:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v4
References: <200806251748.06743.yhlu.kernel@gmail.com>	 <200806271538.46829.yhlu.kernel@gmail.com>	 <200806272247.11971.yhlu.kernel@gmail.com>	 <200806281749.02000.yhlu.kernel@gmail.com> <4866F1DF.50203@goop.org> <86802c440806282140g471515aau6bb07af82770b9db@mail.gmail.com>
In-Reply-To: <86802c440806282140g471515aau6bb07af82770b9db@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> We should really define X_index() to return 0 for folded pagetable level X.
>>  I've had to put similar #ifdefs in other code.  Also, for the purposes of
>> making this code more unifiable, it's probably better to test for "#if
>> PAGETABLE_LEVELS >= 3" rather than for PAE specifically.
>>     
>
> does all cpu support >=3?
>   

Well, x86 32-bit PAE is 3 level, and 64-bit is 4 level; both have a 
meaningful set of pmd operations.

>
>> Is this the same as "extra = (end + PMD_SIZE + 1) & PMD_MASK"?
>>     
>
> extra = end & PMD_MASK;
> extra+ = PMD_SIZE;
>   

OK.  I wasn't sure if your intent was to round up to the next PMD_SIZE 
or add a whole new PMD_SIZE.

    J
