Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYCJPel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYCJPel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYCJPed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:34:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:37558 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYCJPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=iwdHUm6IS1WHY8leYau3+IGOxuy8Uy5ox3SB1a98NtR0D+BXFdxpTQXr6eOSJa5t+Ll0WSWx5aFoYIV3JCNHQG2XjwwZYkZprEPMJmfpT9G/Ljx7+k1sl6oFAn1TlC/ZRdTiw3x/Z3LsmzsqIiwndmpU7HdoiKdhlSPGKeZEtfo=
Message-ID: <47D554B4.6090407@gmail.com>
Date: Mon, 10 Mar 2008 16:33:08 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Sripathi Kodi <sripathik@in.ibm.com>
CC: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, vinay@linux.vnet.ibm.com,
       drepper@redhat.com
Subject: Re: [PATCH] RUSAGE_THREAD
References: <200802051125.50423.sripathik@in.ibm.com> <47BF09DD.7090301@gmail.com> <200802271711.55530.sripathik@in.ibm.com>
In-Reply-To: <200802271711.55530.sripathik@in.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sripathi Kodi wrote:
> On Friday 22 February 2008 23:13, Michael Kerrisk wrote:
>> Sripathi Kodi wrote:
>>> Hi Andrew,
>>>
>>> This adds the RUSAGE_THREAD option for the getrusage system call.
>>> This is essentially Roland's patch from
>>> http://lkml.org/lkml/2008/1/18/589, but the line about RUSAGE_LWP
>>> line has been removed, as suggested by Ulrich and Christoph.
>>>
>>> Thanks,
>>> Sripathi.
>>>
>>> This adds the RUSAGE_THREAD option for the getrusage system call.
>> Sripathi,
>>
>> Could you write some small piece of text for the getrusage.2 man page
>> that describes the intended behavior of RUSAGE_THREAD?
> 
> Michael,
> 
> Please take a look at the following patch to getrusage.2. This is the first
> time I have edited a manpage, so I hope I have done it correctly!
> 
> Also, the RUSAGE_THREAD patch is currently in -mm, but not in mainline
> yet. Hoping that it will make it, I have put a line in the patch that it is 
> supported from 2.6.25 onwards.

Sripathi,

Thanks for the patch -- looks reasonable to me.

I see that RUSAGE_THREAD didin't make the cut for 2.6.25.  If you remember,
could you ping me when it does hit mainline.

Cheers,

Michael


> PS: I fixed spelling error in Ulrich's mail id in the CC list.
> 
> Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
> 
> --- getrusage.2.org	2008-02-27 17:00:57.000000000 +0530
> +++ getrusage.2	2008-02-27 17:01:28.000000000 +0530
> @@ -44,12 +44,22 @@ getrusage \- get resource usage
>  .PP
>  .BR getrusage ()
>  returns current resource usages, for a \fIwho\fP
> -of either 
> +of 
> +.B RUSAGE_THREAD, 
>  .B RUSAGE_SELF
>  or 
>  .BR RUSAGE_CHILDREN .
> -The former asks for resources used by the current process,
> -the latter for resources used by those of its children
> +.PP
> +.B RUSAGE_THREAD 
> +asks for resources used by the calling thread.
> +.PP
> +.B RUSAGE_SELF 
> +asks for resources used by the current process, 
> +which is the sum of resources used by all threads
> +in the process.
> +.PP
> +.B RUSAGE_CHILDREN 
> +asks for resources used by those of its children
>  that have terminated and have been waited for.
>  .PP 
>  .in +0.5i
> @@ -130,6 +140,9 @@ Since Linux 2.6, 
>  and
>  .I ru_nivcsw
>  are also maintained.
> +.PP
> +.B RUSAGE_THREAD
> +is supported only in Linux kernel versions 2.6.25 and above.
>  .SH "SEE ALSO"
>  .BR getrlimit (2),
>  .BR times (2),
> 

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html


