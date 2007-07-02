Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbXGBWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbXGBWU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbXGBWUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:20:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:36614 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534AbXGBWUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:20:15 -0400
Message-ID: <46897A40.9060107@windriver.com>
Date: Mon, 02 Jul 2007 17:20:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] i386 - Fix regression, endless loop in ptrace singlestep
 over an int80
References: <468965D8.7020405@windriver.com> <46897642.9030407@redhat.com>
In-Reply-To: <46897642.9030407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2007 22:19:59.0028 (UTC) FILETIME=[206C9740:01C7BCF7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/02/2007 04:53 PM, Jason Wessel wrote:
>   
>> Attached is a patch with a complete test case to fix the regression
>> introduced by the commit: 635cf99a80f4ebee59d70eb64bb85ce829e4591f.
>>
>> This patch is against kernel 2.6.21 but the fix is applicable to 2.6.21
>> and up.  Prior to the commit that introduced the regression the ltp
>> ptrace tests would complete correctly.  I augmented the test case from
>> the original patch header to include the problem case that shows up in
>> the lpt tests.
>>
>> The brief summary is that the the TIF_SINGLESTEP state needs to be
>> altered on the exit path and not the entry path to a syscall, else it
>> can loop forever on the same instruction right after the syscall is
>> executed in certain cases.
>>     
>
> Where does it loop?
>
>   

On each single step on the pop right after the int80 which writes out to 
the console.  At that point you can issue as many single steps as you 
want and it will not advance any further.

Jason.
